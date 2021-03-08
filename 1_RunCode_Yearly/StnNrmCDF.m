function Pr = StnNrmCDF(x)
%%  Efficient standard normal CDF
%   Returns the cdf of the standard normal distribution (with mu = 0, sigma
%   = 1) evaluated at the scalar input x.
%
%   The method is not based on calculating the error function and is
%   therefore more efficient than the matlab built-in normcdf function.
%
%   Ref:
%   - G. Marsaglia, Evaluating the Normal Distribution, JSS, 2004. doi: 10.18637/jss.v011.i04
%
%
%   DW - 01/11/20 - Created
%   DW - 07/11/20 - Updated to 
%%  Main

%   Check for extreme x that would result in NAN
if ge(x,37)
   Pr = 1;
   return
   
elseif le(x,-37)
   Pr = 0;
   return
   
end

%   Calculation
s = x;
t = 0.00023455457;
b = x;
q = x*x;
i = 1;
    
while s ~= t  
    t = s; 
    i = i+2;
    b = b.*q/i;
    
    
    s = t+b;
    
    Pr = 0.5 + s*exp(-0.5*q-0.91893853320467274178);
end

end
% 
% /*------------------------------------------------------
% The following  little C function Phi(x)
%    will provide double precision values for
%    the standard normal distribution Phi(x)
%    with absolute error less than 8*10^(-16).
% --------------------------------------------------------*/
%     double Phi(double x)
%     {long double s=x,t=0,b=x,q=x*x,i=1;
%      while(s!=t) s=(t=s)+(b*=q/(i+=2));
%      return .5+s*exp(-.5*q-.91893853320467274178L);}

%   The L means long double format

%   Testing
% nLoop = 100
% x = rand(nLoop,1).*10-5;
% 
% for i = 1:nLoop
% 
%     tic
%     Pr(i,1) = StnNrmCDF(x(i));
%     timeVec(i,1) = toc;
% 
%     tic
%     Pr(i,2) = normcdf(x(i),0,1);
%     timeVec(i,2) = toc;
% end
%     
% sprintf('Pool %i completed in %f seconds', ParL, b)

%   Built-in matlab:
% normcdf(x,0,1) 



