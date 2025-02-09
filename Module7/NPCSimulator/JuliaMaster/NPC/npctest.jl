using Statistics
using Distributions
using StaticArrays
using Base.Threads

# Function to set number of threads
function set_threads(n)
    if n > 0
        BLAS.set_num_threads(n)
        println("Set BLAS threads to $n")
        if Threads.nthreads() != n
            @warn "Julia threads ($(Threads.nthreads())) don't match requested threads ($n). Restart Julia with -t $n to change this."
        end
    end
end

# numerical parameters
const dt = 0.001  # s
const ntmax = Int(1e6)
const NSample = 2000  # number of samples

# model parameters
const D = 10.0  # microns^2/second
const L = 10.0  # microns
const NPCSize = 0.1  # microns
const NPCLocation = SVector{2, Float64}(-L/2, 0)
const alpha = sqrt(2*D*dt)

# Simulate!
function run_simulation(NSample)
    tCapture = zeros(Float64, NSample)

    # Precompute random numbers
    random_numbers = randn(Float64, (2, ntmax, NSample))

    @threads for iSample in 1:NSample
        # initial condition
        x = SVector{2, Float64}(L/2, 0)

        t = 0.0
        for nt in 1:ntmax
            # dynamics
            x = x .+ alpha .* SVector{2, Float64}(random_numbers[:, nt, iSample])

            # boundaries
            x = SVector{2, Float64}(clamp(x[1], -L/2, L/2), clamp(x[2], -L/2, L/2))

            # test for NPC capture
            if sum((x .- NPCLocation).^2) < NPCSize^2
                tCapture[iSample] = t
                break
            end

            t += dt
        end
    end
    return tCapture
end

# Set desired number of threads (adjust as needed)
set_threads(4)

# Run and time the simulation
println("Running with $(Threads.nthreads()) threads")
start = time()
tCapture = run_simulation(NSample)
elapsed = time() - start
println("Elapsed time: ", elapsed)

# Basic analysis
println("Mean capture time: ", mean(tCapture))
println("Median capture time: ", median(tCapture))
println("Standard deviation of capture time: ", std(tCapture))
