function SparseDynamicResid!(T::Vector{<: Real}, residual::AbstractVector{<: Real}, y::Vector{<: Real}, x::Vector{<: Real}, params::Vector{<: Real}, steady_state::Vector{<: Real})
    @assert length(T) >= 5
    @assert length(residual) == 12
    @assert length(y) == 36
    @assert length(x) == 5
    @assert length(params) == 22
@inbounds begin
    residual[1] = (y[14]) - (y[21]+params[5]*y[26]+y[13]*T[3]-y[17]*T[2]);
    residual[2] = (y[13]) - (y[25]-(y[16]-y[26]-y[18])*1/T[2]-(y[29]-y[17]));
    residual[3] = (y[27]) - (y[16]-y[18]+T[1]*(y[15]-y[14]+y[17]*params[21]/params[20]+y[13]*(1-params[19]-params[21])/params[20]));
    residual[4] = (y[16]) - (y[22]+params[22]*(-(T[2]*T[3]))/params[5]+y[1]*params[13]/(params[15]*T[2])+y[13]*params[13]/(params[15]*T[2])+y[14]*params[11]*T[3]/(params[13]*T[2])+y[4]*(1+params[5]+T[2]*T[3])/params[5]+(-1)/params[5]*y[12]);
    residual[5] = (y[17]) - (y[23]+y[29]*params[5]*T[2]/(T[3]+T[2]+params[5]*T[2])-params[3]*(params[21]*T[2]-T[2]-params[21]*T[3]+params[19]*T[2]-params[20]*T[4]+T[3]*params[20]*T[2]+params[5]*params[20]*T[4]-T[3]*params[5]*params[20]*T[2])/(params[16]*params[5]*params[20]*(T[3]+T[2]+params[5]*T[2]))+y[5]*T[2]/(T[3]+T[2]+params[5]*T[2])+y[25]*params[14]*params[5]*T[2]/(params[16]*(T[3]+T[2]+params[5]*T[2]))-y[13]*(2+params[5])*params[14]*T[2]/(params[16]*(T[3]+T[2]+params[5]*T[2]))+y[1]*params[14]*T[2]/(params[16]*(T[3]+T[2]+params[5]*T[2]))-y[26]*params[12]*params[5]*T[2]*(T[2]-T[3])/(params[16]*(T[3]+T[2]+params[5]*T[2]))+y[14]*(T[2]-T[3])*params[12]*T[2]/(params[16]*(T[3]+T[2]+params[5]*T[2])));
    residual[6] = (y[18]) - (y[19]*(params[6]-1)*(1+params[4])*T[2]/(params[4]+T[2])+y[20]*T[5]);
    residual[7] = (y[19]) - (params[6]*y[7]+x[1]);
    residual[8] = (y[20]) - (params[7]*y[8]+x[2]);
    residual[9] = (y[21]) - (params[8]*y[9]+x[3]);
    residual[10] = (y[22]) - (params[9]*y[10]+x[4]);
    residual[11] = (y[23]) - (params[10]*y[11]+x[5]);
    residual[12] = (y[24]) - (y[4]);
end
    return nothing
end

