
module Experiments

using ControlSystemsBase

export deviation

function deviation(sysd::StateSpace{<:Discrete}, z_0::AbstractVector{:<Real}, K::AbstractMatrix{:<Real}; H::Integer=100)
    # TODO:
    #  1. calculate the norminal trajectory
    #  2. allow 1-bit modification
    #    a) how to flip 1 bit in floating point number
    #    b) how to calculate the reachable sets from the bit flips
    # lsim(sysd)
    A, B, C, D = ssdata(sysd)
    p, r = size(B)
    z = zeros(p + r, H)
    z[:,1] = z_0
    for i in 2:H+1
        z[i] = 

    # 1-bit modification
    # find how to flip last bit in floating point value u
    z[i] = A * z[1:p, i-1] + B * bit_flipped_u
end

end