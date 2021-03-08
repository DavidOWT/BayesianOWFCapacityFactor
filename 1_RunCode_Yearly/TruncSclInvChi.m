function Output = TruncSclInvChi(x, nu, tausq, Pr, Lim, OptSwitch)
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

Lim.aCDF = SclInvCDF(Lim.a, nu, tausq);
Lim.bCDF = SclInvCDF(Lim.b, nu, tausq);


%   Calculated parameters 
if strcmp(OptSwitch, 'PDF')
    
    Output = SclInvChiPDF(x, nu, tausq)./(Lim.bCDF-Lim.aCDF);
    
    Output(ge(x,Lim.b)) = 0;
    Output(le(x,Lim.a)) = 0;
    
    
elseif strcmp(OptSwitch, 'CDF')
    
    Output = (SclInvCDF(x, nu, tausq)-Lim.aCDF)./(Lim.bCDF-Lim.aCDF);
    
    Output(ge(x,Lim.b)) = 0;
    Output(le(x,Lim.a)) = 0;
        
    
elseif strcmp(OptSwitch, 'iCDF')
    
    error('This function is incomplete')
    % Output = icdf('Chisquare', Pr*(Lim.bCDF-Lim.aCDF)+Lim.aCDF, nu);
    
    
else
    error('Trunc Scaled Inverse Chisquare failed because no option defined' )
    
end



end


function PDF = SclInvChiPDF(x, nu, tausq)
% PDF: https://en.wikipedia.org/wiki/Scaled_inverse_chi-squared_distribution

    PDF = (0.5*tausq*nu)^(0.5*nu)/gamma(0.5*nu) * exp(0.5*nu*tausq./x)./x.^(1+0.5*nu);

end

function CDF = SclInvCDF(x, nu, tausq)
% CDF: https://en.wikipedia.org/wiki/Scaled_inverse_chi-squared_distribution

    CDF = gammainc(0.5*nu, 0.5*tausq*nu./x)./gamma(0.5*nu);


end


