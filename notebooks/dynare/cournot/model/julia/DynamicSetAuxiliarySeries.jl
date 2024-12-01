function dynamic_set_auxiliary_series!(ds, params)
#
# Computes auxiliary variables of the dynamic model
#
@inbounds begin
ds.AUX_ENDO_LAG_3_1 .=lag(ds.r);
end
end
