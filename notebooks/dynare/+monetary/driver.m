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
M_.fname = 'monetary';
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
M_.endo_names = cell(11,1);
M_.endo_names_tex = cell(11,1);
M_.endo_names_long = cell(11,1);
M_.endo_names(1) = {'y'};
M_.endo_names_tex(1) = {'{\tilde{y}_{t}}'};
M_.endo_names_long(1) = {'product gap'};
M_.endo_names(2) = {'pi'};
M_.endo_names_tex(2) = {'{\pi_{H,t}}'};
M_.endo_names_long(2) = {'domestic inflation'};
M_.endo_names(3) = {'b'};
M_.endo_names_tex(3) = {'\tilde{b}_{t}'};
M_.endo_names_long(3) = {'Debt Issuance'};
M_.endo_names(4) = {'r'};
M_.endo_names_tex(4) = {'{r_{t}}'};
M_.endo_names_long(4) = {'nominal interest rate'};
M_.endo_names(5) = {'g'};
M_.endo_names_tex(5) = {'\tilde{g}_{t}'};
M_.endo_names_long(5) = {'Fiscal Gap'};
M_.endo_names(6) = {'r_nat'};
M_.endo_names_tex(6) = {'{r^{n}}'};
M_.endo_names_long(6) = {'Natural Interest Rate'};
M_.endo_names(7) = {'a'};
M_.endo_names_tex(7) = {'a_{t}'};
M_.endo_names_long(7) = {'Technology Shock Process AR(1)'};
M_.endo_names(8) = {'c_star'};
M_.endo_names_tex(8) = {'c_{t}^*'};
M_.endo_names_long(8) = {'International Consumption Shock Process AR(1)'};
M_.endo_names(9) = {'xi_pi'};
M_.endo_names_tex(9) = {'\xi_{\pi_{t}}'};
M_.endo_names_long(9) = {'Domestic Price Shock Process AR(1)'};
M_.endo_names(10) = {'xi_r'};
M_.endo_names_tex(10) = {'\xi_{r}_{t}'};
M_.endo_names_long(10) = {'Interest Rate Shock Process AR(1)'};
M_.endo_names(11) = {'xi_g'};
M_.endo_names_tex(11) = {'\xi_{g}_{t}'};
M_.endo_names_long(11) = {'Public Spending Shock Process AR(1)'};
M_.endo_partitions = struct();
M_.param_names = cell(21,1);
M_.param_names_tex = cell(21,1);
M_.param_names_long = cell(21,1);
M_.param_names(1) = {'beta'};
M_.param_names_tex(1) = {'\beta'};
M_.param_names_long(1) = {'Discount Factor'};
M_.param_names(2) = {'alpha'};
M_.param_names_tex(2) = {'\alpha'};
M_.param_names_long(2) = {'Openness Degree'};
M_.param_names(3) = {'phi'};
M_.param_names_tex(3) = {'\phi'};
M_.param_names_long(3) = {'Inverse Labor Supply Elasticity'};
M_.param_names(4) = {'tau'};
M_.param_names_tex(4) = {'\tau'};
M_.param_names_long(4) = {'Effective Income Tax Rate'};
M_.param_names(5) = {'B_BAR'};
M_.param_names_tex(5) = {'\frac{\bar{B}}{\bar{Y}}'};
M_.param_names_long(5) = {'Steady State Debt-GDP Ratio'};
M_.param_names(6) = {'C_BAR'};
M_.param_names_tex(6) = {'\frac{\bar{C}}{\bar{Y}}'};
M_.param_names_long(6) = {'Steady State Consumption-GDP Ratio'};
M_.param_names(7) = {'sigma'};
M_.param_names_tex(7) = {'\sigma'};
M_.param_names_long(7) = {'Inverse EIS'};
M_.param_names(8) = {'theta'};
M_.param_names_tex(8) = {'\theta'};
M_.param_names_long(8) = {'Calvo Probability'};
M_.param_names(9) = {'eta'};
M_.param_names_tex(9) = {'\eta'};
M_.param_names_long(9) = {'Domestic-Imported Goods Substitution Elasticity'};
M_.param_names(10) = {'UPSILON'};
M_.param_names_tex(10) = {'\Upsilon'};
M_.param_names_long(10) = {'Cross-Country Goods Substitution Elasticity'};
M_.param_names(11) = {'gamma_pi'};
M_.param_names_tex(11) = {'\gamma_{\pi}'};
M_.param_names_long(11) = {'Monetary Authority Inflation Gap Response'};
M_.param_names(12) = {'gamma_y'};
M_.param_names_tex(12) = {'\gamma_{y}'};
M_.param_names_long(12) = {'Monetary Authority Output Gap Response'};
M_.param_names(13) = {'gamma_r'};
M_.param_names_tex(13) = {'\gamma_{r}'};
M_.param_names_long(13) = {'Interest Rate Smoothing'};
M_.param_names(14) = {'delta_pi'};
M_.param_names_tex(14) = {'\delta_{\pi}'};
M_.param_names_long(14) = {'Fiscal Authority Inflation Gap Response'};
M_.param_names(15) = {'delta_y'};
M_.param_names_tex(15) = {'\delta_{y}'};
M_.param_names_long(15) = {'Fiscal Authority Output Gap Response'};
M_.param_names(16) = {'delta_g'};
M_.param_names_tex(16) = {'\delta_{g}'};
M_.param_names_long(16) = {'Government Spending Response'};
M_.param_names(17) = {'rho_alpha'};
M_.param_names_tex(17) = {'\rho_{\alpha}'};
M_.param_names_long(17) = {'Technology Shock Persistence'};
M_.param_names(18) = {'rho_c_star'};
M_.param_names_tex(18) = {'\rho_{c}'};
M_.param_names_long(18) = {'International Consumption Shock Persistence'};
M_.param_names(19) = {'rho_pi'};
M_.param_names_tex(19) = {'\rho_{\pi}'};
M_.param_names_long(19) = {'Domestic Price Shock Persistence'};
M_.param_names(20) = {'rho_r'};
M_.param_names_tex(20) = {'\rho_{r}'};
M_.param_names_long(20) = {'Interest Rate Shock Persistence'};
M_.param_names(21) = {'rho_g'};
M_.param_names_tex(21) = {'\rho_{g}'};
M_.param_names_long(21) = {'Public Spending Shock Persistence'};
M_.param_partitions = struct();
M_.exo_det_nbr = 0;
M_.exo_nbr = 5;
M_.endo_nbr = 11;
M_.param_nbr = 21;
M_.orig_endo_nbr = 11;
M_.aux_vars = [];
options_.varobs = cell(5, 1);
options_.varobs(1)  = {'y'};
options_.varobs(2)  = {'pi'};
options_.varobs(3)  = {'b'};
options_.varobs(4)  = {'r'};
options_.varobs(5)  = {'g'};
options_.varobs_id = [ 1 2 3 4 5  ];
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
M_.eq_nbr = 11;
M_.ramsey_eq_nbr = 0;
M_.set_auxiliary_variables = exist(['./+' M_.fname '/set_auxiliary_variables.m'], 'file') == 2;
M_.epilogue_names = {};
M_.epilogue_var_list_ = {};
M_.orig_maximum_endo_lag = 1;
M_.orig_maximum_endo_lead = 1;
M_.orig_maximum_exo_lag = 0;
M_.orig_maximum_exo_lead = 0;
M_.orig_maximum_exo_det_lag = 0;
M_.orig_maximum_exo_det_lead = 0;
M_.orig_maximum_lag = 1;
M_.orig_maximum_lead = 1;
M_.orig_maximum_lag_with_diffs_expanded = 1;
M_.lead_lag_incidence = [
 1 8 19;
 0 9 20;
 0 10 21;
 0 11 0;
 2 12 22;
 0 13 0;
 3 14 0;
 4 15 0;
 5 16 0;
 6 17 0;
 7 18 0;]';
