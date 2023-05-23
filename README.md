# Polaris.jl
This repository provides an example of how to use the Julia on the Polaris (ALCF) system.

## Getting Started

```bash
julia --project
```
```julia
] up
```

On a login node you may now execute the following to run the example:
```bash
julia --project pi.jl
```

## Job submission
Before submitting your job, make sure you are using the system's HDF5 and MPI library.

```
Submit your job via
```bash
qsub example.jl
```
