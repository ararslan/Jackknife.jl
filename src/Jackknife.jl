VERSION >= v"0.4.0" && __precompile__()

module Jackknife

"""
    Jackknife.leaveoneout(estimator::Function, x)

Estimate the parameter `estimator(x)` for each subsample of `x`, systematically
omitting each index one at a time. The result is a vector of length `length(x)`
of parameter estimates.
"""
function leaveoneout{T<:Real}(estimator::Function, x::AbstractVector{T})
    n = length(x)
    n > 1 || throw(ArgumentError("The sample must have size > 1"))

    S = typeof(estimator(x[1]))
    θ = Array{S}(n)

    @inbounds for i = 1:n
        θ[i] = estimator(vcat(x[1:i-1], x[i+1:end]))
    end

    return θ
end


"""
    Jackknife.variance(estimator::Function, x)

Compute the jackknife estimate of the variance of `estimator`, which is given as a
function that computes a point estimate when passed a real-valued vector `x`.
"""
function variance{T<:Real}(estimator::Function, x::AbstractVector{T})
    θ = leaveoneout(estimator, x)
    n = length(x)
    return Base.var(θ) * (n - 1)^2 / n
end


"""
    Jackknife.bias(estimator::Function, x)

Compute the jackknife estimate of the bias of `estimator`, which is given as a
function that computes a point estimate when passed a real-valued vector `x`.
"""
function bias{T<:Real}(estimator::Function, x::AbstractVector{T})
    θ = leaveoneout(estimator, x)
    return (length(x) - 1) * (mean(θ) - estimator(x))
end


"""
    Jackknife.estimate(estimator::Function, x)

Compute the bias-corrected jackknife estimate of the parameter `estimator(x)`.
"""
function estimate{T<:Real}(estimator::Function, x::AbstractVector{T})
    θ = leaveoneout(estimator, x)
    n = length(x)
    return n * estimator(x) - (n - 1) * mean(θ)
end

end # module
