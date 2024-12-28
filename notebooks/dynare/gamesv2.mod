% =========================================================================
% New Keynesian Model with Calvo Price Rigidities
% Features: Capital, Investment Adjustment Costs, Nonzero Inflation Target
% =========================================================================
% Author: Ian Contreras (contreras.mejia@hotmail.com)
% Version: Nov 30, 2024
% =========================================================================

%----------------------------------------------------------------
% Global configuration
%----------------------------------------------------------------

options_.TeX =1;

%----------------------------------------------------------------
% Variable Declarations
%----------------------------------------------------------------
var 
    y_gap       ${\tilde{y}_{t}}$   (long_name='aggregate output')
    x_gap       ${\tilde{x}_{t}}$   (long_name='product gap')
    pi_h        ${\pi_{H,t}}$       (long_name='domestic inflation')
    b_gap       $\tilde{b}_{t}$  (long_name='Debt Issuance')
    i           ${i_{t}}$           (long_name='nominal interest rate')
    g_gap       $\tilde{g}_{t}$    (long_name='Fiscal Gap')
    r_nat   ${r^{n}}$        (long_name='Natural Interest Rate')
    a       $a_{t}$            (long_name='Technology Shock Process AR(1)')
    c_star  $c_{t}^*$          (long_name='International Consumption Shock Process AR(1)')
    xi_pi   $\xi_{\pi_{t}}$      (long_name='Domestic Price Shock Process AR(1)')
    %xi_r    $\xi_{r}_{t}$        (long_name='Interest Rate Shock Process AR(1)')
    %xi_g    $\xi_{g}_{t}$        (long_name='Public Spending Shock Process AR(1)')
;

%----------------------------------------------------------------
% Exogenous Variables
%----------------------------------------------------------------
varexo
    eps_a       ${\varepsilon^a}$      (long_name='Technology Shock')
    eps_c_star  ${\varepsilon^c}$      (long_name='International Consumption Shock')
    eps_pi      ${\varepsilon^{\pi}}$  (long_name='Domestic Price Shock')
    %eps_r       ${\varepsilon^{r}}$    (long_name='Interest Rate Shock')
    %eps_g       ${\varepsilon^{g}}$    (long_name='Public Spending Shock')
;

%----------------------------------------------------------------
% Parameter Declarations
%----------------------------------------------------------------
parameters
    beta        $\beta$            (long_name='Discount Factor') %Calibrado
    alpha       $\alpha$           (long_name='Openness Degree') %Calibrado
    phi         $\phi$             (long_name='Inverse Labor Supply Elasticity') %Calibrado
    tau         $\tau$           (long_name='Effective Income Tax Rate') %Calibrado
    B_BAR       $\frac{\bar{B}}{\bar{Y}}$  (long_name='Steady State Debt-GDP Ratio') %Calibrado
    C_BAR       $\frac{\bar{C}}{\bar{Y}}$  (long_name='Steady State Consumption-GDP Ratio') %Calibrado
    sigma       $\sigma$           (long_name='Inverse EIS') 
    theta       $\theta$           (long_name='Calvo Probability')
    eta         $\eta$           (long_name='Domestic-Imported Goods Substitution Elasticity') %ETA no puede ser igual a sigma, pq si no la tasa de interes natural se cancela
    UPSILON     $\Upsilon$       (long_name='Cross-Country Goods Substitution Elasticity')
    %central bank loss function parameters
    gamma_pi    $\gamma_{\pi}$     (long_name='Monetary Authority Inflation Gap Response')
    gamma_y    $\gamma_{\tilde{y}}$      (long_name='Monetary Authority Output Gap Response')
    gamma_i     $\gamma_{i}$      (long_name='Interest Rate Smoothing')
    %fiscal authority loss function parameters
    delta_pi    $\delta_{\pi}$     (long_name='Fiscal Authority Inflation Gap Response')
    delta_y     $\delta_{\tilde{y}}$      (long_name='Fiscal Authority Output Gap Response')
    delta_g     $\delta_{g}$      (long_name='Government Spending Response')
;

%----------------------------------------------------------------
% Calibration
%----------------------------------------------------------------
beta = 0.99;
alpha = 0.43;
phi = 1;
tau = 0.0334;
B_BAR = 0.53;
C_BAR = 0.70;
sigma = 1;
theta = 0.5;
eta = 0.69;
UPSILON = 1;
gamma_pi = 1.25;
gamma_y = 0.25;
gamma_i = 0.7;
delta_pi = 0.25;
delta_y = 1.25;
delta_g = 0.25;

%----------------------------------------------------------------
% Model Equations (Linear Form)
%----------------------------------------------------------------
model(linear); 

