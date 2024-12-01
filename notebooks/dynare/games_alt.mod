% =========================================================================
% New Keynesian Model with Calvo Price Rigidities
% Features: Capital, Investment Adjustment Costs, Nonzero Inflation Target
% =========================================================================
% Author: Ian Contreras (contreras.mejia@hotmail.com)
% Version: Nov 30, 2024
% =========================================================================

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
    ALPHA       $\alpha$           (long_name='Openness Degree')
    PHI         $\phi$             (long_name='Inverse Labor Supply Elasticity')
    BETA        $\beta$            (long_name='Discount Factor')
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
    TAU         $\tau$           (long_name='Effective Income Tax Rate')
    B_BAR       $\frac{\bar{B}}{\bar{Y}}$  (long_name='Steady State Debt-GDP Ratio')
    C_BAR       $\frac{\bar{C}}{\bar{Y}}$  (long_name='Steady State Consumption-GDP Ratio')
    R_BAR       $r^*$            (long_name='Steady State Interest Rate')
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
R_BAR = 0.04;

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

end;


planner_objective
    L_m = GAMMA_PI*var_pi + GAMMA_Y*var_y + GAMMA_R*(var_r - R_BAR^2);
    L_f = ZETA_PI*var_pi + ZETA_Y*var_y + ZETA_G*var_g;
end;
ramsey_model;
ramsey_constraints;
r > 0;
g > 0;
end;

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

evaluate_planner_objective;
