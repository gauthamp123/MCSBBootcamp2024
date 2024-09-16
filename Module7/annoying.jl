using Random
using Plots
using StaticArrays
using Base.Threads  # Import Threads module for multi-threading
#using Distributed


# Add worker processes
#addprocs(4)  # Adjust the number of workers based on your CPU cores


# Numerical parameters
dt = 0.001   # time step in seconds
ntmax = Int(1e6)  # maximum number of time steps

NSample = 2000  # number of samples

# Model parameters
D = 10         # diffusion coefficient in microns^2/second
L = 10         # domain size in microns
NPCSize = 0.1  # size of the nuclear pore complex in microns
NPCLocation = SVector(-L/2, 0.0)  # location of the NPC using StaticArrays
alpha = sqrt(2 * D * dt)  # step size scaling factor

# Data collection
tCapture = zeros(NSample)

# Set up figure
plot(legend = false)
xlabel!("x (μm)")
ylabel!("y (μm)")
xlims!(-L/2, L/2)
ylims!(-L/2, L/2)
scatter!([NPCLocation[1]], [NPCLocation[2]], color = :red, markersize = 10)

# Start simulation
start = time()

@threads for iSample in 1:NSample
    # Initial condition
    x = MVector(L/2, 0.0)
    t = 0.0

    for nt in 1:ntmax
        # Dynamics: update position with random noise
        x += alpha * randn(MVector{2, Float64})  # In-place update with StaticArrays



        # Apply boundaries
        x .= clamp.(x, -L/2, L/2)

        # Test for NPC capture
        if sum((x .- NPCLocation).^2) < NPCSize^2
            tCapture[iSample] = t
            break
        end

        # Update time
        t += dt

        # Visualization (Optional: Uncomment to visualize each step)
        # scatter!([x[1]], [x[2]], color = :blue, markersize = 5)
        # display(gcf())
        # sleep(0.001)  # short pause for visualization update
    end
    
end


# Measure elapsed time
elapsed_time = time() - start
println("Elapsed time: ", elapsed_time)

# Analyze results
histogram(tCapture, bins = :auto, title = "Histogram of tCapture", xlabel = "Capture Time (s)", ylabel = "Frequency")