% Composite Parameters
#omega = sigma * UPSILON + (1-alpha)*(sigma * eta -1); %validado
#sigma_alpha = (sigma)/((1-alpha) * (sigma * omega)); %validado
#lambda = ((1- beta * theta)*(1-theta))/theta; %validado
#kappa = lambda * (sigma_alpha + phi);
#rho = -log(beta);
#THETA = omega-1;
#PSI= -(THETA*sigma_alpha)/(sigma_alpha + phi);
#GAMMA = (1+ phi)/(sigma_alpha+ phi);

% Economy Dynamics
[name='New Phillips Curve']
pi_h = beta * pi_h(+1) + kappa * y_gap - sigma * g_gap + xi_pi;

[name='Dynamic IS Curve']
y_gap = y_gap(+1) - (1/sigma_alpha)*(i-pi_h(+1)-r_nat) - g_gap(+1) + g_gap;

[name='Government Solvency Constraint']
b_gap(+1) = i *B_BAR + (1/beta)*(b_gap - pi_h*B_BAR + C_BAR*g_gap + (1-tau-C_BAR)*y_gap);

[name = 'Natural Interest Rate']
r_nat = rho - sigma_alpha * GAMMA (1-rho_a) * a + alpha * sigma_alpha (THETA + PSI) * (c_star(+1)-c_star); %Si la media de alpha y c_star es cero, entonces hay que exp() c_star y a. 

[name='Product Gap']
x_gap = y_gap - g_gap;

% Policy Agents Rules
if REGIME == 1
@#endif
if REGIME == 2
@#endif
if REGIME == 3
@#endif

% Exogenous Processes
[name='Technology AR(1)']
a = rho_a*a(-1) + eps_a;

[name='International Consumption AR(1)']
c_star = rho_c_star*c_star(-1) + eps_c_star;

[name='Domestic Price AR(1)']
xi_pi = rho_pi*xi_pi(-1) + eps_pi;

[name='Interest Rate AR(1)']
%xi_i = rho_r*xi_r(-1) + eps_r;

[name='Public Spending AR(1)']
%xi_g = rho_g*xi_g(-1) + eps_g;

%----------------------------------------------------------------
% Steady State
%----------------------------------------------------------------
steady_state_model(order=2);
y_gap = 0; %validado
pi_h = 0; %validado
i = r_nat; %validado
g_gap = ; %
b_gap = ;


end;
%----------------------------------------------------------------
% Sensibility Analysis
%----------------------------------------------------------------

varobs y pi b r g;

estimated_params;
    %estimated params
    sigma, gamma_pdf, 0.969, 0.289;
    theta, beta_pdf, 0.343, 0.116;
    eta, gamma_pdf, 1.132, 0.289;
    UPSILON, gamma_pdf, 1, 0.25;

    %central bank
    gamma_pi, gamma_pdf, 1.25, 0.1;
    gamma_y, gamma_pdf, 0.25, 0.1;
    gamma_i, gamma_pdf, 0.7, 0.1;

    %fiscal authority
    delta_pi, gamma_pdf, 0.25, 0.1;
    delta_y, gamma_pdf, 1.25, 0.1;
    delta_g, gamma_pdf, 0.25, 0.1;

    % AR(1) 
    rho_alpha, beta_pdf, 0.626, 0.108;
    rho_c_star, beta_pdf, 0.5, 0.1;
    rho_pi, beta_pdf, 0.5, 0.1;
    %rho_i, beta_pdf, 0.5, 0.1;
    %rho_g, beta_pdf, 0.5, 0.1;

    % Stochastic process
    stderr eps_a, inv_gamma_pdf, 2.176, 0.506;
    stderr eps_c_star, inv_gamma_pdf, 1.22, 0.7;
    stderr eps_pi, inv_gamma_pdf, 2.101, 0.202;
    %stderr eps_i, inv_gamma_pdf, 0.498, 0.237;
    %stderr eps_g, inv_gamma_pdf, 1.359, 0.387;
end;

%----------------------------------------------------------------
% Computation
%----------------------------------------------------------------
model_info;
resid;
steady;
check;

%----------------------------------------------------------------
% Shock Specifications
%----------------------------------------------------------------
dynare_sensitivity(pvalue_ks=0.05);


%---------------------------------------------------------------
% Shock Specifications
%----------------------------------------------------------------
shocks;
    var eps_a      = 0.25^2; 
    var eps_c_star = 0.7^2;
    var eps_pi     = 0.4^2;
    %var eps_i      = 0.6^2;
    %var eps_g      = 0.5^2;
end;

%----------------------------------------------------------------
% Impulse Response Analysis
%----------------------------------------------------------------
stoch_simul(order=1, irf=10,tex) y pi b r_nat r g;