M_.nstatic = 2;
M_.nfwrd   = 2;
M_.npred   = 5;
M_.nboth   = 2;
M_.nsfwrd   = 4;
M_.nspred   = 7;
M_.ndynamic   = 9;
M_.dynamic_tmp_nbr = [10; 0; 0; 0; ];
M_.model_local_variables_dynamic_tt_idxs = {
};
M_.equations_tags = {
  1 , 'name' , 'New Phillips Curve' ;
  2 , 'name' , 'Dynamic IS Curve' ;
  3 , 'name' , 'Government Consolidated Budget Constraint' ;
  4 , 'name' , 'Modified Monetary-Led Policy Rule' ;
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
M_.mapping.g.eqidx = [1 2 3 4 5 ];
M_.mapping.r_nat.eqidx = [2 3 4 6 ];
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
M_.state_var = [1 5 7 8 9 10 11 ];
M_.exo_names_orig_ord = [1:5];
M_.maximum_lag = 1;
M_.maximum_lead = 1;
M_.maximum_endo_lag = 1;
M_.maximum_endo_lead = 1;
oo_.steady_state = zeros(11, 1);
M_.maximum_exo_lag = 0;
M_.maximum_exo_lead = 0;
oo_.exo_steady_state = zeros(5, 1);
M_.params = NaN(21, 1);
M_.endo_trends = struct('deflator', cell(11, 1), 'log_deflator', cell(11, 1), 'growth_factor', cell(11, 1), 'log_growth_factor', cell(11, 1));
M_.NNZDerivatives = [56; 0; -1; ];
M_.static_tmp_nbr = [10; 0; 0; 0; ];
M_.model_local_variables_static_tt_idxs = {
};
options_.TeX =1;
M_.params(1) = 0.99;
beta = M_.params(1);
M_.params(2) = 0.27;
alpha = M_.params(2);
M_.params(3) = 2;
phi = M_.params(3);
M_.params(4) = 0.25;
tau = M_.params(4);
M_.params(5) = 0.21;
B_BAR = M_.params(5);
M_.params(6) = 0.62;
C_BAR = M_.params(6);
M_.params(7) = 3;
sigma = M_.params(7);
M_.params(8) = 0.5;
theta = M_.params(8);
M_.params(9) = 0.69;
eta = M_.params(9);
M_.params(10) = 1;
UPSILON = M_.params(10);
M_.params(11) = 1;
gamma_pi = M_.params(11);
M_.params(12) = 0.4;
gamma_y = M_.params(12);
M_.params(13) = 0.5;
gamma_r = M_.params(13);
M_.params(14) = 0.5;
delta_pi = M_.params(14);
M_.params(15) = 1;
delta_y = M_.params(15);
M_.params(16) = 0.2;
delta_g = M_.params(16);
M_.params(17) = 0.8;
rho_alpha = M_.params(17);
M_.params(18) = 0.8;
rho_c_star = M_.params(18);
M_.params(19) = 0.8;
rho_pi = M_.params(19);
M_.params(20) = 0.8;
rho_r = M_.params(20);
M_.params(21) = 0.8;
rho_g = M_.params(21);
%
% INITVAL instructions
%
options_.initval_file = false;
oo_.steady_state(1) = 0;
oo_.steady_state(2) = 0;
oo_.steady_state(6) = 0.04;
oo_.steady_state(4) = oo_.steady_state(6);
oo_.steady_state(3) = 0;
oo_.steady_state(5) = 0;
oo_.steady_state(7) = 0;
oo_.steady_state(8) = 0;
oo_.steady_state(9) = 0;
oo_.steady_state(10) = 0;
oo_.steady_state(11) = 0;
if M_.exo_nbr > 0
	oo_.exo_simul = ones(M_.maximum_lag,1)*oo_.exo_steady_state';
end
if M_.exo_det_nbr > 0
	oo_.exo_det_simul = ones(M_.maximum_lag,1)*oo_.exo_det_steady_state';
end
options_model_info_ = struct();
model_info(options_model_info_);
resid;
steady;
oo_.dr.eigval = check(M_,options_,oo_);
estim_params_.var_exo = zeros(0, 10);
estim_params_.var_endo = zeros(0, 10);
estim_params_.corrx = zeros(0, 11);
estim_params_.corrn = zeros(0, 11);
estim_params_.param_vals = zeros(0, 10);
estim_params_.param_vals = [estim_params_.param_vals; 7, NaN, (-Inf), Inf, 2, 3, 0.289, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 8, NaN, (-Inf), Inf, 1, 0.5, 0.116, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 9, NaN, (-Inf), Inf, 2, 0.69, 0.289, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 10, NaN, (-Inf), Inf, 2, 1, 0.25, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 11, NaN, (-Inf), Inf, 2, 1, 0.1, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 12, NaN, (-Inf), Inf, 2, 0.4, 0.1, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 13, NaN, (-Inf), Inf, 2, 0.5, 0.1, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 14, NaN, (-Inf), Inf, 2, 0.5, 0.1, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 15, NaN, (-Inf), Inf, 2, 1, 0.1, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 16, NaN, (-Inf), Inf, 2, 0.2, 0.1, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 17, NaN, (-Inf), Inf, 1, 0.8, 0.108, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 18, NaN, (-Inf), Inf, 1, 0.8, 0.1, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 19, NaN, (-Inf), Inf, 1, 0.8, 0.1, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 20, NaN, (-Inf), Inf, 1, 0.8, 0.1, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 21, NaN, (-Inf), Inf, 1, 0.8, 0.1, NaN, NaN, NaN ];
estim_params_.var_exo = [estim_params_.var_exo; 1, NaN, (-Inf), Inf, 4, 2.176, 0.506, NaN, NaN, NaN ];
estim_params_.var_exo = [estim_params_.var_exo; 2, NaN, (-Inf), Inf, 4, 1.22, 0.7, NaN, NaN, NaN ];
estim_params_.var_exo = [estim_params_.var_exo; 3, NaN, (-Inf), Inf, 4, 2.101, 0.202, NaN, NaN, NaN ];
%
% SHOCKS instructions
%
M_.exo_det_length = 0;
M_.Sigma_e(1, 1) = 0.0625;
M_.Sigma_e(2, 2) = 0.4899999999999999;
M_.Sigma_e(3, 3) = 0.0625;
M_.Sigma_e(4, 4) = 0.0625;
M_.Sigma_e(5, 5) = 0.0625;
options_gsa = struct();
options_gsa.graph_format = {'eps';'pdf'};
options_.graph_format = {'eps';'pdf'};
dynare_sensitivity(options_gsa);
options_ident = struct();
options_ident.advanced = 1;
options_ident.graph_format = {'eps';'pdf'};
options_.graph_format = {'eps';'pdf'};
dynare_identification(options_ident);
options_.TeX = true;
options_.irf = 10;
options_.order = 1;
options_.graph_format = {'eps';'pdf'};
var_list_ = {'y';'pi';'b';'r_nat';'r';'g'};
[info, oo_, options_, M_] = stoch_simul(M_, options_, oo_, var_list_);
var_list_ = {'y';'pi';'b';'r_nat';'r';'g'};
rplot(var_list_);
M_.params(8) = 0.01;
theta = M_.params(8);
M_.params(9) = 0.69;
eta = M_.params(9);
M_.params(10) = 1;
UPSILON = M_.params(10);
M_.params(14) = 0.25;
delta_pi = M_.params(14);
M_.params(16) = 0.0103303;
delta_g = M_.params(16);
model_diagnostics(M_,options_,oo_);


oo_.time = toc(tic0);
disp(['Total computing time : ' dynsec2hms(oo_.time) ]);
if ~exist([M_.dname filesep 'Output'],'dir')
    mkdir(M_.dname,'Output');
end
save([M_.dname filesep 'Output' filesep 'monetary_results.mat'], 'oo_', 'M_', 'options_');
if exist('estim_params_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'monetary_results.mat'], 'estim_params_', '-append');
end
if exist('bayestopt_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'monetary_results.mat'], 'bayestopt_', '-append');
end
if exist('dataset_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'monetary_results.mat'], 'dataset_', '-append');
end
if exist('estimation_info', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'monetary_results.mat'], 'estimation_info', '-append');
end
if exist('dataset_info', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'monetary_results.mat'], 'dataset_info', '-append');
end
if exist('oo_recursive_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'monetary_results.mat'], 'oo_recursive_', '-append');
end
if ~isempty(lastwarn)
  disp('Note: warning(s) encountered in MATLAB/Octave code')
end
