function g1 = static_g1(T, y, x, params, T_flag)
% function g1 = static_g1(T, y, x, params, T_flag)
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
%   g1
%

if T_flag
    T = monetary.static_g1_tt(T, y, x, params);
end
g1 = zeros(11, 11);
g1(1,1)=(-T(2));
g1(1,2)=1-params(5);
g1(1,5)=T(1);
g1(1,9)=(-1);
g1(2,2)=(-(1/T(1)));
g1(2,4)=1/T(1);
g1(2,6)=(-(1/T(1)));
g1(3,1)=(-(T(9)*(1-params(19)-params(21))/params(20)));
g1(3,2)=T(9);
g1(3,3)=1-T(9);
g1(3,4)=(-1);
g1(3,5)=(-(T(9)*params(21)/params(20)));
g1(3,6)=1;
g1(4,1)=(-(T(3)*params(13)*params(14)/(params(16)*T(6))+T(7)-(2+params(5))*T(3)*params(13)*params(16)/(params(16)*T(6))));
g1(4,2)=(-(T(8)-(T(1)-T(2))*T(3)*params(13)*params(12)/(params(16)*T(6))));
g1(4,4)=1;
g1(4,5)=(-(params(13)*T(3)/T(6)-T(1)*params(13)*(T(1)+T(2))/T(6)));
g1(4,6)=(-(params(13)/(params(13)+params(15)*T(3))));
g1(4,10)=(-1);
g1(5,1)=(-(T(1)*params(14)/((T(2)+T(1)+T(1)*params(5))*params(16))+T(1)*params(5)*params(14)/((T(2)+T(1)+T(1)*params(5))*params(16))-(2+params(5))*T(1)*params(14)/((T(2)+T(1)+T(1)*params(5))*params(16))));
g1(5,2)=(-((T(1)-T(2))*T(1)*params(12)/((T(2)+T(1)+T(1)*params(5))*params(16))-T(1)*params(5)*params(12)*(T(1)-T(2))/((T(2)+T(1)+T(1)*params(5))*params(16))));
g1(5,5)=1-(T(1)*params(5)/(T(2)+T(1)+T(1)*params(5))+T(1)/(T(2)+T(1)+T(1)*params(5)));
g1(5,11)=(-1);
g1(6,6)=1;
g1(6,7)=(-((params(6)-1)*T(1)*(1+params(4))/(T(1)+params(4))));
g1(6,8)=(-T(10));
g1(7,7)=1-params(6);
g1(8,8)=1-params(7);
g1(9,9)=1-params(8);
g1(10,10)=1-params(9);
g1(11,11)=1-params(10);
if ~isreal(g1)
    g1 = real(g1)+2*imag(g1);
end
end
