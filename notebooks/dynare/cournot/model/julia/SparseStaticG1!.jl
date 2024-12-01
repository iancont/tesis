function SparseStaticG1!(T::Vector{<: Real}, g1_v::Vector{<: Real}, y::Vector{<: Real}, x::Vector{<: Real}, params::Vector{<: Real})
    @assert length(T) >= 5
    @assert length(g1_v) == 32
    @assert length(y) == 12
    @assert length(x) == 5
    @assert length(params) == 22
@inbounds begin
g1_v[1]=(-T[2]);
g1_v[2]=(-(T[4]*(1-params[19]-params[21])/params[20]));
g1_v[3]=(-(params[13]/(T[1]*params[15])+params[13]/(T[1]*params[15])));
g1_v[4]=(-(T[1]*params[14]/((T[2]+T[1]+T[1]*params[5])*params[16])+T[1]*params[5]*params[14]/((T[2]+T[1]+T[1]*params[5])*params[16])-(2+params[5])*T[1]*params[14]/((T[2]+T[1]+T[1]*params[5])*params[16])));
g1_v[5]=1-params[5];
g1_v[6]=(-(1/T[1]));
g1_v[7]=T[4];
g1_v[8]=(-(T[2]*params[11]/(T[1]*params[13])));
g1_v[9]=(-((T[1]-T[2])*T[1]*params[12]/((T[2]+T[1]+T[1]*params[5])*params[16])-T[1]*params[5]*params[12]*(T[1]-T[2])/((T[2]+T[1]+T[1]*params[5])*params[16])));
g1_v[10]=1-T[4];
g1_v[11]=1/T[1];
g1_v[12]=(-1);
g1_v[13]=1-(1+params[5]+T[1]*T[2])/params[5];
g1_v[14]=(-1);
g1_v[15]=T[1];
g1_v[16]=(-(T[4]*params[21]/params[20]));
g1_v[17]=1-(T[1]*params[5]/(T[2]+T[1]+T[1]*params[5])+T[1]/(T[2]+T[1]+T[1]*params[5]));
g1_v[18]=(-(1/T[1]));
g1_v[19]=1;
g1_v[20]=1;
g1_v[21]=(-((params[6]-1)*T[1]*(1+params[4])/(T[1]+params[4])));
g1_v[22]=1-params[6];
g1_v[23]=(-T[5]);
g1_v[24]=1-params[7];
g1_v[25]=(-1);
g1_v[26]=1-params[8];
g1_v[27]=(-1);
g1_v[28]=1-params[9];
g1_v[29]=(-1);
g1_v[30]=1-params[10];
g1_v[31]=(-((-1)/params[5]));
g1_v[32]=1;
end
    if ~isreal(g1_v)
        g1_v = real(g1_v)+2*imag(g1_v);
    end
    return nothing
end

