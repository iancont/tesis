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
    y       $\tilde{y}_t$    (long_name='Output Gap')
    pi      $\pi_t$          (long_name='Domestic Inflation')
    b       $\tilde{b}_{t}$  (long_name='Debt Stock')
    r       $r_t$            (long_name='Nominal Interest Rate')
    g       $\tilde{g}_t$    (long_name='Fiscal Gap')
    r_nat   ${r^{n}}$        (long_name='Natural Interest Rate')
    a       $a_t$            (long_name='Technology Shock Process AR(1)')
    c_star  $c_t^*$          (long_name='International Consumption Shock Process AR(1)')
    xi_pi   $\xi_{\pi}$      (long_name='Domestic Price Shock Process AR(1)')
    xi_r    $\xi_{r}$        (long_name='Interest Rate Shock Process AR(1)')
    xi_g    $\xi_{g}$        (long_name='Public Spending Shock Process AR(1)')
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
    THETA       $\theta$           (long_name='Calvo Probability') 
    SIGMA       $\sigma$           (long_name='Inverse EIS') 
    ALPHA       $\alpha$           (long_name='Openness Degree') %Parametrizado
    PHI         $\phi$             (long_name='Inverse Labor Supply Elasticity') %Parametrizado
    BETA        $\beta$            (long_name='Discount Factor') %Parametrizado
    RHO_ALPHA   $\rho_{\alpha}$    (long_name='Productivity Shock Autocorrelation')
    RHO_C_STAR  $\rho_{c^*}$      (long_name='Int. Consumption Shock Autocorrelation')
    RHO_PI      $\rho_{\pi}$      (long_name='Domestic Price Shock Autocorrelation')
    RHO_R       $\rho_{r}$        (long_name='Interest Rate Shock Autocorrelation')
    RHO_G       $\rho_{g}$        (long_name='Public Spending Shock Autocorrelation')
    GAMMA_PI    $\gamma_{\pi}$     (long_name='Monetary Authority Inflation Gap Response')
    ZETA_PI     $\zeta_{\pi}$     (long_name='Fiscal Authority Inflation Gap Response')
    GAMMA_Y     $\gamma_{y}$      (long_name='Monetary Authority Output Gap Response')
    ZETA_Y      $\zeta_{y}$      (long_name='Fiscal Authority Output Gap Response')
    GAMMA_R     $\gamma_{r}$      (long_name='Interest Rate Smoothing')
    ZETA_G      $\zeta_{g}$      (long_name='Government Spending Response')
    ETA         $\eta$           (long_name='Domestic-Imported Goods Substitution Elasticity') %ETA no puede ser igual a sigma, pq si no la tasa de interes natural se cancela
    UPSILON     $\upsilon$       (long_name='Cross-Country Goods Substitution Elasticity')
    TAU         $\tau$           (long_name='Effective Income Tax Rate') %Parametrizado
    B_BAR       $\frac{\bar{B}}{\bar{Y}}$  (long_name='Steady State Debt-GDP Ratio') %Parametrizado
    C_BAR       $\frac{\bar{C}}{\bar{Y}}$  (long_name='Steady State Consumption-GDP Ratio') %Parametrizado
    R_BAR       $r^*$            (long_name='Steady State Interest Rate') %Parametrizado
;

%----------------------------------------------------------------
% Calibration
%----------------------------------------------------------------
THETA = 0.5;
SIGMA = 1;
ALPHA = 0.43;
PHI = 1;
BETA = 0.99;
RHO_ALPHA = 0.5;
RHO_C_STAR = 0.5;
RHO_PI = 0.5;     % To be confirmed
RHO_R = 0.70;
RHO_G = 0.5;      % To be confirmed
GAMMA_PI = 1.25;
ZETA_PI = 0.25;
GAMMA_Y = 0.25;
ZETA_Y = 1.25;
GAMMA_R = 0.7;
ZETA_G = 0.25;
ETA = 0.69;
UPSILON = 1;
TAU = 0.0334;
B_BAR = 0.53;
C_BAR = 0.70;
R_BAR = 0.00;

%----------------------------------------------------------------
% Model Equations (Linear Form)
%----------------------------------------------------------------
model(linear); 

% Composite Parameters
#omega = SIGMA * UPSILON + (1-ALPHA)*(SIGMA * ETA -1);
#sigma_alpha = (SIGMA)/(1+ALPHA*(omega-1));
#lambda = ((1- BETA * THETA)*(1-THETA))/THETA;
#kappa_upsilon = lambda * (sigma_alpha + PHI);

% 1. New Phillips Curve
[name='New Phillips Curve']
pi = BETA*pi(+1) + kappa_upsilon*y - sigma_alpha*g + xi_pi ;

