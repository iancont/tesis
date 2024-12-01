function SparseDynamicResidTT!(T::Vector{<: Real}, y::Vector{<: Real}, x::Vector{<: Real}, params::Vector{<: Real}, steady_state::Vector{<: Real})
@inbounds begin
T[1] = 1/params[5]
T[2] = params[2]/(1+params[3]*(params[2]*params[18]+(1-params[3])*(params[2]*params[17]-1)-1))
T[3] = (1-params[5]*params[1])*(1-params[1])/params[1]*(params[4]+T[2])
T[4] = T[2]^2
T[5] = (params[7]-1)*params[3]*params[4]*(params[2]*params[18]+(1-params[3])*(params[2]*params[17]-1)-1)/(params[4]+T[2])
end
    return nothing
end

