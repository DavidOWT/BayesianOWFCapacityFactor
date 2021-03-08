function Output = TruncNorm(x, a, b, mu, sigma, Pr, OptSwitch)
%   Truncated normal distribution
%   https://en.wikipedia.org/wiki/Truncated_normal_distribution
%
%   Parameters:
%   - a - Lower limit of truncated distribution
%   - b - Upper limit of distribution
%   - mu - Mean
%   - sigma - 
%   - Pr - 
%   - OptSwitch - Define whether to evaluate PDF, CDF of iCDF
%
%
%   DW - 31/10/20 - Created\
%   DW - 01/11/20 - x can be a vector
%%  Main
%   Parameters
alpha = (a-mu)/sigma;
beta = (b-mu)/sigma;

%   Calculated parameters 
% z1 = normcdf(beta,0,1) - normcdf(alpha,0,1); % Matlab built-in
z = StnNrmCDF(beta) - StnNrmCDF(alpha); % Efficient method 


if strcmp(OptSwitch, 'PDF')
    eta = (x-mu)./sigma;
    
    Output = normpdf(eta)./sigma/z;
    
    Output(ge(x,b)) = 0;
    Output(le(x,a)) = 0;
    
elseif strcmp(OptSwitch, 'CDF')
    eta = (x-mu)./sigma;
    
    Output = (StnNrmCDF(eta)-StnNrmCDF(alpha))/z;
    
    Output(ge(x,b)) = 0;
    Output(le(x,a)) = 0;
        
    
elseif strcmp(OptSwitch, 'iCDF')
    
    Output = norminv(Pr.*z+StnNrmCDF(alpha),0,1).*sigma+mu;
    
    
else
    error()
    
end

end