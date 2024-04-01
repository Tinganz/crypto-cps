
module Experiments

using ControlSystemsBase

export deviation
export flip_bit

function flip_bit(input::Float32, n::Int)
    bits = reinterpret(UTint32, u)
    flipped = xor(bits, 1 << (n-1))
    reinterpret(Float32, flipped)
end


function deviation(sysd::StateSpace{<:Discrete}, z_0::AbstractVector{<:Real}, K::AbstractMatrix{<:Real}; H::Integer=100)
    # TODO:
    #  1. calculate the norminal trajectory
    #  2. allow 1-bit modification
    #    a) how to flip 1 bit in floating point number
    #    b) how to calculate the reachable sets from the bit flips
    # lsim(sysd)
    A, B, C, D = ssdata(sysd)
    p, r = size(B) #Dimensions of B - p = # of state variables, r = # of control inputs
    z = zeros(p + r, H) #Store both state and input in z, H = timesteps
    z[:,1] = z_0

    #Allocate modified K matrix
    K_bit = similar(K, Float32)
    #for i in 2:H+1
    for i in 2:H
        #numel(K) = m*n (total number of elements in K)
        for j = 1:numel(K)
            #Convert K to Float32 & modify each element
            K_bit[j] = flip_bit(Float32(K[j]), n)
        end
        z[:,i] = A * z[1:p, i-1] + B * K_bit
    end

    # 1-bit modification
    # find how to flip last bit in floating point value u
        # Input is a floating point, and a integer, change it to the single-precision format, then change the last bit. 
    
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

