using Statistics
using Distributions
using StaticArrays
using Base.Threads
using LinearAlgebra  # This includes BLAS

# Function to set number of threads
function set_threads(n)
    if n > 0
        BLAS.set_num_threads(n)
        println("Set BLAS threads to $n")
        if Threads.nthreads() != n
            @warn "Julia threads ($(Threads.nthreads())) don't match requested threads ($n)."
        end
    end
end

# Simulation parameters struct
struct SimParams
    dt::Float64
    ntmax::Int
    NSample::Int
    D::Float64
    L::Float64
    NPCSize::Float64
    NPCLocation::SVector{2, Float64}
    alpha::Float64
end

# Create parameters
function create_params(dt, ntmax, NSample)
    D = 10.0  # microns^2/second
    L = 10.0  # microns
    NPCSize = 0.1  # microns
    NPCLocation = SVector{2, Float64}(-L/2, 0)
    alpha = sqrt(2*D*dt)

    SimParams(dt, ntmax, NSample, D, L, NPCSize, NPCLocation, alpha)
end

# Simulate!
function run_simulation(params::SimParams)
    tCapture = zeros(Float64, params.NSample)

    # Precompute random numbers
    random_numbers = randn(Float64, (2, params.ntmax, params.NSample))

    @threads for iSample in 1:params.NSample
        # initial condition
        x = SVector{2, Float64}(params.L/2, 0)

        t = 0.0
        for nt in 1:params.ntmax
            # dynamics
            x = x .+ params.alpha .* SVector{2, Float64}(random_numbers[:, nt, iSample])

            # boundaries
            x = SVector{2, Float64}(clamp(x[1], -params.L/2, params.L/2), clamp(x[2], -params.L/2, params.L/2))

            # test for NPC capture
            if sum((x .- params.NPCLocation).^2) < params.NPCSize^2
                tCapture[iSample] = t
                break
            end

            t += params.dt
        end
    end
    return tCapture
end

# Set desired number of threads (adjust as needed)
set_threads(min(4, Threads.nthreads()))

# Define simulation parameters
dt = 0.001  # s
ntmax = Int(1e6)
NSample = 2000  # number of samples

# Create parameters
params = create_params(dt, ntmax, NSample)

# Run and time the simulation
println("Running with $(Threads.nthreads()) threads")
start = time()
tCapture = run_simulation(params)
elapsed = time() - start
println("Elapsed time: ", elapsed)

# Basic analysis
println("Mean capture time: ", mean(tCapture))
println("Median capture time: ", median(tCapture))
println("Standard deviation of capture time: ", std(tCapture))#=

NPC:
- Julia version: 
- Author: yunsawa
- Date: 2024-09-09
=#
