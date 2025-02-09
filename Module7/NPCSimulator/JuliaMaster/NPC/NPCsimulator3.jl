using Random, LinearAlgebra, Distributed


# numerical parameters
dt = 0.001  # seconds
ntmax = Int(1e6)

NSample = 2000  # number of samples

# model parameters
D = 10  # microns^2/second
L = 10  # microns
NPCSize = 0.1  # microns
NPCLocation = [-L/2, 0.0]

alpha = sqrt(2 * D * dt)

# data collection
tCapture = zeros(NSample)

# Simulate!
start = time()

addprocs(6)

# Use @threads to parallelize the outer loop
@distributed for iSample in 1:NSample
    # initial condition
    x = [L/2, 0.0]
    
    t = 0.0
    for nt in 1:ntmax
        # dynamics
        x .= x + alpha * randn(2)
        
        # boundaries
        x .= clamp.(x, -L/2, L/2)
        
        # test for NPC capture
        if sum((x .- NPCLocation).^2) < NPCSize^2
            tCapture[iSample] = t
            break
        end
        
        t += dt
    end
end

elapsed_time = time() - start
println("Elapsed time: ", elapsed_time)
