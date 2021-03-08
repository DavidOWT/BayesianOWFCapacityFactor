function Output = TruncChi(x, dof, Pr, Lim, OptSwitch)
%   Truncated Chi distribution
%   https://en.wikipedia.org/wiki/Truncated_normal_distribution
%
%   Parameters:
%   - a - Lower limit of truncated distribution
%   - b - Upper limit of distribution
%   - dof - Degree of freedom
%   - Pr - 
%   - OptSwitch - Define whether to evaluate PDF, CDF of iCDF
%
%
%   DW - 31/10/20 - Created\
%   DW - 01/11/20 - x can be a vector
%%  Main

Lim.aCDF = cdf('Chisquare', Lim.a, dof);
Lim.bCDF = cdf('Chisquare', Lim.b,  dof);


%   Calculated parameters 
if strcmp(OptSwitch, 'PDF')
    
    Output = pdf('Chisquare', x, dof)./(Lim.bCDF-Lim.aCDF);
    
    Output(ge(x,Lim.b)) = 0;
    Output(le(x,Lim.a)) = 0;
    
    
elseif strcmp(OptSwitch, 'CDF')
    
    Output = (cdf('Chisquare', x, dof)-Lim.aCDF)./(Lim.bCDF-Lim.aCDF);
    
    Output(ge(x,Lim.b)) = 0;
    Output(le(x,Lim.a)) = 0;
        
    
elseif strcmp(OptSwitch, 'iCDF')
    
    Output = icdf('Chisquare', Pr*(Lim.bCDF-Lim.aCDF)+Lim.aCDF, dof);
    
    
else
    error('Trunc Chisquare failed because no option defined' )
    
end

end