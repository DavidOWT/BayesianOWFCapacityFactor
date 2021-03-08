function [theta, MCSample] = simulateMCMC(noChain, iterations, jumpCovMat, TargetDesnity, positiveInd, strSample, capFacObsTrn, FarmData)
%%  Construct markov chain 
%
%   - noChain, 
%   - iterations, 
%   - jumpCovMat = initial jumping distribution covariance matrix, 
%   - TargetDesnity
%   - positiveInd = samples that must be positive, 
%   - strSample = MC starting sample
%
%
%   24/11/20 - Updated to take farmGata as input
%%  Main
%   Initiate parallel pool
% parpool('local',4)


%   Functions for densities
% TargetDesnity = @(smpPar)  JointTargetDensity_OWFYearly_LogitNrm_NChi(smpPar', capFacObsTrn, FarmData);

JumpingDensity = @(X, CurLoc, jumpCovMat) mvnpdf(X', CurLoc', jumpCovMat);
JumpingSample = @(CurLoc, jumpCovMat) mvnrnd(CurLoc', jumpCovMat, 1);

MCSample = cell(noChain,1);
iRej = zeros(noChain,1);
smplAcptCounterInd = cell(noChain,1);
% jumpCovMatLoop = cell(noChain,1);


for ParL = 1:noChain
    tic
    
    %   Construct markov chain
    jumpCovMatLoop = jumpCovMat;
    smplAcptCounter = 0;
    smplCounter = 1;
    iRej(ParL) = 0;
    adaptLim = 1000;
    adaptLimLp = adaptLim;
    countUpdates = 0;
    
    %   MC starting point
    MCSample{ParL,1}(1,:)  = strSample;
    
    %   Density of starting point
    currentThetaDensity = TargetDesnity(MCSample{ParL,1}(smplCounter,:), capFacObsTrn, FarmData);

    while  smplAcptCounter < iterations
        
        %   Sample parameter, ensuring variance is not negative
        propTheta = JumpingSample(MCSample{ParL,1}(smplCounter,:), jumpCovMatLoop);       
        
        %   Density of proposed location
        propThetaDensity = TargetDesnity(propTheta, capFacObsTrn, FarmData);
        
        %   Density ratio
        densityRatio = exp(propThetaDensity-currentThetaDensity);
        %   Metropolis-Hastings
%         densityRatio = exp(propThetaDensity-currentThetaDensity+ ...
%             log(JumpingDensity(propTheta, MCSample{ParL,1}(smplCounter,:), jumpCovMatLoop)/JumpingDensity(MCSample{ParL,1}(smplCounter,:), propTheta, jumpCovMatLoop)));
        
        if all([gt(min([1, densityRatio]), rand(1)), isfinite(propThetaDensity), not(isnan(propThetaDensity))])
            %   accept
            MCSample{ParL,1}(smplCounter+1,:) = propTheta;
            
            %   Update loop parameters
            smplCounter = smplCounter+1;
            smplAcptCounter = smplAcptCounter+1;
            smplAcptCounterInd{ParL}(smplAcptCounter) = smplCounter;
           
            %   Update current location
            currentThetaDensity = propThetaDensity;
            
        else
            %   reject (but keep the sample)
            MCSample{ParL,1}(smplCounter+1,:) = MCSample{ParL,1}(smplCounter,:);
            
            smplCounter = smplCounter+1;            
            iRej(ParL) = iRej(ParL)+1;
            
            
        end
        
        
%         Iterate sample counter
        
        %   Adaptive sampling algorithm from Wagner et al.
        if le(countUpdates, 1)
            if ge(smplAcptCounter, adaptLimLp)

                tStr = 1; % smplCounter-adaptLimLp+1; % smplAcptCounterInd{ParL}(end-adaptLim+1);
                tCur = smplCounter;

                tuningPar = 2.38^2/size(jumpCovMat,2);
                xt = 1/(tCur-tStr)*sum(MCSample{ParL,1}(tStr:tCur,:))';

                %   Empirical distribution sample matrix
                empCovMatTemp = zeros(size(jumpCovMat,2), size(jumpCovMat,2));

                for j = tStr:tCur
                    xj = MCSample{ParL,1}(j,:)';               
                    empCovMatTemp = empCovMatTemp+(xj-xt)*(xj-xt)';

                end

                %   New covariance matrix 
                jumpCovMatLoop = tuningPar*1/(tCur-tStr-1)*empCovMatTemp + 0.000001*eye(size(jumpCovMat,2));
                %   Added small constant to avoid singularity 

                %   Reset sample counter 
                adaptLimLp = adaptLimLp+adaptLim;

                countUpdates = countUpdates+1;
                
                if any(ge(diag(jumpCovMatLoop)', 100))
                    warning('Extreme value in jumping covariance matrix')
%                     pause;

                end
            end
        else

        end

     
    end
    
    b = toc;
    c = clock;
    sprintf('Pool %i completed in %f seconds at %i:%i', ParL, b, c(4), c(5))
    
    saveChain(ParL, MCSample{ParL,1})
    
    
end


%   Remove burn-in
theta = [];
for i = 1:noChain
    theta = [theta;MCSample{i,1}(smplAcptCounterInd{i}(1000):end,:)];
    
end

end


function saveChain(indFileName, chain)

fileName = sprintf('../MCSample_%i.mat', indFileName);

save(fileName, 'chain');

end


