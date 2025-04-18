const SWISS_DICT_LOAD_FACTOR = 0.97
const _u8x16 = NTuple{16, VecElement{UInt8}}

"""
    SwissDict([itr])

`SwissDict{K,V}()` constructs a hash table with keys of type `K` and values of type `V`.
Keys are compared with [`isequal`](@ref) and hashed with [`hash`](@ref).
Given a single iterable argument, constructs a [`SwissDict`](@ref) whose key-value pairs
are taken from 2-tuples `(key,value)` generated by the argument.

# Examples
```jldoctest
julia> SwissDict([("A", 1), ("B", 2)])
SwissDict{String, Int64} with 2 entries:
  "A" => 1
  "B" => 2
```

Alternatively, a sequence of pair arguments may be passed.

```jldoctest
julia> SwissDict("A"=>1, "B"=>2)
SwissDict{String, Int64} with 2 entries:
  "A" => 1
  "B" => 2
```
"""
mutable struct SwissDict{K,V} <: AbstractDict{K,V}
    slots::Vector{_u8x16}
    keys::Vector{K}
    vals::Vector{V}
    nbfull::Int
    count::Int
    age::UInt
    idxfloor::Int  # an index <= the indices of all used slots

    function SwissDict{K,V}() where {K, V}
        new(fill(_expand16(0x00),1), Vector{K}(undef, 16), Vector{V}(undef, 16), 0, 0, 0, 1)
    end
    function SwissDict{K,V}(d::SwissDict{K,V}) where {K, V}
        new(copy(d.slots), copy(d.keys), copy(d.vals), d.nbfull, d.count, d.age,
            d.idxfloor)
    end
    function SwissDict{K, V}(slots, keys, vals, nbfull, count, age, idxfloor) where {K, V}
        new(slots, keys, vals, nbfull, count, age, idxfloor)
    end
end
function SwissDict{K,V}(kv) where {K, V}
    h = SwissDict{K,V}()
    for (k,v) in kv
        h[k] = v
    end
    return h
end
SwissDict{K,V}(p::Pair) where {K,V} = setindex!(SwissDict{K,V}(), p.second, p.first)
function SwissDict{K,V}(ps::Pair...) where {K, V}
    h = SwissDict{K,V}()
    sizehint!(h, length(ps))
    for p in ps
        h[p.first] = p.second
    end
    return h
end
SwissDict() = SwissDict{Any,Any}()
SwissDict(kv::Tuple{}) = SwissDict()
Base.copy(d::SwissDict) = SwissDict(d)
Base.empty(d::SwissDict, ::Type{K}, ::Type{V}) where {K, V} = SwissDict{K, V}()

SwissDict(ps::Pair{K,V}...) where {K,V} = SwissDict{K,V}(ps)
SwissDict(ps::Pair...)                  = SwissDict(ps)

function SwissDict(kv)
    try
        dict_with_eltype((K, V) -> SwissDict{K, V}, kv, eltype(kv))
    catch e
        if !isiterable(typeof(kv)) || !all(x->isa(x,Union{Tuple,Pair}),kv)
            throw(ArgumentError("SwissDict(kv): kv needs to be an iterator of tuples or pairs"))
        else
            rethrow(e)
        end
    end
end

# SIMD utilities
@inline _expand16(u::UInt8) = ntuple(i->VecElement(u), Val(16))
_blsr(i::UInt32)= i & (i-Int32(1))

@inline _vcmp_eq(u::_u8x16, v::_u8x16) = Core.Intrinsics.llvmcall(("""
%cmp = icmp eq <16 x i8> %0, %1
%cmp16 = bitcast <16 x i1> %cmp to i16
%res = zext i16 %cmp16 to i32
ret i32 %res
"""), UInt32, Tuple{_u8x16,_u8x16}, u, v)

@inline _vcmp_le(u::_u8x16, v::_u8x16) = Core.Intrinsics.llvmcall(("""
%cmp = icmp ule <16 x i8> %0, %1
%cmp16 = bitcast <16 x i1> %cmp to i16
%res = zext i16 %cmp16 to i32
ret i32 %res
"""), UInt32, Tuple{_u8x16,_u8x16}, u, v)

