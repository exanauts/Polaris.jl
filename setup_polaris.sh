module load cray-hdf5-parallel
export JULIA_HDF5_PATH=$HDF5_DIR
julia --project -e 'using MPIPreferences; MPIPreferences.use_system_binary()'
julia --project -e 'using Pkg; Pkg.build("MPI"; verbose=true)'

