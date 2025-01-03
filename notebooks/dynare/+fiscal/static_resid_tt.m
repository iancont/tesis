function T = static_resid_tt(T, y, x, params)
% function T = static_resid_tt(T, y, x, params)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T         [#temp variables by 1]  double   vector of temporary terms to be filled by function
%   y         [M_.endo_nbr by 1]      double   vector of endogenous variables in declaration order
%   x         [M_.exo_nbr by 1]       double   vector of exogenous variables in declaration order
%   params    [M_.param_nbr by 1]     double   vector of parameter values in declaration order
%
% Output:
%   T         [#temp variables by 1]  double   vector of temporary terms
%

assert(length(T) >= 7);

T(1) = params(7)/(1+params(2)*(params(7)*params(10)+(1-params(2))*(params(7)*params(9)-1)-1));
T(2) = (1-params(1)*params(8))*(1-params(8))/params(8)*(T(1)+params(3));
T(3) = T(1)^2;
T(4) = params(14)*T(3);
T(5) = params(15)/(params(15)+params(16)+T(4));
T(6) = 1/params(1);
T(7) = (params(18)-1)*(params(7)*params(10)+(1-params(2))*(params(7)*params(9)-1)-1)*params(2)*params(3)/(T(1)+params(3));

end
