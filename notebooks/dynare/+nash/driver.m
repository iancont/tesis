%
% Status : main Dynare file
%
% Warning : this file is generated automatically by Dynare
%           from model file (.mod)

if isoctave || matlab_ver_less_than('8.6')
    clear all
else
    clearvars -global
    clear_persistent_variables(fileparts(which('dynare')), false)
end
tic0 = tic;
% Define global variables.
global M_ options_ oo_ estim_params_ bayestopt_ dataset_ dataset_info estimation_info ys0_ ex0_
options_ = [];
M_.fname = 'nash';
M_.dynare_version = '5.3';
oo_.dynare_version = '5.3';
options_.dynare_version = '5.3';
%
% Some global variables initialization
%
global_initialization;
M_.exo_names = cell(5,1);
M_.exo_names_tex = cell(5,1);
M_.exo_names_long = cell(5,1);
M_.exo_names(1) = {'eps_a'};
M_.exo_names_tex(1) = {'{\varepsilon^a}'};
M_.exo_names_long(1) = {'Technology Shock'};
M_.exo_names(2) = {'eps_c_star'};
M_.exo_names_tex(2) = {'{\varepsilon^c}'};
M_.exo_names_long(2) = {'International Consumption Shock'};
M_.exo_names(3) = {'eps_pi'};
M_.exo_names_tex(3) = {'{\varepsilon^{\pi}}'};
M_.exo_names_long(3) = {'Domestic Price Shock'};
M_.exo_names(4) = {'eps_r'};
M_.exo_names_tex(4) = {'{\varepsilon^{r}}'};
M_.exo_names_long(4) = {'Interest Rate Shock'};
M_.exo_names(5) = {'eps_g'};
M_.exo_names_tex(5) = {'{\varepsilon^{g}}'};
M_.exo_names_long(5) = {'Public Spending Shock'};
M_.endo_names = cell(12,1);
M_.endo_names_tex = cell(12,1);
M_.endo_names_long = cell(12,1);
M_.endo_names(1) = {'y'};
M_.endo_names_tex(1) = {'\tilde{y}_t'};
M_.endo_names_long(1) = {'Output Gap'};
M_.endo_names(2) = {'pi'};
M_.endo_names_tex(2) = {'\pi_t'};
M_.endo_names_long(2) = {'Domestic Inflation'};
M_.endo_names(3) = {'b'};
M_.endo_names_tex(3) = {'\tilde{b}_{t}'};
M_.endo_names_long(3) = {'Debt Stock'};
M_.endo_names(4) = {'r'};
M_.endo_names_tex(4) = {'r_t'};
M_.endo_names_long(4) = {'Nominal Interest Rate'};
M_.endo_names(5) = {'g'};
M_.endo_names_tex(5) = {'\tilde{g}_t'};
M_.endo_names_long(5) = {'Fiscal Gap'};
M_.endo_names(6) = {'r_nat'};
M_.endo_names_tex(6) = {'{r^{n}}'};
M_.endo_names_long(6) = {'Natural Interest Rate'};
M_.endo_names(7) = {'a'};
M_.endo_names_tex(7) = {'a_t'};
M_.endo_names_long(7) = {'Technology Shock Process AR(1)'};
M_.endo_names(8) = {'c_star'};
M_.endo_names_tex(8) = {'c_t^*'};
M_.endo_names_long(8) = {'International Consumption Shock Process AR(1)'};
M_.endo_names(9) = {'xi_pi'};
M_.endo_names_tex(9) = {'\xi_{\pi}'};
M_.endo_names_long(9) = {'Domestic Price Shock Process AR(1)'};
M_.endo_names(10) = {'xi_r'};
M_.endo_names_tex(10) = {'\xi_{r}'};
M_.endo_names_long(10) = {'Interest Rate Shock Process AR(1)'};
M_.endo_names(11) = {'xi_g'};
M_.endo_names_tex(11) = {'\xi_{g}'};
M_.endo_names_long(11) = {'Public Spending Shock Process AR(1)'};
M_.endo_names(12) = {'AUX_ENDO_LAG_3_1'};
M_.endo_names_tex(12) = {'AUX\_ENDO\_LAG\_3\_1'};
M_.endo_names_long(12) = {'AUX_ENDO_LAG_3_1'};
M_.endo_partitions = struct();
M_.param_names = cell(22,1);
M_.param_names_tex = cell(22,1);
M_.param_names_long = cell(22,1);
M_.param_names(1) = {'THETA'};
M_.param_names_tex(1) = {'\theta'};
M_.param_names_long(1) = {'Calvo Probability'};
M_.param_names(2) = {'SIGMA'};
M_.param_names_tex(2) = {'\sigma'};
M_.param_names_long(2) = {'Inverse EIS'};
M_.param_names(3) = {'ALPHA'};
M_.param_names_tex(3) = {'\alpha'};
M_.param_names_long(3) = {'Openness Degree'};
M_.param_names(4) = {'PHI'};
M_.param_names_tex(4) = {'\phi'};
M_.param_names_long(4) = {'Inverse Labor Supply Elasticity'};
M_.param_names(5) = {'BETA'};
M_.param_names_tex(5) = {'\beta'};
M_.param_names_long(5) = {'Discount Factor'};
M_.param_names(6) = {'RHO_ALPHA'};
M_.param_names_tex(6) = {'\rho_{\alpha}'};
M_.param_names_long(6) = {'Productivity Shock Autocorrelation'};
M_.param_names(7) = {'RHO_C_STAR'};
M_.param_names_tex(7) = {'\rho_{c^*}'};
M_.param_names_long(7) = {'Int. Consumption Shock Autocorrelation'};
M_.param_names(8) = {'RHO_PI'};
M_.param_names_tex(8) = {'\rho_{\pi}'};
M_.param_names_long(8) = {'Domestic Price Shock Autocorrelation'};
M_.param_names(9) = {'RHO_R'};
M_.param_names_tex(9) = {'\rho_{r}'};
M_.param_names_long(9) = {'Interest Rate Shock Autocorrelation'};
M_.param_names(10) = {'RHO_G'};
M_.param_names_tex(10) = {'\rho_{g}'};
M_.param_names_long(10) = {'Public Spending Shock Autocorrelation'};
M_.param_names(11) = {'GAMMA_PI'};
M_.param_names_tex(11) = {'\gamma_{\pi}'};
M_.param_names_long(11) = {'Monetary Authority Inflation Gap Response'};
M_.param_names(12) = {'ZETA_PI'};
M_.param_names_tex(12) = {'\zeta_{\pi}'};
M_.param_names_long(12) = {'Fiscal Authority Inflation Gap Response'};
M_.param_names(13) = {'GAMMA_Y'};
M_.param_names_tex(13) = {'\gamma_{y}'};
M_.param_names_long(13) = {'Monetary Authority Output Gap Response'};
M_.param_names(14) = {'ZETA_Y'};
M_.param_names_tex(14) = {'\zeta_{y}'};
M_.param_names_long(14) = {'Fiscal Authority Output Gap Response'};
M_.param_names(15) = {'GAMMA_R'};
M_.param_names_tex(15) = {'\gamma_{r}'};
M_.param_names_long(15) = {'Interest Rate Smoothing'};
M_.param_names(16) = {'ZETA_G'};
M_.param_names_tex(16) = {'\zeta_{g}'};
M_.param_names_long(16) = {'Government Spending Response'};
M_.param_names(17) = {'ETA'};
M_.param_names_tex(17) = {'\eta'};
M_.param_names_long(17) = {'Domestic-Imported Goods Substitution Elasticity'};
M_.param_names(18) = {'UPSILON'};
M_.param_names_tex(18) = {'\upsilon'};
M_.param_names_long(18) = {'Cross-Country Goods Substitution Elasticity'};
M_.param_names(19) = {'TAU'};
M_.param_names_tex(19) = {'\tau'};
M_.param_names_long(19) = {'Effective Income Tax Rate'};
M_.param_names(20) = {'B_BAR'};
M_.param_names_tex(20) = {'\frac{\bar{B}}{\bar{Y}}'};
M_.param_names_long(20) = {'Steady State Debt-GDP Ratio'};
M_.param_names(21) = {'C_BAR'};
M_.param_names_tex(21) = {'\frac{\bar{C}}{\bar{Y}}'};
M_.param_names_long(21) = {'Steady State Consumption-GDP Ratio'};
M_.param_names(22) = {'R_BAR'};
M_.param_names_tex(22) = {'r^*'};
M_.param_names_long(22) = {'Steady State Interest Rate'};
M_.param_partitions = struct();
M_.exo_det_nbr = 0;
M_.exo_nbr = 5;
M_.endo_nbr = 12;
M_.param_nbr = 22;
M_.orig_endo_nbr = 11;
M_.aux_vars(1).endo_index = 12;
M_.aux_vars(1).type = 1;
M_.aux_vars(1).orig_index = 4;
M_.aux_vars(1).orig_lead_lag = -1;
M_.aux_vars(1).orig_expr = 'r(-1)';
M_ = setup_solvers(M_);
M_.Sigma_e = zeros(5, 5);
M_.Correlation_matrix = eye(5, 5);
M_.H = 0;
M_.Correlation_matrix_ME = 1;
M_.sigma_e_is_diagonal = true;
M_.det_shocks = [];
M_.surprise_shocks = [];
M_.heteroskedastic_shocks.Qvalue_orig = [];
M_.heteroskedastic_shocks.Qscale_orig = [];
options_.linear = true;
options_.block = false;
options_.bytecode = false;
options_.use_dll = false;
M_.nonzero_hessian_eqs = [];
M_.hessian_eq_zero = isempty(M_.nonzero_hessian_eqs);
M_.orig_eq_nbr = 11;
M_.eq_nbr = 12;
M_.ramsey_eq_nbr = 0;
M_.set_auxiliary_variables = exist(['./+' M_.fname '/set_auxiliary_variables.m'], 'file') == 2;
M_.epilogue_names = {};
M_.epilogue_var_list_ = {};
M_.orig_maximum_endo_lag = 2;
M_.orig_maximum_endo_lead = 1;
M_.orig_maximum_exo_lag = 0;
M_.orig_maximum_exo_lead = 0;
M_.orig_maximum_exo_det_lag = 0;
M_.orig_maximum_exo_det_lead = 0;
M_.orig_maximum_lag = 2;
M_.orig_maximum_lead = 1;
M_.orig_maximum_lag_with_diffs_expanded = 2;
M_.lead_lag_incidence = [
 1 10 22;
 0 11 23;
 0 12 24;
 2 13 0;
 3 14 25;
 0 15 0;
 4 16 0;
 5 17 0;
 6 18 0;
 7 19 0;
 8 20 0;
 9 21 0;]';
