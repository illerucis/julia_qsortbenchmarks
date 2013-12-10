require("qsorts.jl")

# -------- Compile before running benchmarks ------------ #

function semi_shuffle!(v, times_to_swap)
    for i = 1:times_to_swap
        j = rand(1:length(v))
        k = rand(1:length(v))
        v[j], v[k] = v[k], v[j]
    end
end

a = 10^4
b = rand(Int64, a)
# sort!(b)
# semi_shuffle!(b, length(b) / 4)
c = copy(b)

@time qsort_stdlib!(b, 1, a)
@time qsort_c_mp!(c, 1, a)

tic()
toq()

# ------------------------------------------------------- #
# ------------------- Benchmarking ---------------------- #
# ------------------------------------------------------- #

numsims = 10^4
qs_stdlib_times = Array(Float64, numsims)
qs_c_times = Array(Float64, numsims)

for i = 1:numsims

    b = rand(Int64, a)
    # sort!(b)
    # semi_shuffle!(b, length(b) / 4)
    c = copy(b)

    tic()
    qsort_stdlib!(b)
    qs_stdlib_times[i] = toq()

    tic()
    qsort_c_mp!(c)
    qs_c_times[i] = toq()

    @assert issorted(b)
    @assert issorted(c)

end

diff_v = (qs_c_times./qs_stdlib_times)

@show(median(diff_v))
@show(mean(diff_v))
