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
    T = monetary.dynamic_g1_tt(T, y, x, params, steady_state, it_);
end
g1 = zeros(11, 27);
g1(1,8)=(-T(3));
g1(1,9)=1;
g1(1,20)=(-params(5));
g1(1,12)=T(2);
g1(1,16)=(-1);
g1(2,8)=1;
g1(2,19)=(-1);
g1(2,20)=(-(1/T(2)));
g1(2,11)=1/T(2);
g1(2,12)=(-1);
g1(2,22)=1;
g1(2,13)=(-(1/T(2)));
g1(3,8)=(-(T(1)*(1-params(19)-params(21))/params(20)));
g1(3,9)=T(1);
g1(3,10)=(-T(1));
g1(3,21)=1;
g1(3,11)=(-1);
g1(3,12)=(-(T(1)*params(21)/params(20)));
g1(3,13)=1;
g1(4,1)=(-(params(13)*params(14)*T(4)/(params(16)*T(7))));
g1(4,8)=(2+params(5))*params(13)*params(16)*T(4)/(params(16)*T(7));
g1(4,19)=(-T(8));
g1(4,9)=(T(2)-T(3))*params(13)*params(12)*T(4)/(params(16)*T(7));
g1(4,20)=(-T(9));
g1(4,11)=1;
g1(4,2)=(-(params(13)*T(4)/T(7)));
g1(4,22)=params(13)*T(2)*(T(2)+T(3))/T(7);
g1(4,13)=(-(params(13)/(params(13)+params(15)*T(4))));
g1(4,17)=(-1);
g1(5,1)=(-(params(14)*T(2)/(params(16)*(T(3)+T(2)+params(5)*T(2)))));
g1(5,8)=(2+params(5))*params(14)*T(2)/(params(16)*(T(3)+T(2)+params(5)*T(2)));
g1(5,19)=(-(params(14)*params(5)*T(2)/(params(16)*(T(3)+T(2)+params(5)*T(2)))));
g1(5,9)=(-((T(2)-T(3))*params(12)*T(2)/(params(16)*(T(3)+T(2)+params(5)*T(2)))));
g1(5,20)=params(12)*params(5)*T(2)*(T(2)-T(3))/(params(16)*(T(3)+T(2)+params(5)*T(2)));
g1(5,2)=(-(T(2)/(T(3)+T(2)+params(5)*T(2))));
g1(5,12)=1;
g1(5,22)=(-(params(5)*T(2)/(T(3)+T(2)+params(5)*T(2))));
g1(5,18)=(-1);
g1(6,13)=1;
g1(6,14)=(-((params(6)-1)*(1+params(4))*T(2)/(params(4)+T(2))));
g1(6,15)=(-T(10));
g1(7,3)=(-params(6));
g1(7,14)=1;
g1(7,23)=(-1);
g1(8,4)=(-params(7));
g1(8,15)=1;
g1(8,24)=(-1);
g1(9,5)=(-params(8));
g1(9,16)=1;
g1(9,25)=(-1);
g1(10,6)=(-params(9));
g1(10,17)=1;
g1(10,26)=(-1);
g1(11,7)=(-params(10));
g1(11,18)=1;
g1(11,27)=(-1);

end
