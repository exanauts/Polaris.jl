#!/bin/bash -l
#PBS -l select=1:system=polaris
#PBS -l place=scatter
#PBS -l walltime=0:10:00
#PBS -l filesystems=home:grand
#PBS -q debug
#PBS -A Oceananigans

cd ${PBS_O_WORKDIR}

# MPI example w/ 4 MPI ranks per node spread evenly across cores
NNODES=`wc -l < $PBS_NODEFILE`
NRANKS_PER_NODE=4
NDEPTH=8
NTHREADS=1
module load cray-hdf5-parallel
# Put in your Julia depot path
export JULIA_DEPOT_PATH=MY_JULIA_DEPOT_PATH
echo Julia depot path: $JULIA_DEPOT_PATH
# Path to Julia executable. When using juliaup, it's in your julia_depot folder
JULIA_PATH=$JULIA_DEPOT_PATH/juliaup/julia-1.9.1+0.x64.linux.gnu/bin/julia

NTOTRANKS=$(( NNODES * NRANKS_PER_NODE ))
echo "NUM_OF_NODES= ${NNODES} TOTAL_NUM_RANKS= ${NTOTRANKS} RANKS_PER_NODE=${NRANKS_PER_NODE} THREADS_PER_RANK= ${NTHREADS}"

mpiexec -n ${NTOTRANKS} --ppn ${NRANKS_PER_NODE} --depth=${NDEPTH} --cpu-bind depth $JULIA_PATH --project pi.jl