% 2. Dynamic IS Curve
[name='Dynamic IS Curve']
y = y(+1) - (1/sigma_alpha)*(r-pi(+1)-r_nat) - (g(+1)-g);

% 3. Government Consolidated Budget Constraint
[name='Government Consolidated Budget Constraint']
b(+1) = (r-r_nat) + (1/BETA)*(b - pi + (C_BAR/B_BAR)*g + ((1-TAU-C_BAR)/(B_BAR))*y);

% Common Parameters for Regimes 1 and 3 Monetary Rule
#OMICRON_R_LAG1 = (sigma_alpha*kappa_upsilon + BETA + 1)/BETA;
#OMICRON_R_LAG2 = -1/BETA;
#OMICRON_PI = (GAMMA_PI*kappa_upsilon)/(GAMMA_Y*sigma_alpha);
#OMICRON_Y = GAMMA_Y/(GAMMA_R*sigma_alpha);
#OMICRON_R_TAR = -(sigma_alpha*kappa_upsilon)/BETA;

% Common Parameters for Regimes 1 and 2 Fiscal Rule
#D = BETA*sigma_alpha + sigma_alpha + kappa_upsilon;
#PSI_G_PLUS = (BETA*sigma_alpha)/D;
#PSI_G_LAG = sigma_alpha/D;
#PSI_Y_PLUS = (BETA*sigma_alpha*ZETA_Y)/(ZETA_G*D);
#PSI_Y_0 = (ZETA_Y*sigma_alpha*(BETA+2))/(ZETA_G*D);
#PSI_Y_LAG = (ZETA_Y*sigma_alpha)/(ZETA_G*D);
#PSI_PI_PLUS = (BETA*sigma_alpha*ZETA_PI*(sigma_alpha-kappa_upsilon))/(ZETA_G*D);
#PSI_PI_0 = (sigma_alpha*ZETA_PI*(sigma_alpha-kappa_upsilon))/(ZETA_G*D);
#CONS = (ALPHA*(-sigma_alpha + C_BAR*sigma_alpha - C_BAR*kappa_upsilon + TAU*sigma_alpha - B_BAR*sigma_alpha^2 + B_BAR*sigma_alpha*kappa_upsilon + B_BAR*BETA*sigma_alpha^2 - B_BAR*BETA*sigma_alpha*kappa_upsilon))/(B_BAR*BETA*ZETA_G*D);

@#if REGIME == 1
% Regime 1: Original Implementation
[name='Optimal Monetary Policy Rule']
r = OMICRON_R_LAG1*r(-1) + OMICRON_R_LAG2*r(-2) + OMICRON_PI*pi + OMICRON_Y*y + OMICRON_Y*y(-1) + OMICRON_R_TAR*R_BAR + xi_r;

[name='Optimal Fiscal Policy Rule']
g = -CONS + PSI_G_PLUS*g(+1) + PSI_G_LAG*g(-1) + PSI_Y_PLUS*y(+1) - PSI_Y_0*y + PSI_Y_LAG*y(-1) - PSI_PI_PLUS*pi(+1) + PSI_PI_0*pi + xi_g;

@#endif

@#if REGIME == 2
% Regime 2: Modified Monetary-Led Policy
#V = GAMMA_Y*BETA*sigma_alpha + GAMMA_Y*sigma_alpha + GAMMA_Y*kappa_upsilon + GAMMA_R*BETA*sigma_alpha^3 + GAMMA_R*sigma_alpha^3 + GAMMA_R*sigma_alpha^2*kappa_upsilon;

#UPSILON_G_PLUS = (GAMMA_Y*sigma_alpha*(kappa_upsilon+sigma_alpha))/V;

#UPSILON_G_LAG = (GAMMA_Y*sigma_alpha^2)/V;

#UPSILON_Y_PLUS = (GAMMA_Y*sigma_alpha*(ZETA_G*kappa_upsilon+ZETA_G*BETA*sigma_alpha+ZETA_G*sigma_alpha+BETA*sigma_alpha*ZETA_Y))/(ZETA_G*V);

#UPSILON_Y_0 = (GAMMA_Y*ZETA_G*sigma_alpha^2*(BETA+2))/(ZETA_G*V);

#UPSILON_Y_LAG = (GAMMA_Y*ZETA_Y*sigma_alpha^2)/(ZETA_G*V);

#UPSILON_PI_PLUS = (GAMMA_Y*(-BETA*sigma_alpha^2*ZETA_PI-ZETA_G*BETA*sigma_alpha-ZETA_G*sigma_alpha+BETA*sigma_alpha^3*ZETA_PI-ZETA_G*kappa_upsilon))/(ZETA_G*V);

#UPSILON_PI_0 = (GAMMA_Y*ZETA_PI*sigma_alpha^2*(sigma_alpha-kappa_upsilon))/(ZETA_G*V);

