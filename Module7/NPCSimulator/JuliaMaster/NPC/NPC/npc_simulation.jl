module NPCSimulation

using Random, LinearAlgebra, Distributed, SharedArrays, StaticArrays

# Numerical parameters
const dt = 0.001  # seconds
const ntmax = Int(1e6)
const NSample = 2000  # number of samples

# Model parameters
const D = 10.0  # microns^2/second
const L = 10.0  # microns
const NPCSize = 0.1  # microns
const NPCLocation = SVector(-L/2, 0.0)
const alpha = sqrt(2 * D * dt)
const NPCSizeSq = NPCSize^2

# Function to run a single simulation
function run_simulation(rng::AbstractRNG)
    x = SVector(L/2, 0.0)
    t = 0.0
    for _ in 1:ntmax
        # Dynamics
        x = x + alpha * SVector(randn(rng), randn(rng))

        # Boundaries
        x = SVector(clamp(x[1], -L/2, L/2), clamp(x[2], -L/2, L/2))

        # Test for NPC capture
        if sum((x - NPCLocation).^2) < NPCSizeSq
            return t
        end

        t += dt
    end
    return Inf
end

# Main simulation
function main()
    addprocs(8)
    @everywhere using Random, LinearAlgebra, StaticArrays

    tCapture = SharedArray{Float64}(NSample)

    start = time()
    @sync @distributed for i in 1:NSample
        tCapture[i] = run_simulation(Random.default_rng())
    end
    elapsed_time = time() - start

    println("Elapsed time: ", elapsed_time)
    println("Mean capture time: ", mean(filter(isfinite, tCapture)))
end

export main

end # module NPCSimulation

# Run the simulation
using .NPCSimulation
NPCSimulation.main()