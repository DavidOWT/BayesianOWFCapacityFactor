function [logjointProb] = JointTargetDensity_OWFYearlyRound_TrnNrm_NChi(smpPar, samples, FarmData)
% jointProb                                 smpPar', energyObs, FarmData
%%  Joint target density for Bayesian model
%
%   Hierarchical model
%   Level 1 - OWF
%
%   DW - 05/11/20 - Created
%   DW - 05/12/20 - Updated prior
%%  Main


%   Loop variables
J = numel(samples); % No farms
nj = cellfun(@length, samples);


%   Seperate sample
smpTheta = smpPar(1:J, 1);
smpThetaStd = smpPar(J+1:2*J,1);
smpThetaRound = smpPar(2*J+1:2*J+4,1);
smpMu = smpPar(2*J+5:2*J+6, 1);
smpTau = smpPar(2*J+7:end, 1);


%   Sampling indexes
smpObs = samples;


% Hyper-prior samples
sample(1,1) = log(pdf('Uniform', smpMu(1), 0, 100)) + log(pdf('Uniform', smpMu(2), 0, 30)) + sum(log(pdf('Uniform', smpTau, 0, 30)));
% sample(1,1) = 0; 


% Level 2 - - Farm Round
relProbRound1 = log(TruncNorm(smpThetaRound(1:2), 0, 100, smpMu(1), smpTau(1)^2, [], 'PDF'));
relProbRound2 = log(TruncNorm(smpThetaRound(3:4), 0, 40, smpMu(2), smpTau(2)^2, [], 'PDF'));
 

for i = 1:length(unique(FarmData.Round))
    indRound = FarmData.Round == i;
    
    % Level 1 - The parameter samples - Farm
    relProbPar(indRound) = log(TruncNorm(smpTheta(indRound), 0, 100, smpThetaRound(i), smpTau(3)^2, [], 'PDF'));


    % Level 1 - Standard deviation - Farm
    if or(lt(smpThetaRound(2+i),0), lt(smpTau(4),0))
        relProbParVar(indRound) = log(0);
        
    else
        Lim.a = 0;
        Lim.b = 30; 
        
        relProbParVar(indRound) = log(TruncSclInvChi(smpThetaStd(indRound), smpThetaStd(i), smpTau(4).^2, [], Lim, 'PDF'));
        % Scaled inverse Chi-Sqaure is a distribtuion over variance therefore
        % smpThetaStd^2
        % Degree of freedom = smpMu(2), Scale parameter  = smpTau(2)
        
        
    end
    
    
end


% Observation samples (likelihood) - Farm
for i = 1:J 
    relProbObs(sum(nj(1:i-1))+1:sum(nj(1:i)), 1) = log(TruncNorm(smpObs{i}(:), 0, 100, smpTheta(i), smpThetaStd(i)^2, ...
                                                        [], 'PDF'));               
%      relProbObs(sum(nj(1:i-1))+1:sum(nj(1:i)), 1) = log(pdf('tLocationScale', smpObs{i}(:), smpTheta(i), smpThetaStd(i), smpThetaScl(i)));               
    
end


%   Compile sample and compute joint probability 
sample = [sample; relProbPar'; relProbObs; relProbParVar'; relProbRound1; relProbRound2];


logjointProb = sum(sample);
% jointProb = exp(logjointProb);



end