M_.nstatic = 1;
M_.nfwrd   = 2;
M_.npred   = 7;
M_.nboth   = 2;
M_.nsfwrd   = 4;
M_.nspred   = 9;
M_.ndynamic   = 11;
M_.dynamic_tmp_nbr = [5; 0; 0; 0; ];
M_.model_local_variables_dynamic_tt_idxs = {
};
M_.equations_tags = {
  1 , 'name' , 'New Phillips Curve' ;
  2 , 'name' , 'Dynamic IS Curve' ;
  3 , 'name' , 'Government Consolidated Budget Constraint' ;
  4 , 'name' , 'Optimal Monetary Policy Rule' ;
  5 , 'name' , 'Optimal Fiscal Policy Rule' ;
  6 , 'name' , 'Natural Interest Rate' ;
  7 , 'name' , 'Technology AR(1)' ;
  8 , 'name' , 'International Consumption AR(1)' ;
  9 , 'name' , 'Domestic Price AR(1)' ;
  10 , 'name' , 'Interest Rate AR(1)' ;
  11 , 'name' , 'Public Spending AR(1)' ;
};
M_.mapping.y.eqidx = [1 2 3 4 5 ];
M_.mapping.pi.eqidx = [1 2 3 4 5 ];
M_.mapping.b.eqidx = [3 ];
M_.mapping.r.eqidx = [2 3 4 ];
M_.mapping.g.eqidx = [1 2 3 5 ];
M_.mapping.r_nat.eqidx = [2 3 6 ];
M_.mapping.a.eqidx = [6 7 ];
M_.mapping.c_star.eqidx = [6 8 ];
M_.mapping.xi_pi.eqidx = [1 9 ];
M_.mapping.xi_r.eqidx = [4 10 ];
M_.mapping.xi_g.eqidx = [5 11 ];
M_.mapping.eps_a.eqidx = [7 ];
M_.mapping.eps_c_star.eqidx = [8 ];
M_.mapping.eps_pi.eqidx = [9 ];
M_.mapping.eps_r.eqidx = [10 ];
M_.mapping.eps_g.eqidx = [11 ];
M_.static_and_dynamic_models_differ = false;
M_.has_external_function = false;
M_.state_var = [1 4 5 7 8 9 10 11 12 ];
M_.exo_names_orig_ord = [1:5];
M_.maximum_lag = 1;
M_.maximum_lead = 1;
M_.maximum_endo_lag = 1;
M_.maximum_endo_lead = 1;
oo_.steady_state = zeros(12, 1);
M_.maximum_exo_lag = 0;
M_.maximum_exo_lead = 0;
oo_.exo_steady_state = zeros(5, 1);
M_.params = NaN(22, 1);
M_.endo_trends = struct('deflator', cell(12, 1), 'log_deflator', cell(12, 1), 'growth_factor', cell(12, 1), 'log_growth_factor', cell(12, 1));
M_.NNZDerivatives = [55; 0; -1; ];
M_.static_tmp_nbr = [5; 0; 0; 0; ];
M_.model_local_variables_static_tt_idxs = {
};
M_.params(1) = 0.5;
THETA = M_.params(1);
M_.params(2) = 1;
SIGMA = M_.params(2);
M_.params(3) = 0.43;
ALPHA = M_.params(3);
M_.params(4) = 1;
PHI = M_.params(4);
M_.params(5) = 0.99;
BETA = M_.params(5);
M_.params(6) = 0.5;
RHO_ALPHA = M_.params(6);
M_.params(7) = 0.5;
RHO_C_STAR = M_.params(7);
M_.params(8) = 0.5;
RHO_PI = M_.params(8);
M_.params(9) = 0.70;
RHO_R = M_.params(9);
M_.params(10) = 0.5;
RHO_G = M_.params(10);
M_.params(11) = 1.25;
GAMMA_PI = M_.params(11);
M_.params(12) = 0.25;
ZETA_PI = M_.params(12);
M_.params(13) = 0.25;
GAMMA_Y = M_.params(13);
M_.params(14) = 1.25;
ZETA_Y = M_.params(14);
M_.params(15) = 0.7;
GAMMA_R = M_.params(15);
M_.params(16) = 0.25;
ZETA_G = M_.params(16);
M_.params(17) = 0.69;
ETA = M_.params(17);
M_.params(18) = 1;
UPSILON = M_.params(18);
M_.params(19) = 0.0334;
TAU = M_.params(19);
M_.params(20) = 0.53;
B_BAR = M_.params(20);
M_.params(21) = 0.70;
C_BAR = M_.params(21);
M_.params(22) = 0.04;
R_BAR = M_.params(22);
steady;
oo_.dr.eigval = check(M_,options_,oo_);
%
% SHOCKS instructions
%
M_.exo_det_length = 0;
M_.Sigma_e(1, 1) = 0.0625;
M_.Sigma_e(2, 2) = 0.4899999999999999;
M_.Sigma_e(3, 3) = 0.16;
M_.Sigma_e(4, 4) = 0.36;
M_.Sigma_e(5, 5) = 0.25;
options_.irf = 10;
options_.order = 1;
var_list_ = {'y';'pi';'b';'r_nat';'r';'g'};
[info, oo_, options_, M_] = stoch_simul(M_, options_, oo_, var_list_);


oo_.time = toc(tic0);
disp(['Total computing time : ' dynsec2hms(oo_.time) ]);
if ~exist([M_.dname filesep 'Output'],'dir')
    mkdir(M_.dname,'Output');
end
save([M_.dname filesep 'Output' filesep 'nash_results.mat'], 'oo_', 'M_', 'options_');
if exist('estim_params_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'nash_results.mat'], 'estim_params_', '-append');
end
if exist('bayestopt_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'nash_results.mat'], 'bayestopt_', '-append');
end
if exist('dataset_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'nash_results.mat'], 'dataset_', '-append');
end
if exist('estimation_info', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'nash_results.mat'], 'estimation_info', '-append');
end
if exist('dataset_info', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'nash_results.mat'], 'dataset_info', '-append');
end
if exist('oo_recursive_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'nash_results.mat'], 'oo_recursive_', '-append');
end
if ~isempty(lastwarn)
  disp('Note: warning(s) encountered in MATLAB/Octave code')
end
