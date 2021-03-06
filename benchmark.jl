require("candidates.jl")

a = 10^4
b = rand(Int64, a)
c = copy(b)

@time qsort_c_mp!(b, 1, a)
@time qsort_stdlib!(c, 1, a)

@assert issorted(b)
@assert issorted(c)

tic()
toq()

# ------------------------------------------------------- #
# ------------------- Benchmarking ---------------------- #
# ------------------------------------------------------- #

numsims = 10^5
qs_s_times = Array(Float64, numsims)
qs_c_times = Array(Float64, numsims)

for i = 1:numsims

    b = rand(Int64, a)
    c = copy(b)
    d = copy(b)

    tic()
    qsort_c_mp!(c)
    qs_c_times[i] = toq()

    tic()
    qsort_c_mp!(d)
    qs_c_times[i] = toq()

    tic()
    qsort_stdlib!(b)
    qs_s_times[i] = toq()

    @assert issorted(b)
    @assert issorted(c)

end

diff_v = (qs_c_times./qs_s_times)

@show(median(diff_v))
@show(mean(diff_v))
