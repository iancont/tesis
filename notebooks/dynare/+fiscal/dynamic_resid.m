function residual = dynamic_resid(T, y, x, params, steady_state, it_, T_flag)
% function residual = dynamic_resid(T, y, x, params, steady_state, it_, T_flag)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T             [#temp variables by 1]     double   vector of temporary terms to be filled by function
%   y             [#dynamic variables by 1]  double   vector of endogenous variables in the order stored
%                                                     in M_.lead_lag_incidence; see the Manual
%   x             [nperiods by M_.exo_nbr]   double   matrix of exogenous variables (in declaration order)
%                                                     for all simulation periods
%   steady_state  [M_.endo_nbr by 1]         double   vector of steady state values
%   params        [M_.param_nbr by 1]        double   vector of parameter values in declaration order
%   it_           scalar                     double   time period for exogenous variables for which
%                                                     to evaluate the model
%   T_flag        boolean                    boolean  flag saying whether or not to calculate temporary terms
%
% Output:
%   residual
%

if T_flag
    T = fiscal.dynamic_resid_tt(T, y, x, params, steady_state, it_);
end
residual = zeros(12, 1);
lhs = y(10);
rhs = y(17)+params(5)*y(22)+y(9)*T(3)-y(13)*T(2);
residual(1) = lhs - rhs;
lhs = y(9);
rhs = y(21)-(y(12)-y(22)-y(14))*1/T(2)-(y(24)-y(13));
residual(2) = lhs - rhs;
lhs = y(23);
rhs = y(12)-y(14)+T(1)*(y(11)-y(10)+y(13)*params(21)/params(20)+y(9)*(1-params(19)-params(21))/params(20));
residual(3) = lhs - rhs;
lhs = y(12);
rhs = y(18)+params(22)*(-(T(2)*T(3)))/params(5)+y(1)*params(13)/(params(15)*T(2))+y(9)*params(13)/(params(15)*T(2))+y(10)*params(11)*T(3)/(params(13)*T(2))+y(2)*(1+params(5)+T(2)*T(3))/params(5)+(-1)/params(5)*y(8);
residual(4) = lhs - rhs;
lhs = y(13);
rhs = y(19)+y(17)*params(12)*T(2)/(params(14)+params(16)+T(5))+y(9)*(params(13)*params(14)+T(3)*params(15)*T(5))/((params(14)+params(16)+T(5))*params(15)*T(4))+y(10)*params(13)*params(14)*T(3)/((params(14)+params(16)+T(5))*params(15)*T(4))+y(24)*T(6)-params(22)*params(14)*T(3)/(params(5)*(params(14)+params(16)+T(5)))-y(14)*params(14)/(T(2)*(params(14)+params(16)+T(5)))-y(2)*params(14)*(1+params(5)+T(2)*T(3))/(params(5)*T(2)*(params(14)+params(16)+T(5)))-params(14)/(params(5)*T(2)*(params(14)+params(16)+T(5)))*y(8)-y(22)*(params(14)+params(5)*(-params(12))*T(4))/(T(2)*(params(14)+params(16)+T(5)))-y(21)*T(6)-y(1)*params(13)*params(14)/((params(14)+params(16)+T(5))*params(15)*T(4));
residual(5) = lhs - rhs;
lhs = y(14);
rhs = y(15)*(params(6)-1)*(1+params(4))*T(2)/(params(4)+T(2))+y(16)*T(7);
residual(6) = lhs - rhs;
lhs = y(15);
rhs = params(6)*y(3)+x(it_, 1);
residual(7) = lhs - rhs;
lhs = y(16);
rhs = params(7)*y(4)+x(it_, 2);
residual(8) = lhs - rhs;
lhs = y(17);
rhs = params(8)*y(5)+x(it_, 3);
residual(9) = lhs - rhs;
lhs = y(18);
rhs = params(9)*y(6)+x(it_, 4);
residual(10) = lhs - rhs;
lhs = y(19);
rhs = params(10)*y(7)+x(it_, 5);
residual(11) = lhs - rhs;
lhs = y(20);
rhs = y(2);
residual(12) = lhs - rhs;

end
