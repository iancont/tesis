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
    T = nash.dynamic_resid_tt(T, y, x, params, steady_state, it_);
end
residual = zeros(12, 1);
lhs = y(11);
rhs = y(18)+params(1)*y(23)+y(10)*T(3)-y(14)*T(2);
residual(1) = lhs - rhs;
lhs = y(10);
rhs = y(22)-(y(13)-y(23)-y(15))*1/T(2)-(y(25)-y(14));
residual(2) = lhs - rhs;
lhs = y(24);
rhs = y(13)-y(15)+T(1)*(y(12)-y(11)+y(14)*params(6)/params(5)+y(10)*(1-params(4)-params(6))/params(5));
residual(3) = lhs - rhs;
lhs = y(13);
rhs = y(19)+y(15)*(-(T(2)*T(3)))/params(1)+y(1)*params(12)/(params(13)*T(2))+y(10)*params(12)/(params(13)*T(2))+y(11)*params(11)*T(3)/(params(12)*T(2))+y(2)*(1+params(1)+T(2)*T(3))/params(1)+(-1)/params(1)*y(9);
residual(4) = lhs - rhs;
lhs = y(14);
rhs = y(20)+y(25)*params(1)*T(2)/(T(3)+T(2)+params(1)*T(2))-params(2)*(params(6)*T(2)-T(2)-params(6)*T(3)+params(4)*T(2)-params(5)*T(4)+T(3)*params(5)*T(2)+params(1)*params(5)*T(4)-T(3)*params(1)*params(5)*T(2))/(params(16)*params(1)*params(5)*(T(3)+T(2)+params(1)*T(2)))+y(3)*T(2)/(T(3)+T(2)+params(1)*T(2))+y(22)*params(15)*params(1)*T(2)/(params(16)*(T(3)+T(2)+params(1)*T(2)))-y(10)*(2+params(1))*params(15)*T(2)/(params(16)*(T(3)+T(2)+params(1)*T(2)))+y(1)*params(15)*T(2)/(params(16)*(T(3)+T(2)+params(1)*T(2)))-y(23)*params(14)*params(1)*T(2)*(T(2)-T(3))/(params(16)*(T(3)+T(2)+params(1)*T(2)))+y(11)*(T(2)-T(3))*params(14)*T(2)/(params(16)*(T(3)+T(2)+params(1)*T(2)));
residual(5) = lhs - rhs;
lhs = y(15);
rhs = y(16)*(params(17)-1)*(1+params(3))*T(2)/(params(3)+T(2))+y(17)*T(5);
residual(6) = lhs - rhs;
lhs = y(16);
rhs = params(17)*y(4)+x(it_, 1);
residual(7) = lhs - rhs;
lhs = y(17);
rhs = params(18)*y(5)+x(it_, 2);
residual(8) = lhs - rhs;
lhs = y(18);
rhs = params(19)*y(6)+x(it_, 3);
residual(9) = lhs - rhs;
lhs = y(19);
rhs = params(20)*y(7)+x(it_, 4);
residual(10) = lhs - rhs;
lhs = y(20);
rhs = params(21)*y(8)+x(it_, 5);
residual(11) = lhs - rhs;
lhs = y(21);
rhs = y(2);
residual(12) = lhs - rhs;

end
