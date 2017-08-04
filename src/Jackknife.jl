__precompile__()

module Jackknife

"""
    Jackknife.leaveoneout(estimator::Function, x)

Estimate the parameter `estimator(x)` for each subsample of `x`, systematically
omitting each index one at a time. The result is a vector of length `length(x)-1`
of parameter estimates.
"""
function leaveoneout(estimator::Function, x::AbstractVector{<:Real})
    length(x) > 1 || throw(ArgumentError("The sample must have size > 1"))
    inds = eachindex(x)
    return [estimator(x[filter(j -> j != i, inds)]) for i in inds]
end


"""
    Jackknife.variance(estimator::Function, x)

Compute the jackknife estimate of the variance of `estimator`, which is given as a
function that computes a point estimate when passed a real-valued vector `x`.
"""
function variance(estimator::Function, x::AbstractVector{<:Real})
    θ = leaveoneout(estimator, x)
    n = length(x)
    return Base.var(θ) * (n - 1)^2 / n
end


"""
    Jackknife.bias(estimator::Function, x)

Compute the jackknife estimate of the bias of `estimator`, which is given as a
function that computes a point estimate when passed a real-valued vector `x`.
"""
function bias(estimator::Function, x::AbstractVector{<:Real})
    θ = leaveoneout(estimator, x)
    return (length(x) - 1) * (mean(θ) - estimator(x))
end


"""
    Jackknife.estimate(estimator::Function, x)

Compute the bias-corrected jackknife estimate of the parameter `estimator(x)`.
"""
function estimate(estimator::Function, x::AbstractVector{<:Real})
    θ = leaveoneout(estimator, x)
    n = length(x)
    return n * estimator(x) - (n - 1) * mean(θ)
end

end # module
