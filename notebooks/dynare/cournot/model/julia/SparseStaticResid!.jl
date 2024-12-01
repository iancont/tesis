function SparseStaticResid!(T::Vector{<: Real}, residual::AbstractVector{<: Real}, y::Vector{<: Real}, x::Vector{<: Real}, params::Vector{<: Real})
    @assert length(T) >= 5
    @assert length(residual) == 12
    @assert length(y) == 12
    @assert length(x) == 5
    @assert length(params) == 22
@inbounds begin
    residual[1] = (y[2]) - (y[9]+params[5]*y[2]+T[2]*y[1]-T[1]*y[5]);
    residual[2] = (y[1]) - (y[1]-(y[4]-y[2]-y[6])*1/T[1]);
    residual[3] = (y[3]) - (y[4]-y[6]+T[4]*(y[3]-y[2]+y[5]*params[21]/params[20]+y[1]*(1-params[19]-params[21])/params[20]));
    residual[4] = (y[4]) - (y[10]+(-(T[1]*T[2]))/params[5]*params[22]+params[13]/(T[1]*params[15])*y[1]+params[13]/(T[1]*params[15])*y[1]+T[2]*params[11]/(T[1]*params[13])*y[2]+(1+params[5]+T[1]*T[2])/params[5]*y[4]+(-1)/params[5]*y[12]);
    residual[5] = (y[5]) - (y[11]+T[1]*params[5]/(T[2]+T[1]+T[1]*params[5])*y[5]-params[3]*(T[1]*params[21]-T[1]-T[2]*params[21]+T[1]*params[19]-params[20]*T[3]+T[2]*T[1]*params[20]+T[3]*params[5]*params[20]-T[2]*T[1]*params[5]*params[20])/((T[2]+T[1]+T[1]*params[5])*params[16]*params[5]*params[20])+T[1]/(T[2]+T[1]+T[1]*params[5])*y[5]+T[1]*params[5]*params[14]/((T[2]+T[1]+T[1]*params[5])*params[16])*y[1]-(2+params[5])*T[1]*params[14]/((T[2]+T[1]+T[1]*params[5])*params[16])*y[1]+T[1]*params[14]/((T[2]+T[1]+T[1]*params[5])*params[16])*y[1]-T[1]*params[5]*params[12]*(T[1]-T[2])/((T[2]+T[1]+T[1]*params[5])*params[16])*y[2]+(T[1]-T[2])*T[1]*params[12]/((T[2]+T[1]+T[1]*params[5])*params[16])*y[2]);
    residual[6] = (y[6]) - (y[7]*(params[6]-1)*T[1]*(1+params[4])/(T[1]+params[4])+y[8]*T[5]);
    residual[7] = (y[7]) - (y[7]*params[6]+x[1]);
    residual[8] = (y[8]) - (y[8]*params[7]+x[2]);
    residual[9] = (y[9]) - (y[9]*params[8]+x[3]);
    residual[10] = (y[10]) - (y[10]*params[9]+x[4]);
    residual[11] = (y[11]) - (y[11]*params[10]+x[5]);
    residual[12] = (y[12]) - (y[4]);
end
    if ~isreal(residual)
        residual = real(residual)+imag(residual).^2;
    end
    return nothing
end

