function SparseStaticResidTT!(T::Vector{<: Real}, y::Vector{<: Real}, x::Vector{<: Real}, params::Vector{<: Real})
@inbounds begin
T[1] = params[2]/(1+params[3]*(params[2]*params[18]+(1-params[3])*(params[2]*params[17]-1)-1))
T[2] = (1-params[5]*params[1])*(1-params[1])/params[1]*(T[1]+params[4])
T[3] = T[1]^2
T[4] = 1/params[5]
T[5] = (params[7]-1)*(params[2]*params[18]+(1-params[3])*(params[2]*params[17]-1)-1)*params[3]*params[4]/(T[1]+params[4])
end
    return nothing
end

