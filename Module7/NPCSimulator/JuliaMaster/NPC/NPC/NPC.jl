# using Plots
using Statistics
using Distributions

# numerical parameters
dt = 0.001  # s
ntmax = Int(1e6)
NSample = 2  # number of samples

# model parameters
D = 10  # microns^2/second
L = 10  # microns
NPCSize = 0.1  # microns
NPCLocation = [-L/2, 0]
alpha = sqrt(2*D*dt)

# data collection
tCapture = zeros(NSample)

# set up figure
# p1 = plot(xlim=(-L/2, L/2), ylim=(-L/2, L/2), xlabel="x (um)", ylabel="y (um)")
# scatter!(p1, [NPCLocation[1]], [NPCLocation[2]], color=:red, markersize=10)

# Simulate!
start = time()
for iSample in 1:NSample
    # initial condition
    x = [L/2, 0]

    t = 0
    for nt in 1:ntmax
        # dynamics
        x = x .+ alpha .* randn(2)

        # boundaries
        x = clamp.(x, -L/2, L/2)

        # test for NPC capture
        if sum((x .- NPCLocation).^2) < NPCSize^2
            tCapture[iSample] = t
            break
        end

        t += dt
        # Uncomment to visualize (note: this will significantly slow down the simulation)
        # scatter!(p1, [x[1]], [x[2]], color=:blue, markersize=2)
        # display(p1)
    end

    # println("Sample $iSample: tCapture = $(tCapture[iSample])")
end
elapsed = time() - start
println("Elapsed time: ", elapsed)

# analyze results
# p2 = histogram(tCapture, bins=:auto, xlabel="Capture Time", ylabel="Frequency")
# display(p2)#=
# NPC:
# - Julia version:
# - Author: yunsawa
# - Date: 2024-09-09
=#
