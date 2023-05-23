using CUDA
using HDF5
using MPI
using Printf
using Random

function pi_kernel(x, y, d, n)
    idx = (blockIdx().x-1) * blockDim().x + threadIdx().x
    if idx <= n
        d[idx] = (x[idx] - 0.5)^2 + (y[idx] - 0.5)^2 <= 0.25 ? 1 : 0
    end
    return nothing
end

function approximate_pi_gpu(n::Integer)
    x = CUDA.rand(Float64, n)
    y = CUDA.rand(Float64, n)
    d = CUDA.zeros(Float64, n)

    nblocks = ceil(Int64, n/32)

    @cuda threads=32 blocks=nblocks pi_kernel(x,y,d,n)

    return sum(d)
end

function main()
    n = 100000  # Number of points to generate per rank
    Random.seed!(1234)  # Set a fixed random seed for reproducibility

    dsum = MPI.Allreduce(approximate_pi_gpu(n), MPI.SUM, MPI.COMM_WORLD)

    pi_approx = (4 * dsum) / (n * MPI.Comm_size(MPI.COMM_WORLD))

    if MPI.Comm_rank(MPI.COMM_WORLD) == 0
        @printf "Approximation of π using Monte Carlo method: %.10f\n" pi_approx
        @printf "Error: %.10f\n" abs(pi_approx - π)
    end
    return pi_approx
end

MPI.Init()
if !isinteractive()
    pi_approx = main()
    h5open("pi.h5", "w") do file
        write(file, "pi", pi_approx)
    end
end