@inline function _prefetchr(p::Ptr)
    ccall("llvm.prefetch", llvmcall, Cvoid, (Ref{Int8}, Int32, Int32, Int32), Ptr{Int8}(p), 0, 3, 1)
end

@inline function _prefetchw(p::Ptr)
    ccall("llvm.prefetch", llvmcall, Cvoid, (Ref{Int8}, Int32, Int32, Int32), Ptr{Int8}(p), 1, 3, 1)
end

@inline function _hashtag(u::Unsigned)
    #extracts tag between 0x02 and 0xff from lower bits, rotates tag bits to front
    u = u % UInt
    tag = u % UInt8
    if UInt === UInt64
        hi = ((u>>8) | (u<<56)) % Int
    else
        hi = ((u>>8) | (u<<24)) % Int
    end
    tag = tag > 1 ? tag : tag+0x02
    return (hi, tag)
end

Base.@propagate_inbounds function _slotget(slots::Vector{_u8x16}, i::Int)
    @boundscheck 0 < i <= length(slots)*16 || throw(BoundsError(slots, 1 + (i-1)>>4))
    GC.@preserve slots begin
        return unsafe_load(convert(Ptr{UInt8}, pointer(slots)), i)
    end
end

Base.@propagate_inbounds function _slotset!(slots::Vector{_u8x16},  v::UInt8, i::Int)
   @boundscheck 0 < i <= length(slots)*16 || throw(BoundsError(slots, 1 + (i-1)>>4))
    GC.@preserve slots begin
        return unsafe_store!(convert(Ptr{UInt8}, pointer(slots)), v, i)
    end
end

@inline function _find_candidates(v::_u8x16, tag::UInt8)
    match = _vcmp_eq(v, _expand16(tag))
    return (match, v[16].value === 0x00)
end

@inline _find_free(v::_u8x16) = _vcmp_le(v, _expand16(UInt8(1)))

# Basic operations

# get the index where a key is stored, or -1 if not present
ht_keyindex(h::SwissDict, key) = ht_keyindex(h::SwissDict, key, _hashtag(hash(key))...)
function ht_keyindex(h::SwissDict, key, i0, tag)
    slots = h.slots
    keys = h.keys
    sz = length(slots)
    i = i0 & (sz-1)
    _prefetchr(pointer(h.keys, i*16+1))
    _prefetchr(pointer(h.vals, i*16+1))
    #Todo/discuss: _prefetchr(pointer(h.keys, i*16+9))?
    @inbounds while true
        msk = slots[i+1]
        cands, done = _find_candidates(msk, tag)
        while cands != 0
            off = trailing_zeros(cands)
            idx = i*16 + off + 1
            isequal(keys[idx], key) && return idx
            cands = _blsr(cands)
        end
        done && break
        i = (i+1) & (sz-1)
    end
    return -1
end

# get the index where a key is stored, or -pos if not present
# and the key would be inserted at pos
# This version is for use by setindex! and get!. It never rehashes.
ht_keyindex2!(h::SwissDict, key) = ht_keyindex2!(h, key, _hashtag(hash(key))...)
@inline function ht_keyindex2!(h::SwissDict, key, i0, tag)
    slots = h.slots
    keys = h.keys
    sz = length(slots)
    i = i0 & (sz-1)
    _prefetchw(pointer(h.keys, i*16+1))
    _prefetchw(pointer(h.vals, i*16+1))
    #Todo/discuss: _prefetchr(pointer(h.keys, i*16+9))?
    @inbounds while true
        msk = slots[i+1]
        cands, done = _find_candidates(msk, tag)
        while cands != 0
            off = trailing_zeros(cands)
            idx = i*16 + off + 1
            isequal(keys[idx], key) && return idx, tag
            cands = _blsr(cands)
        end
        done && break
        i = (i+1) & (sz-1)
    end
    i = i0 & (sz-1)
    @inbounds while true
        msk = slots[i+1]
        cands = _find_free(msk)
        if cands != 0
            off = trailing_zeros(cands)
            idx = i*16 + off + 1
            return -idx, tag
        end
        i = (i+1) & (sz-1)
    end
end

