using Jackknife
using Test
using Statistics

using Jackknife: bias, estimate, leaveoneout, variance, Reducer

@testset "Bias" begin
    @test bias(mean, 1:10) == 0.0
    @test bias(Reducer(mean), 1:10) == 0.0
    @test bias(sum, 1:10) == -49.5
end

@testset "Estimate" begin
    @test estimate(mean, 1:10) == mean(1:10)
    @test estimate(sum, 1:10) == 104.5
end

@testset "Variance" begin
    @test variance(sum, 1:10) == 74.25
end

@testset "Leave one out" begin
    @test leaveoneout(sum, 1:10) == collect(54:-1:45)
    @test_throws ArgumentError leaveoneout(mean, Int[])
    @test_throws ArgumentError leaveoneout(mean, [1])
end

@testset "Reducer" begin
    @test_throws TypeError Reducer(x->"hi")(1)
end
