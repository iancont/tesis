function SparseDynamicG1!(T::Vector{<: Real}, g1_v::Vector{<: Real}, y::Vector{<: Real}, x::Vector{<: Real}, params::Vector{<: Real}, steady_state::Vector{<: Real})
    @assert length(T) >= 5
    @assert length(g1_v) == 55
    @assert length(y) == 36
    @assert length(x) == 5
    @assert length(params) == 22
@inbounds begin
g1_v[1]=(-(params[13]/(params[15]*T[2])));
g1_v[2]=(-(params[14]*T[2]/(params[16]*(T[3]+T[2]+params[5]*T[2]))));
g1_v[3]=(-((1+params[5]+T[2]*T[3])/params[5]));
g1_v[4]=(-1);
g1_v[5]=(-(T[2]/(T[3]+T[2]+params[5]*T[2])));
g1_v[6]=(-params[6]);
g1_v[7]=(-params[7]);
g1_v[8]=(-params[8]);
g1_v[9]=(-params[9]);
g1_v[10]=(-params[10]);
g1_v[11]=(-((-1)/params[5]));
g1_v[12]=(-T[3]);
g1_v[13]=1;
g1_v[14]=(-(T[1]*(1-params[19]-params[21])/params[20]));
g1_v[15]=(-(params[13]/(params[15]*T[2])));
g1_v[16]=(2+params[5])*params[14]*T[2]/(params[16]*(T[3]+T[2]+params[5]*T[2]));
g1_v[17]=1;
g1_v[18]=T[1];
g1_v[19]=(-(params[11]*T[3]/(params[13]*T[2])));
g1_v[20]=(-((T[2]-T[3])*params[12]*T[2]/(params[16]*(T[3]+T[2]+params[5]*T[2]))));
g1_v[21]=(-T[1]);
g1_v[22]=1/T[2];
g1_v[23]=(-1);
g1_v[24]=1;
g1_v[25]=T[2];
g1_v[26]=(-1);
g1_v[27]=(-(T[1]*params[21]/params[20]));
g1_v[28]=1;
g1_v[29]=(-(1/T[2]));
g1_v[30]=1;
g1_v[31]=1;
g1_v[32]=(-((params[6]-1)*(1+params[4])*T[2]/(params[4]+T[2])));
g1_v[33]=1;
g1_v[34]=(-T[5]);
g1_v[35]=1;
g1_v[36]=(-1);
g1_v[37]=1;
g1_v[38]=(-1);
g1_v[39]=1;
g1_v[40]=(-1);
g1_v[41]=1;
g1_v[42]=1;
g1_v[43]=(-1);
g1_v[44]=(-(params[14]*params[5]*T[2]/(params[16]*(T[3]+T[2]+params[5]*T[2]))));
g1_v[45]=(-params[5]);
g1_v[46]=(-(1/T[2]));
g1_v[47]=params[12]*params[5]*T[2]*(T[2]-T[3])/(params[16]*(T[3]+T[2]+params[5]*T[2]));
g1_v[48]=1;
g1_v[49]=1;
g1_v[50]=(-(params[5]*T[2]/(T[3]+T[2]+params[5]*T[2])));
g1_v[51]=(-1);
g1_v[52]=(-1);
g1_v[53]=(-1);
g1_v[54]=(-1);
g1_v[55]=(-1);
end
    return nothing
end