function _setindex!(h::SwissDict, v, key, index, tag)
    @inbounds h.keys[index] = key
    @inbounds h.vals[index] = v
    h.count += 1
    h.age += 1
    so =  _slotget(h.slots, index)
    h.nbfull += (iszero(index & 0x0f) & (so==0x00))
    _slotset!(h.slots, tag, index)
    if index < h.idxfloor
        h.idxfloor = index
    end
    maybe_rehash_grow!(h)
end

function _delete!(h::SwissDict{K,V}, index) where {K,V}
    # Caller is responsible for maybe shrinking the SwissDict after the deletion.
    isbitstype(K) || isbitsunion(K) || ccall(:jl_arrayunset, Cvoid, (Any, UInt), h.keys, index-1)
    isbitstype(V) || isbitsunion(V) || ccall(:jl_arrayunset, Cvoid, (Any, UInt), h.vals, index-1)
    isboundary = iszero(index & 0x0f) #boundaries: 16, 32, ...
    @inbounds _slotset!(h.slots, ifelse(isboundary, 0x01, 0x00), index)
    h.count -= 1
    h.age += 1
    maybe_rehash_shrink!(h)
end


# fast iteration over active slots.
function _iterslots(h::SwissDict, start::Int)
    i0 = ((start-1) & (length(h.keys)-1))>>4 + 1
    off = (start-1) & 0x0f
    @inbounds sl = _find_free(h.slots[i0>>4 + 1])
    sl = ((~sl & 0xffff)>>off) << off
    return _iterslots(h, (i0, sl))
end

function _iterslots(h::SwissDict, state)
    i, sl = state
    while iszero(sl)
        i += 1
        i <= length(h.slots) || return nothing
        @inbounds msk = h.slots[i]
        sl = _find_free(msk)
        sl = (~sl & 0xffff)
    end
    return ((i-1)*16 + trailing_zeros(sl) + 1, (i, _blsr(sl)))
end

# Dictionary resize logic:
# Guarantee 40% of buckets and 15% of entries free, and at least 25% of entries filled
# growth when > 85% entries full or > 60% buckets full, shrink when <25% entries full.
# >60% bucket full should be super rare outside of very bad hash collisions or
# super long-lived Dictionaries (expected 0.85^16 = 7% buckets full at 85% entries full).
# worst-case hysteresis: shrink at 25% vs grow at 30% if all hashes collide.
# expected hysteresis is 25% to 42.5%.
function maybe_rehash_grow!(h::SwissDict)
        sz = length(h.keys)
        if h.count > sz * SWISS_DICT_LOAD_FACTOR || (h.nbfull-1) * 10 > sz * 6
            rehash!(h, sz<<2)
        end
    end

function maybe_rehash_shrink!(h::SwissDict)
   sz = length(h.keys)
   if h.count*4 < sz && sz > 16
       rehash!(h, sz>>1)
   end
end

function Base.sizehint!(d::SwissDict, newsz)
    newsz = _tablesz(newsz*2)  # *2 for keys and values in same array
    oldsz = length(d.keys)
    # grow at least 25%
    if newsz < (oldsz*5)>>2
        return d
    end
    rehash!(d, newsz)
end

function rehash!(h::SwissDict{K,V}, newsz = length(h.keys)) where {K, V}
    olds = h.slots
    oldk = h.keys
    oldv = h.vals
    sz = length(oldk)
    newsz = _tablesz(newsz)
    (newsz*SWISS_DICT_LOAD_FACTOR) > h.count || (newsz <<= 1)
    h.age += 1
    h.idxfloor = 1
    if h.count == 0
        resize!(h.slots, newsz>>4)
        fill!(h.slots, _expand16(0x00))
        resize!(h.keys, newsz)
        resize!(h.vals, newsz)
        h.nbfull = 0
        return h
    end
    nssz = newsz>>4
    slots = fill(_expand16(0x00), nssz)
    keys = Vector{K}(undef, newsz)
    vals = Vector{V}(undef, newsz)
    age0 = h.age
    nbfull = 0
    is = _iterslots(h, 1)
    count = 0
    @inbounds while is !== nothing
        i, s = is
        k = oldk[i]
        v = oldv[i]
        i0, t = _hashtag(hash(k))
        i = i0 & (nssz-1)
        idx = 0
        while true
            msk = slots[i + 1]
            cands = _find_free(msk)
            if cands != 0
                off = trailing_zeros(cands)
                idx = i*16 + off + 1
                break
            end
            i = (i+1) & (nssz-1)
        end
        _slotset!(slots, t, idx)
        keys[idx] = k
        vals[idx] = v
        nbfull += iszero(idx & 0x0f)
        count += 1
        if h.age != age0
            return rehash!(h, newsz)
        end
        is = _iterslots(h, s)
    end
    h.slots = slots
    h.keys = keys
    h.vals = vals
    h.nbfull = nbfull
    @assert h.age == age0
    @assert h.count == count
    return h
