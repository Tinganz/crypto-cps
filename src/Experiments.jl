
module Experiments

using ControlSystemsBase

export deviation

function flip_bit(input::Float32, n::Integer)
    bits = reinterpret(UInt32, input)
    flipped = xor(bits, 1 << (n-1))
    reinterpret(Float32, flipped)
end

function flip_z(z::AbstractVector{<:Real}; n::Interger=1)
    last_element = z[end]
    flipped_element = flip_bit(last_element,n)
    z[end] = flipped_element
    return z
end

function deviation(sysd::StateSpace{<:Discrete}, z_0::AbstractVector{<:Real}, K::AbstractMatrix{<:Real}; step_size::Integer=10, H::Integer=100)
    # TODO:
    #  1. calculate the norminal trajectory
    #  2. allow 1-bit modification
    #    a) how to flip 1 bit in floating point number
    #    b) how to calculate the reachable sets from the bit flips
    # lsim(sysd)
    A, B, C, D = ssdata(sysd)
    p, r = size(B) #Dimensions of B - p = # of state variables, r = # of control inputs
    z_nominal = find_nominal(z_0, p+r, A)
    
    
    
end

function find_nominal(z_0::AbstractVector{<:Real}, Φ::AbstractMatrix{<:Real}, z_dimention::Integer; H::Integer=100)
    z = zeros(z_dimention, H+1)
    z[:,1] = z_0
    for i in 2:H+1
        z[:,i] = Φ * z[:,i-1]
    end
    return z
end

function bounded_runs(z_0::AbstractVector{<:Real}, Φ::AbstractMatrix{<:Real}, z_dimention::Integer, step_size::Integer)
    if step_size == 0
        z = zeros(z_dimention, step_size+1)
        z[:,1] = z_0
        return [z]
    else
        prev_values = bounded_runs(z_0, Φ, z_dimention, step_size-1)
        for element in prev_values:
            flipped = element
            element[:, step_size] = Φ * element[:, step_size-1]
            flipped[:, step_size] = Φ * flip_z(element[:, step_size-1])
            push!(prev_values, flipped)
        return prev_values
    end
end
end

function bounded_run_box(z_0::AbstractVector{<:Real}, Φ::AbstractMatrix{<:Real}, nominal::Array{<:AbstractVector{<:Real}, 2}, step_size::Integer)
    trajectories = bounded_runs(z_0, Φ,  step_size)
    max_deviation = -Inf
    min_deviation = Inf
    max_trajectory = nothing
    min_trajectory = nothing
    for trajectory in trajectories
        deviation_value = find_deviation(trajectory, nominal)
        if deviation_value > max_deviation
            max_deviation = deviation_value
            max_trajectory = trajectory
        end
        if deviation_value < min_deviation
            min_deviation = deviation_value
            min_trajectory = trajectory
        end
    end
    return[min_trajectory, max_trajectory]
end

function find_deviation(trajectory::Array{<:AbstractVector{<:Real}, 2}, nominal::Array{<:AbstractVector{<:Real}, 2})

end

end


#OPTION 2 ()
#1. nominal
    # Not flipped, given phi, z[0], find z[1]...z[H]
    
#2. flip function(z)
    # z; q = 1, pos = 10 -> z

#3. bounded_runs -> n
    # z, phi, n -> corners as element of R[(p+q)*2]

#4. bounded_runs_iter -> [H/n]
    # z, phi, n, H -> 

