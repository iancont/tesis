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
    y       ${\tilde{y}_{t}}$   (long_name='product gap')
    pi      ${\pi_{H,t}}$       (long_name='domestic inflation')
    b       $\tilde{b}_{t}$  (long_name='Debt Issuance')
    r       ${r_{t}}$           (long_name='nominal interest rate')
    g       $\tilde{g}_{t}$    (long_name='Fiscal Gap')
    r_nat   ${r^{n}}$        (long_name='Natural Interest Rate')
    a       $a_{t}$            (long_name='Technology Shock Process AR(1)')
    c_star  $c_{t}^*$          (long_name='International Consumption Shock Process AR(1)')
    xi_pi   $\xi_{\pi_{t}}$      (long_name='Domestic Price Shock Process AR(1)')
    xi_r    $\xi_{r}_{t}$        (long_name='Interest Rate Shock Process AR(1)')
    xi_g    $\xi_{g}_{t}$        (long_name='Public Spending Shock Process AR(1)')
;

%----------------------------------------------------------------
% Exogenous Variables
%----------------------------------------------------------------
varexo
    eps_a       ${\varepsilon^a}$      (long_name='Technology Shock')
    eps_c_star  ${\varepsilon^c}$      (long_name='International Consumption Shock')
    eps_pi      ${\varepsilon^{\pi}}$  (long_name='Domestic Price Shock')
    eps_r       ${\varepsilon^{r}}$    (long_name='Interest Rate Shock')
    eps_g       ${\varepsilon^{g}}$    (long_name='Public Spending Shock')
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
    eta         $\eta$           (long_name='Domestic-Imported Goods Substitution Elasticity') %eta no puede ser igual a sigma, pq si no la tasa de interes natural se cancela
    UPSILON     $\Upsilon$       (long_name='Cross-Country Goods Substitution Elasticity')
    
    %central bank loss function parameters
    gamma_pi    $\gamma_{\pi}$     (long_name='Monetary Authority Inflation Gap Response')
    gamma_y     $\gamma_{y}$      (long_name='Monetary Authority Output Gap Response')
    gamma_r     $\gamma_{r}$      (long_name='Interest Rate Smoothing')
    
    %fiscal authority loss function parameters
    delta_pi    $\delta_{\pi}$     (long_name='Fiscal Authority Inflation Gap Response')
    delta_y     $\delta_{y}$      (long_name='Fiscal Authority Output Gap Response')
    delta_g     $\delta_{g}$      (long_name='Government Spending Response')
    
    %AR(1) parameters
    rho_alpha   $\rho_{\alpha}$    (long_name='Technology Shock Persistence')
    rho_c_star  $\rho_{c}$         (long_name='International Consumption Shock Persistence')
    rho_pi      $\rho_{\pi}$       (long_name='Domestic Price Shock Persistence')
    rho_r       $\rho_{r}$         (long_name='Interest Rate Shock Persistence')
    rho_g       $\rho_{g}$         (long_name='Public Spending Shock Persistence')
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
gamma_r = 0.7;
delta_pi = 0.25;
delta_y = 1.25;
delta_g = 0.25;
rho_alpha = 0.5;
rho_c_star = 0.5;
rho_pi = 0.5;     % To be confirmed
rho_r = 0.70;
rho_g = 0.5;

%----------------------------------------------------------------
% Model Equations (Linear Form)
%----------------------------------------------------------------
model(linear); 

% Composite Parameters
#omega = sigma * UPSILON + (1-alpha)*(sigma * eta -1);
#sigma_alpha = (sigma)/(1+alpha*(omega-1));
#lambda = ((1- beta * theta)*(1-theta))/theta;
#kappa_upsilon = lambda * (sigma_alpha + phi);

% 1. New Phillips Curve
[name='New Phillips Curve']
pi = beta*pi(+1) + kappa_upsilon*y - sigma_alpha*g + xi_pi ;

% 2. Dynamic IS Curve
[name='Dynamic IS Curve']
y = y(+1) - (1/sigma_alpha)*(r-pi(+1)-r_nat) - (g(+1)-g);

% 3. Government Consolidated Budget Constraint
[name='Government Consolidated Budget Constraint']
b(+1) = (r-r_nat) + (1/beta)*(b - pi + (C_BAR/B_BAR)*g + ((1-tau-C_BAR)/(B_BAR))*y);

% Common Parameters for Regimes 1 and 3 Monetary Rule
#OMICRON_R_LAG1 = (sigma_alpha*kappa_upsilon + beta + 1)/beta;
#OMICRON_R_LAG2 = -1/beta;
#OMICRON_PI = (gamma_pi*kappa_upsilon)/(gamma_y*sigma_alpha);
#OMICRON_Y = gamma_y/(gamma_r*sigma_alpha);
#OMICRON_R_TAR = -(sigma_alpha*kappa_upsilon)/beta;

