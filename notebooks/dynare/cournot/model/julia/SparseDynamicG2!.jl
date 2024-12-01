function SparseDynamicG2!(T::Vector{<: Real}, g2_v::Vector{<: Real}, y::Vector{<: Real}, x::Vector{<: Real}, params::Vector{<: Real}, steady_state::Vector{<: Real})
    @assert length(T) >= 5
    @assert length(g2_v) == 0
    @assert length(y) == 36
    @assert length(x) == 5
    @assert length(params) == 22
@inbounds begin
end
    return nothing
end