#UPSILON_RN = GAMMA_Y/(GAMMA_R*sigma_alpha^2+GAMMA_Y);

#K = (GAMMA_Y * sigma_alpha * ALPHA*(sigma_alpha*TAU-sigma_alpha - C_BAR*kappa_upsilon + sigma_alpha ^2 * B_BAR * BETA - sigma_alpha * B_BAR* BETA * kappa_upsilon - sigma_alpha ^2 *B_BAR + sigma_alpha * C_BAR + sigma_alpha * B_BAR* kappa_upsilon))/(ZETA_G * B_BAR * BETA * V);

[name='Modified Monetary-Led Policy Rule']
r = K - UPSILON_G_PLUS * g(+1) + UPSILON_G_LAG * g(-1) + UPSILON_Y_PLUS * y(+1) - UPSILON_Y_0 * y + UPSILON_Y_LAG * y(-1) + UPSILON_PI_PLUS * pi(+1) - UPSILON_PI_0 * pi + R_BAR + UPSILON_RN * r_nat + xi_r;

[name='Optimal Fiscal Policy Rule']
g = -CONS + PSI_G_PLUS*g(+1) + PSI_G_LAG*g(-1) + PSI_Y_PLUS*y(+1) - PSI_Y_0*y + PSI_Y_LAG*y(-1) - PSI_PI_PLUS*pi(+1) + PSI_PI_0*pi + xi_g;

@#endif

@#if REGIME == 3
% Regime 3: Non-Cooperative Nash Policy
[name='Optimal Monetary Policy Rule']
r = OMICRON_R_LAG1*r(-1) + OMICRON_R_LAG2*r(-2) + OMICRON_PI*pi + OMICRON_Y*y + OMICRON_Y*y(-1) + OMICRON_R_TAR*R_BAR + xi_r;

#J = ZETA_G + ZETA_Y + ZETA_PI*sigma_alpha^2;

#W = (ZETA_PI*sigma_alpha)/J;

#XI_G_PLUS = ZETA_Y/J;

#XI_R_BAR = (ZETA_Y*kappa_upsilon)/(BETA*J);

#XI_R_NAT = ZETA_Y/(sigma_alpha*J);

#XI_R_LAG = (ZETA_Y*(sigma_alpha*kappa_upsilon+BETA+1))/(sigma_alpha*BETA*J);

#XI_R_LAG_2 = ZETA_Y/(sigma_alpha*BETA*J);

#XI_PI_PLUS = (-ZETA_PI*sigma_alpha^2*BETA+ZETA_Y)/(sigma_alpha*J);

#XI_PI_0 = (ZETA_Y*GAMMA_Y*kappa_upsilon)/(sigma_alpha^2*GAMMA_R*J);

#XI_Y_PLUS = ZETA_Y/J;

#XI_Y_0 = (ZETA_Y*GAMMA_Y+ZETA_PI*sigma_alpha^2*GAMMA_R*kappa_upsilon)/(sigma_alpha^2*GAMMA_R*J);

#XI_Y_LAG = (ZETA_Y*GAMMA_Y)/(sigma_alpha^2*GAMMA_R*J);

[name='Non-Cooperative Nash Fiscal Policy Rule']
g = XI_G_PLUS*g(+1) - XI_R_BAR*R_BAR - XI_R_NAT * r_nat - XI_R_LAG*r(-1) - XI_R_LAG_2*r(-2) - XI_PI_PLUS * pi(+1) + XI_PI_0* pi - XI_Y_PLUS*y(+1) + XI_Y_0*y - XI_Y_LAG*y(-1) + W*xi_pi + xi_g;

@#endif

% Exogenous Processes
[name='Natural Interest Rate']
r_nat = ((sigma_alpha*(1 + PHI)*(RHO_ALPHA-1))/(sigma_alpha + PHI))*a + ((PHI*ALPHA*(omega-1))/(sigma_alpha + PHI))*(RHO_C_STAR-1)*c_star;

[name='Technology AR(1)']
a = RHO_ALPHA*a(-1) + eps_a;

[name='International Consumption AR(1)']
c_star = RHO_C_STAR*c_star(-1) + eps_c_star;

[name='Domestic Price AR(1)']
xi_pi = RHO_PI*xi_pi(-1) + eps_pi;

[name='Interest Rate AR(1)']
xi_r = RHO_R*xi_r(-1) + eps_r;

[name='Public Spending AR(1)']
xi_g = RHO_G*xi_g(-1) + eps_g;

end;

%----------------------------------------------------------------
% Steady State
%----------------------------------------------------------------
steady_state_model(order=2);
y = 0; %validado
pi= 0; %validado
r = r_nat; %validado
b =0;
g =0;
a=0;
c_star=0;
xi_pi=0;
xi_r=0;
xi_=0;

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
