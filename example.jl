using MPI
using CUDA
using KernelAbstractions
using HDF5

const KA = KernelAbstractions

function main()
    comm = MPI.COMM_WORLD
    rank = MPI.Comm_rank(comm)
    size = MPI.Comm_size(comm)

    # Allocate memory on the GPU
    a = CUDA.zeros(10)
    b = CUDA.zeros(10)
    c = CUDA.zeros(10)

    # Initialize the vectors
    for i in 1:10
        a[i] = rank
        b[i] = size
    end

    # Compute the sum of the vectors on the GPU
    c .= a .+ b

    # Write the result to an HDF5 file
    h5open("output.h5", "w") do file
        write(file, "c", c)
    end
end

MPI.Init()

if !isinteractive()
    main()
end