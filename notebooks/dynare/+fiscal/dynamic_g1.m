function g1 = dynamic_g1(T, y, x, params, steady_state, it_, T_flag)
% function g1 = dynamic_g1(T, y, x, params, steady_state, it_, T_flag)
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
%   g1
%

if T_flag
    T = fiscal.dynamic_g1_tt(T, y, x, params, steady_state, it_);
end
g1 = zeros(12, 29);
g1(1,9)=(-T(3));
g1(1,10)=1;
g1(1,22)=(-params(1));
g1(1,13)=T(2);
g1(1,17)=(-1);
g1(2,9)=1;
g1(2,21)=(-1);
g1(2,22)=(-(1/T(2)));
g1(2,12)=1/T(2);
g1(2,13)=(-1);
g1(2,24)=1;
g1(2,14)=(-(1/T(2)));
g1(3,9)=(-(T(1)*(1-params(4)-params(6))/params(5)));
g1(3,10)=T(1);
g1(3,11)=(-T(1));
g1(3,23)=1;
g1(3,12)=(-1);
g1(3,13)=(-(T(1)*params(6)/params(5)));
g1(3,14)=1;
g1(4,1)=(-(params(12)/(params(13)*T(2))));
g1(4,9)=(-(params(12)/(params(13)*T(2))));
g1(4,10)=(-(params(11)*T(3)/(params(12)*T(2))));
g1(4,2)=(-((1+params(1)+T(2)*T(3))/params(1)));
g1(4,12)=1;
g1(4,14)=(-((-(T(2)*T(3)))/params(1)));
g1(4,18)=(-1);
g1(4,8)=(-((-1)/params(1)));
g1(5,1)=params(12)*params(15)/((params(15)+params(16)+T(5))*params(13)*T(4));
g1(5,9)=(-((params(12)*params(15)+T(3)*params(13)*T(5))/((params(15)+params(16)+T(5))*params(13)*T(4))));
g1(5,21)=T(6);
g1(5,10)=(-(params(12)*params(15)*T(3)/((params(15)+params(16)+T(5))*params(13)*T(4))));
g1(5,22)=(params(15)+params(1)*(-params(14))*T(4))/(T(2)*(params(15)+params(16)+T(5)));
g1(5,2)=params(15)*(1+params(1)+T(2)*T(3))/(params(1)*T(2)*(params(15)+params(16)+T(5)));
g1(5,13)=1;
g1(5,24)=(-T(6));
g1(5,14)=(-((-(params(15)*T(3)/(params(1)*(params(15)+params(16)+T(5)))))-params(15)/(T(2)*(params(15)+params(16)+T(5)))));
g1(5,17)=(-(params(14)*T(2)/(params(15)+params(16)+T(5))));
g1(5,19)=(-1);
g1(5,8)=params(15)/(params(1)*T(2)*(params(15)+params(16)+T(5)));
g1(6,14)=1;
g1(6,15)=(-((params(17)-1)*(1+params(3))*T(2)/(params(3)+T(2))));
g1(6,16)=(-T(7));
g1(7,3)=(-params(17));
g1(7,15)=1;
g1(7,25)=(-1);
g1(8,4)=(-params(18));
g1(8,16)=1;
g1(8,26)=(-1);
g1(9,5)=(-params(19));
g1(9,17)=1;
g1(9,27)=(-1);
g1(10,6)=(-params(20));
g1(10,18)=1;
g1(10,28)=(-1);
g1(11,7)=(-params(21));
g1(11,19)=1;
g1(11,29)=(-1);
g1(12,2)=(-1);
g1(12,20)=1;

end
