function r = PlotPostConv(theta)
%%  Plot posterior samples and convergence for MCMC 
%   Use convergence statistic from Gelman et al. BDA 
%
%   DW - 29/10/20 - Created
%%  Main

median(theta(:,1:end-2),1);
% median(exp(theta(500:end,end-1:end)),1)
median(theta(:,end-1:end),1);

% iReg./iterations


%   Assess convergence
for i = 1:size(theta,2)
    
    thetaRe = reshape(theta(:,i),[],5);
    
    [n, m] = size(thetaRe);
    
    
    %   Between chain
    bChain = n/(m-1)*sum((mean(thetaRe,1)-mean(mean(thetaRe,1))).^2);
    
    %   Within chain
    wChain = 1/m*sum( 1/(n-1)*sum((thetaRe-mean(thetaRe,1)).^2, 1) );
    
    varMarPost = (n-1)/n*wChain + 1/n*bChain;
    
    %   Scale reduciton
    r(i) = sqrt(varMarPost/wChain);
    
end


%   OLD plots of posterior before burn in removal, pre-ParFor
% fig1 = figure;
% ax1 = axes;
% 
% pl1 = plot(theta(:,1), theta(:,2));
% 
% pl1.Marker = '.';
% pl1.LineWidth = 0.2;
% 
% ax1.XLabel.String = '/theta_1';
% ax1.YLabel.String = '/theta_2';
% 
% 
% 
% fig2 = figure;
% ax2 = axes;
% 
% pl2 = plot(theta(:,3), theta(:,4));
% 
% pl2.Marker = '.';
% pl2.LineWidth = 0.2;
% 
% ax2.XLabel.String = '/theta_3';
% ax2.YLabel.String = '/theta_4';
% 
% 
% fig3 = figure;
% ax3 = axes;
% 
% pl3 = plot(theta(:,end-1), theta(:,end));
% 
% pl3.Marker = '.';
% pl3.LineWidth = 0.2;
% 
% ax3.XLabel.String = 'sigma';
% ax3.YLabel.String = 'tau';

% ax1.XLim = [-2.5, 2.5];
% ax1.YLim = [-2.5, 2.5];


end