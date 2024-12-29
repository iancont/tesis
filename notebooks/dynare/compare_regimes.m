clear all; close all; clc;

addpath /usr/lib/dynare/matlab/

dynare nash
irfs_nash = oo_.irfs;
close all;

dynare fiscal
irfs_fiscal = oo_.irfs;
close all;

dynare monetary
irfs_monetary = oo_.irfs;
% close all;

% % Compare Loss Functions

% %----------------------------------------------------------------
% % Social Loss Analysis under Different Scenarios
% %----------------------------------------------------------------

% % Define theta values to evaluate
% param_values = [1.5; 1.0; 0.5; 0.25];

% % Initialize results array
% results = [];

% % Compute losses for each theta value
% for i = 1:length(param_values)
%     % Update theta
%     set_param_value('kappa_upsilon', param_values(i));
    
%     % Compute steady state and simulate
%     steady;
%     stoch_simul(order=1, irf=0) y pi b r g;
    
%     % Locate variables in results
%     y_pos = strmatch('y', M_.endo_names, 'exact');
%     pi_pos = strmatch('pi', M_.endo_names, 'exact');
%     b_pos = strmatch('b', M_.endo_names, 'exact');
%     r_pos = strmatch('r', M_.endo_names, 'exact');
%     g_pos = strmatch('g', M_.endo_names, 'exact');
    
%     % Extract variances
%     var_y = oo_.var(y_pos, y_pos);
%     var_pi = oo_.var(pi_pos, pi_pos);
%     var_b = oo_.var(b_pos, b_pos);
%     var_r = oo_.var(r_pos, r_pos);
%     var_g = oo_.var(g_pos, g_pos);
    
%     % Compute losses
%     L_M = GAMMA_PI*var_pi + GAMMA_Y*var_y + GAMMA_R*(var_r - R_BAR^2);
%     L_F = ZETA_PI*var_pi + ZETA_Y*var_y + ZETA_G*var_g;
%     L_S = L_M + L_F;
    
%     % Store results
%     results = [results; [theta_values(i) sqrt(var_pi) sqrt(var_y) sqrt(var_b) sqrt(var_r) sqrt(var_g) L_M L_F L_S]];
% end

% % % Create results table
% headers = {'θ', 'π_{t,1}', 'ỹ_t', 'b̃_t', 'r_t', 'g̃_t', 'L^M_t', 'L^F_t', 'L^S_t'};
% labels_monetary = repmat({'Stackelberg Monetary Leadership'}, 4, 1);
% labels_fiscal = repmat({'Stackelberg Fiscal Leadership'}, 4, 1);
% labels = [labels_monetary; labels_fiscal];

% % % Display table
% dyntable(options_, 'Table 6: Social Loss Values of Alternative Scenarios', headers, labels, results, size(headers,2), 4, 3);