% Common Parameters for Regimes 1 and 2 Fiscal Rule
#D = beta*sigma_alpha + sigma_alpha + kappa_upsilon;
#PSI_G_PLUS = (beta*sigma_alpha)/D;
#PSI_G_LAG = sigma_alpha/D;
#PSI_Y_PLUS = (beta*sigma_alpha*delta_y)/(delta_g*D);
#PSI_Y_0 = (delta_y*sigma_alpha*(beta+2))/(delta_g*D);
#PSI_Y_LAG = (delta_y*sigma_alpha)/(delta_g*D);
#PSI_PI_PLUS = (beta*sigma_alpha*delta_pi*(sigma_alpha-kappa_upsilon))/(delta_g*D);
#PSI_PI_0 = (sigma_alpha*delta_pi*(sigma_alpha-kappa_upsilon))/(delta_g*D);
#CONS = (alpha*(-sigma_alpha + C_BAR*sigma_alpha - C_BAR*kappa_upsilon + tau*sigma_alpha - B_BAR*sigma_alpha^2 + B_BAR*sigma_alpha*kappa_upsilon + B_BAR*beta*sigma_alpha^2 - B_BAR*beta*sigma_alpha*kappa_upsilon))/(B_BAR*beta*delta_g*D);

@#if REGIME == 1
% Regime 1: Original Implementation
[name='Optimal Monetary Policy Rule']
r = OMICRON_R_LAG1*r(-1) + OMICRON_R_LAG2*r(-2) + OMICRON_PI*pi + OMICRON_Y*y + OMICRON_Y*y(-1) + OMICRON_R_TAR*r_nat  + xi_r;

[name='Optimal Fiscal Policy Rule']
g = -CONS + PSI_G_PLUS*g(+1) + PSI_G_LAG*g(-1) + PSI_Y_PLUS*y(+1) - PSI_Y_0*y + PSI_Y_LAG*y(-1) - PSI_PI_PLUS*pi(+1) + PSI_PI_0*pi + xi_g;

@#endif

@#if REGIME == 2
% Regime 2: Modified Monetary-Led Policy
#V = gamma_y*beta*sigma_alpha + gamma_y*sigma_alpha + gamma_y*kappa_upsilon + gamma_r*beta*sigma_alpha^3 + gamma_r*sigma_alpha^3 + gamma_r*sigma_alpha^2*kappa_upsilon;

#UPSILON_G_PLUS = (gamma_y*sigma_alpha*(kappa_upsilon+sigma_alpha))/V;

#UPSILON_G_LAG = (gamma_y*sigma_alpha^2)/V;

#UPSILON_Y_PLUS = (gamma_y*sigma_alpha*(delta_g*kappa_upsilon+delta_g*beta*sigma_alpha+delta_g*sigma_alpha+beta*sigma_alpha*delta_y))/(delta_g*V);

#UPSILON_Y_0 = (gamma_y*delta_g*sigma_alpha^2*(beta+2))/(delta_g*V);

#UPSILON_Y_LAG = (gamma_y*delta_y*sigma_alpha^2)/(delta_g*V);

#UPSILON_PI_PLUS = (gamma_y*(-beta*sigma_alpha^2*delta_pi-delta_g*beta*sigma_alpha-delta_g*sigma_alpha+beta*sigma_alpha^3*delta_pi-delta_g*kappa_upsilon))/(delta_g*V);

#UPSILON_PI_0 = (gamma_y*delta_pi*sigma_alpha^2*(sigma_alpha-kappa_upsilon))/(delta_g*V);

#UPSILON_RN = gamma_y/(gamma_r*sigma_alpha^2+gamma_y);

#K = (gamma_y * sigma_alpha * alpha*(sigma_alpha*tau-sigma_alpha - C_BAR*kappa_upsilon + sigma_alpha ^2 * B_BAR * beta - sigma_alpha * B_BAR* beta * kappa_upsilon - sigma_alpha ^2 *B_BAR + sigma_alpha * C_BAR + sigma_alpha * B_BAR* kappa_upsilon))/(delta_g * B_BAR * beta * V);

[name='Modified Monetary-Led Policy Rule']
r = K - UPSILON_G_PLUS * g(+1) + UPSILON_G_LAG * g(-1) + UPSILON_Y_PLUS * y(+1) - UPSILON_Y_0 * y + UPSILON_Y_LAG * y(-1) + UPSILON_PI_PLUS * pi(+1) - UPSILON_PI_0 * pi + r_nat  + UPSILON_RN * r_nat + xi_r;

[name='Optimal Fiscal Policy Rule']
g = -CONS + PSI_G_PLUS*g(+1) + PSI_G_LAG*g(-1) + PSI_Y_PLUS*y(+1) - PSI_Y_0*y + PSI_Y_LAG*y(-1) - PSI_PI_PLUS*pi(+1) + PSI_PI_0*pi + xi_g;

@#endif

@#if REGIME == 3
% Regime 3: Non-Cooperative Nash Policy
[name='Optimal Monetary Policy Rule']
r = OMICRON_R_LAG1*r(-1) + OMICRON_R_LAG2*r(-2) + OMICRON_PI*pi + OMICRON_Y*y + OMICRON_Y*y(-1) + OMICRON_R_TAR*r_nat  + xi_r;

