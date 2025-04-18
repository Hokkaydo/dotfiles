# test durationstring output at borders
@test ProgressMeter.durationstring(0.9) == "0:00:00"
@test ProgressMeter.durationstring(1.0) == "0:00:01"
@test ProgressMeter.durationstring(59.9) == "0:00:59"
@test ProgressMeter.durationstring(60.0) == "0:01:00"
@test ProgressMeter.durationstring(60*60 - 0.1) == "0:59:59"
@test ProgressMeter.durationstring(60*60) == "1:00:00"
@test ProgressMeter.durationstring(60*60*24 - 0.1) == "23:59:59"
@test ProgressMeter.durationstring(60*60*24) == "1 days, 0:00:00"
@test ProgressMeter.durationstring(60*60*24*10 - 0.1) == "9 days, 23:59:59"
@test ProgressMeter.durationstring(60*60*24*10) == "10.00 days"

@test Progress(5, desc="Progress:", offset=Int16(5)).offset == 5
@test ProgressThresh(0.2, desc="Progress:", offset=Int16(5)).offset == 5

# test speed string formatting
for ns in [1, 9, 10, 99, 100, 999, 1_000, 9_999, 10_000, 99_000, 100_000, 999_999, 1_000_000, 9_000_000, 10_000_000, 99_999_000, 1_234_567_890, 1_234_567_890 * 10, 1_234_567_890 * 100, 1_234_567_890 * 1_000, 1_234_567_890 * 10_000, 1_234_567_890 * 100_000, 1_234_567_890 * 1_000_000, 1_234_567_890 * 10_000_000]
    sec = ns / 1_000_000_000
    try
        @test length(ProgressMeter.speedstring(sec)) == 11
    catch
        @error "ns = $ns caused $(ProgressMeter.speedstring(sec)) (not length 11)"
        throw()
    end
end

# Performance test (from #171, #323)
function prog_perf(n; dt=0.1, enabled=true, force=false, safe_lock=false)
    prog = Progress(n; dt, enabled, safe_lock)
    x = 0.0
    for i in 1:n
        x += rand()
        next!(prog; force)
    end
    return x
end

function noprog_perf(n)
    x = 0.0
    for i in 1:n
        x += rand()
    end
    return x
end

println("Performance tests...")

#precompile
noprog_perf(10)
prog_perf(10)
prog_perf(10; safe_lock=true)
prog_perf(10; dt=9999)
prog_perf(10; enabled=false)
prog_perf(10; enabled=false, safe_lock=true)
prog_perf(10; force=true)

t_noprog = (@elapsed noprog_perf(10^8))/10^8
t_prog = (@elapsed prog_perf(10^8))/10^8
t_lock = (@elapsed prog_perf(10^8; safe_lock=true))/10^8
t_noprint = (@elapsed prog_perf(10^8; dt=9999))/10^8
t_disabled = (@elapsed prog_perf(10^8; enabled=false))/10^8
t_disabled_lock = (@elapsed prog_perf(10^8; enabled=false, safe_lock=true))/10^8
t_force = (@elapsed prog_perf(10^2; force=true))/10^2

println("Performance results:")
println("without progress:     ", ProgressMeter.speedstring(t_noprog))
println("with defaults:        ", ProgressMeter.speedstring(t_prog))
println("with no printing:     ", ProgressMeter.speedstring(t_noprint))
println("with disabled:        ", ProgressMeter.speedstring(t_disabled))
println("with lock:            ", ProgressMeter.speedstring(t_lock))
println("with lock, disabled:  ", ProgressMeter.speedstring(t_disabled_lock))
println("with force:           ", ProgressMeter.speedstring(t_force))

if get(ENV, "CI", "false") == "false" # CI environment is too unreliable for performance tests 
    @test t_prog < 9*t_noprog
end

# Avoid a NaN due to the estimated print time compensation
# https://github.com/timholy/ProgressMeter.jl/issues/209
prog = Progress(10)
prog.check_iterations = 999
t = time()
prog.tlast = t
@test ProgressMeter.calc_check_iterations(prog, t) == 999

# Test ProgressWrapper
A = rand(3,5,7,11)
prog = Progress(length(A))
wrap = ProgressMeter.ProgressWrapper(A, prog)

@test Base.IteratorSize(wrap) == Base.IteratorSize(A)
@test Base.IteratorEltype(wrap) == Base.IteratorEltype(A)
@test axes(wrap) == axes(A)
@test size(wrap) == size(A)
@test length(wrap) == length(A)
@test eltype(wrap) == eltype(A)
@test collect(wrap) == collect(A)

# Test setproperty! on ProgressCore
prog = Progress(10)
prog.desc = "New description" # in ProgressCore
@test prog.desc == "New description"
prog.n = UInt128(20) # in Progress
@test prog.n == 20
prog.offset = Int8(5) # in ProgressCore
@test prog.offset == 5

# Test safe_lock option, initialization and execution. 
function simple_sum(n; safe_lock = true)
    p = Progress(n; safe_lock)
    s = 0.0
    for i in 1:n
        s += sin(i)^2
        next!(p)
    end
    return s
end
p = Progress(10)
@test p.safe_lock == (Threads.nthreads() > 1)
p = Progress(10; safe_lock = false)
@test p.safe_lock == false
@test simple_sum(10; safe_lock = true) ≈ simple_sum(10; safe_lock = false)
