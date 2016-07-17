# Jackknife.jl

[![0.4](http://pkg.julialang.org/badges/Jackknife_0.4.svg)](http://pkg.julialang.org/?pkg=Jackknife)
[![0.5](http://pkg.julialang.org/badges/Jackknife_0.5.svg)](http://pkg.julialang.org/?pkg=Jackknife)
[![Travis](https://travis-ci.org/ararslan/Jackknife.jl.svg?branch=master)](https://travis-ci.org/ararslan/Jackknife.jl)
[![Coveralls](https://coveralls.io/repos/github/ararslan/Jackknife.jl/badge.svg?branch=master)](https://coveralls.io/github/ararslan/Jackknife.jl?branch=master)

This package provides [jackknife](https://en.wikipedia.org/wiki/Jackknife_resampling)
resampling and estimation functions for Julia.

## Functions

None of the functions here are exported, so you'll have to call them with the prefix
`Jackknife.` or explicitly import them.

Each function takes the following two arguments:

 * A point estimator, given as a `Function`.
   The function must return a scalar when passed a vector.

 * A real-valued data vector of length > 1.

### Resampling

```julia
leaveoneout(estimator, x)
```
Compute a vector of point estimates based on systematic subsamples of `x` wherein
each index is omitted one at a time.
These are the "leave-one-out" estimates.
The resulting vector will have length `length(x) - 1`.

### Estimation

```julia
variance(estimator, x)
```
The variance of the estimator computed using the jackknife technique.

```julia
bias(estimator, x)
```
The bias of the estimator computed using the jackknife technique.

```julia
estimate(estimator, x)
```
The bias-corrected jackknife estimate of the parameter.
