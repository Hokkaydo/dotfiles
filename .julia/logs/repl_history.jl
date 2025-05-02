# time: 2025-04-02 09:41:28 CEST
# mode: julia
	import Pkg; Pkg.add("POMDPs")
# time: 2025-04-02 09:50:21 CEST
# mode: julia
	max(a for a in 0:4)
# time: 2025-04-02 09:50:37 CEST
# mode: julia
	max(a (for a in 0:4))
# time: 2025-04-02 09:50:41 CEST
# mode: julia
	max(a(for a in 0:4))
# time: 2025-04-02 09:50:58 CEST
# mode: julia
	max(for a in 0:4)
# time: 2025-04-26 18:05:09 CEST
# mode: julia
	a = true
# time: 2025-04-26 18:05:12 CEST
# mode: julia
	a
# time: 2025-04-26 18:05:14 CEST
# mode: julia
	a == 1
# time: 2025-04-26 18:05:16 CEST
# mode: julia
	a == 2
# time: 2025-04-26 18:05:18 CEST
# mode: julia
	a == 0
# time: 2025-04-26 18:05:22 CEST
# mode: julia
	20*a
# time: 2025-04-26 18:59:26 CEST
# mode: julia
	a = [1,2,3]
# time: 2025-04-26 18:59:30 CEST
# mode: julia
	eachindex(a)
# time: 2025-04-26 18:59:38 CEST
# mode: julia
	writelmd(a)
# time: 2025-04-26 18:59:50 CEST
# mode: julia
	a = [1,2,5]
# time: 2025-04-26 18:59:51 CEST
# mode: julia
	eachindex(a)
# time: 2025-04-26 18:59:56 CEST
# mode: julia
	show(eachindex(a))
# time: 2025-04-26 19:00:03 CEST
# mode: julia
	display(eachindex(a))
# time: 2025-05-01 10:54:51 CEST
# mode: julia
	a = [1, 2, 3]
# time: 2025-05-01 10:54:54 CEST
# mode: julia
	a[0]
# time: 2025-05-01 10:54:56 CEST
# mode: julia
	a[1]
# time: 2025-05-01 11:08:09 CEST
# mode: julia
	a = ((1,2,3), 4, (4,5,6))
# time: 2025-05-01 11:08:15 CEST
# mode: julia
	b,c,d = a
# time: 2025-05-01 11:08:17 CEST
# mode: julia
	a
# time: 2025-05-01 11:08:19 CEST
# mode: julia
	b
# time: 2025-05-01 11:08:19 CEST
# mode: julia
	c
# time: 2025-05-01 11:08:20 CEST
# mode: julia
	d
# time: 2025-05-01 11:08:31 CEST
# mode: julia
	(b,c,d), e, (f,g,h) = a
# time: 2025-05-01 11:08:33 CEST
# mode: julia
	b
# time: 2025-05-01 11:08:34 CEST
# mode: julia
	c
# time: 2025-05-01 11:08:34 CEST
# mode: julia
	d
# time: 2025-05-01 11:08:35 CEST
# mode: julia
	e
# time: 2025-05-01 11:08:35 CEST
# mode: julia
	f
# time: 2025-05-01 11:08:36 CEST
# mode: julia
	g
# time: 2025-05-01 11:08:37 CEST
# mode: julia
	h
# time: 2025-05-01 11:46:41 CEST
# mode: julia
	global a = 0
# time: 2025-05-01 11:46:51 CEST
# mode: julia
	function test()
	    a += 4
	end
# time: 2025-05-01 11:46:54 CEST
# mode: julia
	test()
# time: 2025-05-01 11:47:04 CEST
# mode: julia
	function test()
	    a += 4
	end
# time: 2025-05-01 11:47:20 CEST
# mode: julia
	function test()
	    global a
	    a += 4
	end
# time: 2025-05-01 11:47:22 CEST
# mode: julia
	test()
# time: 2025-05-01 11:48:00 CEST
# mode: julia
	function test()
	    if isdefined(:a)
	        global a
	        a += 4
	    end
	end
# time: 2025-05-01 11:48:01 CEST
# mode: julia
	test()
# time: 2025-05-01 11:49:01 CEST
# mode: julia
	function test()
	    @isdefined a
	end
# time: 2025-05-01 11:49:03 CEST
# mode: julia
	test()
# time: 2025-05-01 11:49:18 CEST
# mode: julia
	function test()
	    if @isdefined a
	        global a
	        a += 4
	    end
	end
# time: 2025-05-01 11:49:19 CEST
# mode: julia
	test()
# time: 2025-05-01 11:49:20 CEST
# mode: julia
	a
# time: 2025-05-01 11:49:22 CEST
# mode: julia
	a = 0
# time: 2025-05-01 11:49:24 CEST
# mode: julia
	test()
# time: 2025-05-01 11:49:25 CEST
# mode: julia
	a
# time: 2025-05-01 11:58:38 CEST
# mode: julia
	typemax(Int)
# time: 2025-05-01 11:58:57 CEST
# mode: julia
	Int(1e7)
# time: 2025-05-01 11:59:01 CEST
# mode: julia
	1e7
# time: 2025-05-01 12:14:56 CEST
# mode: julia
	a = true
# time: 2025-05-01 12:15:01 CEST
# mode: julia
	b = true
# time: 2025-05-01 12:15:07 CEST
# mode: julia
	c = 5
# time: 2025-05-01 12:15:09 CEST
# mode: julia
	d = 5
# time: 2025-05-01 12:15:19 CEST
# mode: julia
	(a && c == 5) + (b && d == 5)
# time: 2025-05-01 14:44:31 CEST
# mode: julia
	zeros(2, 5)
# time: 2025-05-01 14:44:58 CEST
# mode: julia
	for i in 1:2
	    for j in 1:5
	        @printf "hello %f" zeros[i][j]
	    end
	end
# time: 2025-05-01 14:45:09 CEST
# mode: julia
	for i in 1:2
	    for j in 1:5
	        @display "hello %f" zeros[i][j]
	    end
	end
# time: 2025-05-01 14:45:17 CEST
# mode: julia
	for i in 1:2
	    for j in 1:5
	        print("hello %f" zeros[i][j])
	    end
	end
# time: 2025-05-01 14:45:23 CEST
# mode: julia
	for i in 1:2
	    for j in 1:5
	        print("hello %f", zeros[i][j])
	    end
	end
# time: 2025-05-01 14:45:33 CEST
# mode: julia
	for i in 1:2
	    for j in 1:5
	        print(zeros[i][j])
	    end
	end
# time: 2025-05-01 14:45:48 CEST
# mode: julia
	a = zeros(2, 5)
# time: 2025-05-01 14:45:51 CEST
# mode: julia
	for i in 1:2
	    for j in 1:5
	        print(a[i][j])
	    end
	end
# time: 2025-05-01 14:45:57 CEST
# mode: julia
	for i in 1:2
	    for j in 1:5
	        print(i, j)
	    end
	end
# time: 2025-05-01 14:46:11 CEST
# mode: julia
	for i in 1:2
	    for j in 1:5
	        print(a[j][i])
	    end
	end
