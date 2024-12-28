@#define REGIME = 2
@#include "games.mod"

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------
model_info;
model_diagnostics;
write_latex_original_model;
write_latex_parameter_table;
collect_latex_files;
resid;
steady;
check;

%----------------------------------------------------------------
% Shock Specifications
%----------------------------------------------------------------
shocks;
    var eps_a      = 0.25^2; 
    var eps_c_star = 0.7^2;
    var eps_pi     = 0.4^2;
    var eps_r      = 0.6^2;
    var eps_g      = 0.5^2;
end;

%----------------------------------------------------------------
% Impulse Response Analysis
%----------------------------------------------------------------
stoch_simul(order=1, irf=10) y pi b r_nat r g;

