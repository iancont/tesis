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
    T = nash.dynamic_g1_tt(T, y, x, params, steady_state, it_);
end
g1 = zeros(12, 30);
g1(1,10)=(-T(3));
g1(1,11)=1;
g1(1,23)=(-params(1));
g1(1,14)=T(2);
g1(1,18)=(-1);
g1(2,10)=1;
g1(2,22)=(-1);
g1(2,23)=(-(1/T(2)));
g1(2,13)=1/T(2);
g1(2,14)=(-1);
g1(2,25)=1;
g1(2,15)=(-(1/T(2)));
g1(3,10)=(-(T(1)*(1-params(4)-params(6))/params(5)));
g1(3,11)=T(1);
g1(3,12)=(-T(1));
g1(3,24)=1;
g1(3,13)=(-1);
g1(3,14)=(-(T(1)*params(6)/params(5)));
g1(3,15)=1;
g1(4,1)=(-(params(12)/(params(13)*T(2))));
g1(4,10)=(-(params(12)/(params(13)*T(2))));
g1(4,11)=(-(params(11)*T(3)/(params(12)*T(2))));
g1(4,2)=(-((1+params(1)+T(2)*T(3))/params(1)));
g1(4,13)=1;
g1(4,15)=(-((-(T(2)*T(3)))/params(1)));
g1(4,19)=(-1);
g1(4,9)=(-((-1)/params(1)));
g1(5,1)=(-(params(15)*T(2)/(params(16)*(T(3)+T(2)+params(1)*T(2)))));
g1(5,10)=(2+params(1))*params(15)*T(2)/(params(16)*(T(3)+T(2)+params(1)*T(2)));
g1(5,22)=(-(params(15)*params(1)*T(2)/(params(16)*(T(3)+T(2)+params(1)*T(2)))));
g1(5,11)=(-((T(2)-T(3))*params(14)*T(2)/(params(16)*(T(3)+T(2)+params(1)*T(2)))));
g1(5,23)=params(14)*params(1)*T(2)*(T(2)-T(3))/(params(16)*(T(3)+T(2)+params(1)*T(2)));
g1(5,3)=(-(T(2)/(T(3)+T(2)+params(1)*T(2))));
g1(5,14)=1;
g1(5,25)=(-(params(1)*T(2)/(T(3)+T(2)+params(1)*T(2))));
g1(5,20)=(-1);
g1(6,15)=1;
g1(6,16)=(-((params(17)-1)*(1+params(3))*T(2)/(params(3)+T(2))));
g1(6,17)=(-T(5));
g1(7,4)=(-params(17));
g1(7,16)=1;
g1(7,26)=(-1);
g1(8,5)=(-params(18));
g1(8,17)=1;
g1(8,27)=(-1);
g1(9,6)=(-params(19));
g1(9,18)=1;
g1(9,28)=(-1);
g1(10,7)=(-params(20));
g1(10,19)=1;
g1(10,29)=(-1);
g1(11,8)=(-params(21));
g1(11,20)=1;
g1(11,30)=(-1);
g1(12,2)=(-1);
g1(12,21)=1;

end
