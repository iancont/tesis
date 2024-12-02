function residual = static_resid(T, y, x, params, T_flag)
% function residual = static_resid(T, y, x, params, T_flag)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T         [#temp variables by 1]  double   vector of temporary terms to be filled by function
%   y         [M_.endo_nbr by 1]      double   vector of endogenous variables in declaration order
%   x         [M_.exo_nbr by 1]       double   vector of exogenous variables in declaration order
%   params    [M_.param_nbr by 1]     double   vector of parameter values in declaration order
%                                              to evaluate the model
%   T_flag    boolean                 boolean  flag saying whether or not to calculate temporary terms
%
% Output:
%   residual
%

if T_flag
    T = cournot.static_resid_tt(T, y, x, params);
end
residual = zeros(12, 1);
lhs = y(2);
rhs = y(9)+params(5)*y(2)+T(2)*y(1)-T(1)*y(5);
residual(1) = lhs - rhs;
lhs = y(1);
rhs = y(1)-(y(4)-y(2)-y(6))*1/T(1);
residual(2) = lhs - rhs;
lhs = y(3);
rhs = y(4)-y(6)+T(4)*(y(3)-y(2)+y(5)*params(21)/params(20)+y(1)*(1-params(19)-params(21))/params(20));
residual(3) = lhs - rhs;
lhs = y(4);
rhs = y(10)+(-(T(1)*T(2)))/params(5)*params(22)+params(13)/(T(1)*params(15))*y(1)+params(13)/(T(1)*params(15))*y(1)+T(2)*params(11)/(T(1)*params(13))*y(2)+(1+params(5)+T(1)*T(2))/params(5)*y(4)+(-1)/params(5)*y(4);
residual(4) = lhs - rhs;
lhs = y(5);
rhs = y(11)+T(1)*params(5)/(T(2)+T(1)+T(1)*params(5))*y(5)-params(3)*(T(1)*params(21)-T(1)-T(2)*params(21)+T(1)*params(19)-params(20)*T(3)+T(2)*T(1)*params(20)+T(3)*params(5)*params(20)-T(2)*T(1)*params(5)*params(20))/((T(2)+T(1)+T(1)*params(5))*params(16)*params(5)*params(20))+T(1)/(T(2)+T(1)+T(1)*params(5))*y(5)+T(1)*params(5)*params(14)/((T(2)+T(1)+T(1)*params(5))*params(16))*y(1)-(2+params(5))*T(1)*params(14)/((T(2)+T(1)+T(1)*params(5))*params(16))*y(1)+T(1)*params(14)/((T(2)+T(1)+T(1)*params(5))*params(16))*y(1)-T(1)*params(5)*params(12)*(T(1)-T(2))/((T(2)+T(1)+T(1)*params(5))*params(16))*y(2)+(T(1)-T(2))*T(1)*params(12)/((T(2)+T(1)+T(1)*params(5))*params(16))*y(2);
residual(5) = lhs - rhs;
lhs = y(6);
rhs = y(7)*(params(6)-1)*T(1)*(1+params(4))/(T(1)+params(4))+y(8)*T(5);
residual(6) = lhs - rhs;
lhs = y(7);
rhs = y(7)*params(6)+x(1);
residual(7) = lhs - rhs;
lhs = y(8);
rhs = y(8)*params(7)+x(2);
residual(8) = lhs - rhs;
lhs = y(9);
rhs = y(9)*params(8)+x(3);
residual(9) = lhs - rhs;
lhs = y(10);
rhs = y(10)*params(9)+x(4);
residual(10) = lhs - rhs;
lhs = y(11);
rhs = y(11)*params(10)+x(5);
residual(11) = lhs - rhs;
lhs = y(12);
rhs = y(4);
residual(12) = lhs - rhs;
if ~isreal(residual)
  residual = real(residual)+imag(residual).^2;
end
end