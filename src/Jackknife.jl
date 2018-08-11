module Jackknife

using Statistics

"""
    Reducer(f)

Type that holds a function and enforces at runtime that the function returns either a
`Real` value or `missing`. This is used internally to sanity check the input for functions
which accept a function argument.
"""
struct Reducer
    f::Function
end
(r::Reducer)(x) = r.f(x)::Union{Real,Missing}

const FuncOrReducer = Union{Function,Reducer}


"""
    Jackknife.leaveoneout(estimator::Function, x::AbstractVector{<:Real})

Estimate the parameter ``\\hat{\\theta}`` using the estimating function `estimator`
for each subsample of `x`, systematically omitting each index one at a time. The
result is a vector of length `length(x)-1` of parameter estimates.
"""
leaveoneout(estimator::Function, x::AbstractVector{T}) where {T<:Union{Real,Missing}} =
    leaveoneout(Reducer(estimator), x)

function leaveoneout(estimator::Reducer, x::AbstractVector{T}) where T<:Union{Real,Missing}
    length(x) > 1 || throw(ArgumentError("The sample must have size > 1"))
    inds = eachindex(x)
    return map(i->estimator(view(x, filter(!isequal(i), inds))), inds)
end


"""
    Jackknife.variance(estimator::Function, x)

Compute the jackknife estimate of the variance of `estimator`, which is given as a
function that computes a point estimate when passed a real-valued vector `x`.
"""
function variance(estimator::FuncOrReducer, x::AbstractVector{T}) where T<:Union{Real,Missing}
    θ = leaveoneout(estimator, x)
    n = length(x)
    return var(θ) * (n - 1)^2 / n
end


"""
    Jackknife.bias(estimator::Function, x)

Compute the jackknife estimate of the bias of `estimator`, which is given as a
function that computes a point estimate when passed a real-valued vector `x`.
"""
function bias(estimator::FuncOrReducer, x::AbstractVector{T}) where {T<:Union{Real,Missing}}
    θ = leaveoneout(estimator, x)
    return (length(x) - 1) * (mean(θ) - estimator(x))
end


"""
    Jackknife.estimate(estimator::Function, x)

Compute the bias-corrected jackknife estimate of the parameter `estimator(x)`.
"""
function estimate(estimator::FuncOrReducer, x::AbstractVector{T}) where T<:Union{Real,Missing}
    θ = leaveoneout(estimator, x)
    n = length(x)
    return n * estimator(x) - (n - 1) * mean(θ)
end

end # module