#J = delta_g + delta_y + delta_pi*sigma_alpha^2;

#W = (delta_pi*sigma_alpha)/J;

#XI_G_PLUS = delta_y/J;

#XI_R_BAR = (delta_y*kappa_upsilon)/(beta*J);

#XI_R_NAT = delta_y/(sigma_alpha*J);

#XI_R_LAG = (delta_y*(sigma_alpha*kappa_upsilon+beta+1))/(sigma_alpha*beta*J);

#XI_R_LAG_2 = delta_y/(sigma_alpha*beta*J);

#XI_PI_PLUS = (-delta_pi*sigma_alpha^2*beta+delta_y)/(sigma_alpha*J);

#XI_PI_0 = (delta_y*gamma_y*kappa_upsilon)/(sigma_alpha^2*gamma_r*J);

#XI_Y_PLUS = delta_y/J;

#XI_Y_0 = (delta_y*gamma_y+delta_pi*sigma_alpha^2*gamma_r*kappa_upsilon)/(sigma_alpha^2*gamma_r*J);

#XI_Y_LAG = (delta_y*gamma_y)/(sigma_alpha^2*gamma_r*J);

[name='Non-Cooperative Nash Fiscal Policy Rule']
g = XI_G_PLUS*g(+1) - XI_R_BAR*r_nat - XI_R_NAT * r_nat - XI_R_LAG*r(-1) - XI_R_LAG_2*r(-2) - XI_PI_PLUS * pi(+1) + XI_PI_0* pi - XI_Y_PLUS*y(+1) + XI_Y_0*y - XI_Y_LAG*y(-1) + W*xi_pi + xi_g;

@#endif

% Exogenous Processes
[name='Natural Interest Rate']
r_nat = ((sigma_alpha*(1 + phi)*(rho_alpha-1))/(sigma_alpha + phi))*a + ((phi*alpha*(omega-1))/(sigma_alpha + phi))*(rho_c_star-1)*c_star;

[name='Technology AR(1)']
a = rho_alpha*a(-1) + eps_a;

[name='International Consumption AR(1)']
c_star = rho_c_star*c_star(-1) + eps_c_star;

[name='Domestic Price AR(1)']
xi_pi = rho_pi*xi_pi(-1) + eps_pi;

[name='Interest Rate AR(1)']
xi_r = rho_r*xi_r(-1) + eps_r;

[name='Public Spending AR(1)']
xi_g = rho_g*xi_g(-1) + eps_g;

end;



%----------------------------------------------------------------
% Steady State
%----------------------------------------------------------------
initval;
y = 0; %validado
pi= 0; %validado
r_nat = 0.04;
r = r_nat; %validado
b = 0;
g = 0;
a= 0;
c_star= 0;
xi_pi= 0;
xi_r= 0;
xi_g= 0;
end;

%----------------------------------------------------------------
% Computation
%----------------------------------------------------------------
model_info;
resid;
steady;
check;

%----------------------------------------------------------------
% Priors distributions
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
    gamma_r, gamma_pdf, 0.7, 0.1;

    %fiscal authority
    delta_pi, gamma_pdf, 0.25, 0.1;
    delta_y, gamma_pdf, 1.25, 0.1;
    delta_g, gamma_pdf, 0.25, 0.1;

    % AR(1) 
    rho_alpha, beta_pdf, 0.626, 0.108;
    rho_c_star, beta_pdf, 0.5, 0.1;
    rho_pi, beta_pdf, 0.5, 0.1;
    rho_r, beta_pdf, 0.5, 0.1;
    rho_g, beta_pdf, 0.5, 0.1;

    % Stochastic process
    stderr eps_a, inv_gamma_pdf, 2.176, 0.506;
    stderr eps_c_star, inv_gamma_pdf, 1.22, 0.7;
    stderr eps_pi, inv_gamma_pdf, 2.101, 0.202;
    %stderr eps_i, inv_gamma_pdf, 0.498, 0.237;
    %stderr eps_g, inv_gamma_pdf, 1.359, 0.387;
end;

%---------------------------------------------------------------
% Shock Specifications
%----------------------------------------------------------------
shocks;
    var eps_a      = 0.25^2; 
    var eps_c_star = 0.7^2;
    var eps_pi     = 0.25^2; 
    var eps_r      = 0.25^2; 
    var eps_g      = 0.25^2; 
end;

%----------------------------------------------------------------
% Sensibility Analysis
%----------------------------------------------------------------

dynare_sensitivity(graph_format=(eps,pdf));
identification(advanced=1, graph_format=(eps,pdf));

%----------------------------------------------------------------
% Impulse Response Analysis
%----------------------------------------------------------------
stoch_simul(order=1, irf=10,tex, graph_format=(eps,pdf)) y pi b r_nat r g;
rplot y pi b r_nat r g;