end

Base.isempty(t::SwissDict) = (t.count == 0)
Base.length(t::SwissDict) = t.count

"""
    empty!(collection) -> collection

Remove all elements from a `collection`.

# Examples
```jldoctest
julia> A = SwissDict("a" => 1, "b" => 2)
SwissDict{String, Int64} with 2 entries:
  "a" => 1
  "b" => 2

julia> empty!(A);

julia> A
SwissDict{String, Int64}()
```
"""
function Base.empty!(h::SwissDict{K,V}) where {K, V}
    fill!(h.slots, _expand16(0x00))
    sz = length(h.keys)
    empty!(h.keys)
    empty!(h.vals)
    resize!(h.keys, sz)
    resize!(h.vals, sz)
    h.nbfull = 0
    h.count = 0
    h.age += 1
    h.idxfloor = 1
    return h
end

function Base.setindex!(h::SwissDict{K,V}, v0, key0) where {K, V}
    key = convert(K, key0)
    _setindex!(h, v0, key)
end

function _setindex!(h::SwissDict{K,V}, v0, key::K) where {K, V}
    v = convert(V, v0)
    index, tag = ht_keyindex2!(h, key)

    if index > 0
        h.age += 1
        @inbounds h.keys[index] = key
        @inbounds h.vals[index] = v
    else
        _setindex!(h, v, key, -index, tag)
    end

    return h
end

"""
    get!(collection, key, default)

Return the value stored for the given key, or if no mapping for the key is present, store
`key => default`, and return `default`.

# Examples
```jldoctest
julia> d = SwissDict("a"=>1, "b"=>2, "c"=>3);

julia> get!(d, "a", 5)
1

julia> get!(d, "d", 4)
4

julia> d
SwissDict{String, Int64} with 4 entries:
  "a" => 1
  "b" => 2
  "c" => 3
  "d" => 4
```
"""
Base.get!(h::SwissDict{K,V}, key0, default) where {K,V} = get!(()->default, h, key0)

"""
    get!(f::Function, collection, key)

Return the value stored for the given key, or if no mapping for the key is present, store
`key => f()`, and return `f()`.

This is intended to be called using `do` block syntax:
```julia
get!(dict, key) do
    # default value calculated here
    time()
end
```
"""
function Base.get!(default::Callable, h::SwissDict{K,V}, key0) where {K, V}
    key = convert(K, key0)
    return _get!(default, h, key)
end

function _get!(default::Callable, h::SwissDict{K,V}, key::K) where {K, V}
    index, tag = ht_keyindex2!(h, key)

    index > 0 && return @inbounds h.vals[index]

    age0 = h.age
    v = convert(V, default())
    if h.age != age0
        index, tag = ht_keyindex2!(h, key)
    end
    if index > 0
        h.age += 1
        @inbounds h.keys[index] = key
        @inbounds h.vals[index] = v
    else
        _setindex!(h, v, key, -index, tag)
    end
    return v
end

function Base.getindex(h::SwissDict{K,V}, key) where {K, V}
    index = ht_keyindex(h, key)
    @inbounds return (index < 0) ? throw(KeyError(key)) : h.vals[index]::V
end

"""
    get(collection, key, default)

Return the value stored for the given key, or the given default value if no mapping for the
key is present.

# Examples
```jldoctest
julia> d = SwissDict("a"=>1, "b"=>2);

julia> get(d, "a", 3)
1

julia> get(d, "c", 3)
3
```
"""
function Base.get(h::SwissDict{K,V}, key, default) where {K, V}
    index = ht_keyindex(h, key)
    @inbounds return (index < 0) ? default : h.vals[index]::V
end

