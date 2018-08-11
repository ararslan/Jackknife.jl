using Jackknife
using Test
using Statistics

using Jackknife: bias, estimate, leaveoneout, variance, Reducer

@test bias(mean, 1:10) == 0.0
@test bias(Reducer(mean), 1:10) == 0.0
@test estimate(mean, 1:10) == mean(1:10)
@test_throws ArgumentError leaveoneout(mean, Int[])
@test_throws ArgumentError leaveoneout(mean, [1])

@test bias(sum, 1:10) == -49.5
@test estimate(sum, 1:10) == 104.5
@test variance(sum, 1:10) == 74.25
@test leaveoneout(sum, 1:10) == collect(54:-1:45)

@test_throws TypeError Reducer(x->"hi")(1)