"""
    get(f::Function, collection, key)

Return the value stored for the given key, or if no mapping for the key is present, return
`f()`.  Use [`get!`](@ref) to also store the default value in the dictionary.

This is intended to be called using `do` block syntax

```julia
get(dict, key) do
    # default value calculated here
    time()
end
```
"""
function Base.get(default::Callable, h::SwissDict{K,V}, key) where {K, V}
    index = ht_keyindex(h, key)
    @inbounds return (index < 0) ? default() : h.vals[index]::V
end

"""
    haskey(collection, key) -> Bool

Determine whether a collection has a mapping for a given `key`.

# Examples
```jldoctest
julia> D = SwissDict('a'=>2, 'b'=>3)
SwissDict{Char, Int64} with 2 entries:
  'a' => 2
  'b' => 3

julia> haskey(D, 'a')
true

julia> haskey(D, 'c')
false
```
"""
Base.haskey(h::SwissDict, key) = (ht_keyindex(h, key) > 0)
Base.in(key, v::KeySet{<:Any, <:SwissDict}) = (ht_keyindex(v.dict, key) > 0)

"""
    getkey(collection, key, default)

Return the key matching argument `key` if one exists in `collection`, otherwise return `default`.

# Examples
```jldoctest
julia> D = SwissDict('a'=>2, 'b'=>3)
SwissDict{Char, Int64} with 2 entries:
  'a' => 2
  'b' => 3

julia> getkey(D, 'a', 1)
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)

julia> getkey(D, 'd', 'a')
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)
```
"""
function Base.getkey(h::SwissDict{K,V}, key, default) where {K, V}
    index = ht_keyindex(h, key)
    @inbounds return (index<0) ? default : h.keys[index]::K
end

function _pop!(h::SwissDict, index)
    @inbounds val = h.vals[index]
    _delete!(h, index)
    maybe_rehash_shrink!(h)
    return val
end

"""
    pop!(collection, key[, default])

Delete and return the mapping for `key` if it exists in `collection`, otherwise return
`default`, or throw an error if `default` is not specified.

# Examples
```jldoctest
julia> d = SwissDict("a"=>1, "b"=>2, "c"=>3);

julia> pop!(d, "a")
1

julia> pop!(d, "d")
ERROR: KeyError: key "d" not found
Stacktrace:
[...]

julia> pop!(d, "e", 4)
4
```
"""
function Base.pop!(h::SwissDict, key)
    index = ht_keyindex(h, key)
    return index > 0 ? _pop!(h, index) : throw(KeyError(key))
end

function Base.pop!(h::SwissDict, key, default)
    index = ht_keyindex(h, key)
    return index > 0 ? _pop!(h, index) : default
end

function Base.pop!(h::SwissDict)
    isempty(h) && throw(ArgumentError("SwissDict must be non-empty"))
    is = _iterslots(h, h.idxfloor)
    @assert is !== nothing
    idx, s = is
    @inbounds key = h.keys[idx]
    @inbounds val = h.vals[idx]
    _delete!(h, idx)
    h.idxfloor = idx
    return key => val
end

"""
    delete!(collection, key)

Delete the mapping for the given key in a collection, and return the collection.

# Examples
```jldoctest
julia> d = SwissDict("a"=>1, "b"=>2)
SwissDict{String, Int64} with 2 entries:
  "a" => 1
  "b" => 2

julia> delete!(d, "b")
SwissDict{String, Int64} with 1 entry:
  "a" => 1
```
"""
function Base.delete!(h::SwissDict, key)
    index = ht_keyindex(h, key)
    if index > 0
        _delete!(h, index)
    end
    maybe_rehash_shrink!(h)
    return h
end

Base.@propagate_inbounds function Base.iterate(h::SwissDict, state = h.idxfloor)
    is = _iterslots(h, state)
    is === nothing && return nothing
    i, s = is
    @inbounds p = h.keys[i] => h.vals[i]
    return (p, s)
end

Base.@propagate_inbounds function Base.iterate(v::Union{KeySet{<:Any, <:SwissDict}, Base.ValueIterator{<:SwissDict}}, state=v.dict.idxfloor)
    is = _iterslots(v.dict, state)
    is === nothing && return nothing
    i, s = is
    return (v isa KeySet ? v.dict.keys[i] : v.dict.vals[i], s)
end
