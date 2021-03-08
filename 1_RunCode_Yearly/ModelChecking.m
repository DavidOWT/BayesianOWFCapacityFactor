function modelCheck = ModelChecking(theta, energyObs, Switch)

if lt(nargin,3)
    Switch = 'StudentT'; % 'Norm' or 'Logit' or StudentT
end

% theta = [11 OWF, 11 OWF, Hyper-mean, Hyper-variance]
nj = cellfun(@length, energyObs);


nSample = 1000;
indSample = randi(size(theta,1), [nSample,1]);

smpFarmInd = repelem(1:size(energyObs,1),12);
smpMonthInd = repmat(1:12,[1,size(energyObs,1)]);


%   Cycle through posterior samples, generating replication predictions
%   y^{rep} and test statistics T(y^{rep}, \theta)
for i = 1:nSample
    for j = 1:numel(energyObs)
       
        

        %   Extract sample - CHECK this if errors
        if strcmp(Switch, 'Logit')
            %    Yearly Model parameters 
            mu = theta(indSample(i),j); 
            sigma = theta(indSample(i), numel(energyObs)+j);
            
            %   If logit trnasformed 
%             modelCheck.Sample{i,j} = LogitTrnInv(icdf('Normal', rand(1,nj(j)), mu, sigma));
            modelCheck.Sample{i,j} = LogitTrnInv(TruncNorm([], 0, 100, mu, sigma, rand(1,nj(j)), 'iCDF'));
            
            
        elseif strcmp(Switch, 'Norm')
            %    Yearly Model parameters 
            mu = theta(indSample(i),j); 
            sigma = theta(indSample(i), numel(energyObs)+j);
            
         	modelCheck.Sample{i,j} = TruncNorm([], 0, 100, mu, sigma.^2, rand(1,nj(j)), 'iCDF');
            
        elseif strcmp(Switch, 'NormMonthVar')
            %    Yearly Model parameters 
            mu = theta(indSample(i),j); 
            sigma = theta(indSample(i), numel(energyObs)+12+smpMonthInd(j));
            

            
         	modelCheck.Sample{i,j} = TruncNorm([], 0, 100, mu, sigma.^2, rand(1,nj(j)), 'iCDF');  
            
            
        elseif strcmp(Switch, 'StudentT')   % THIS NEEDS CORRECTED
            %    Yearly Model parameters 
            mu = theta(indSample(i),j); 
            sigma = theta(indSample(i), numel(energyObs)+j);
            shp = theta(indSample(i), 2*numel(energyObs)+j);
            
            Lim.a = 0;
            Lim.b = 100;
            modelCheck.Sample{i,j} = TruncTDist([], mu, sigma, scl, rand(1,nj(j)), Lim, 'iCDF');
%             modelCheck.Sample{i,j} = icdf('tLocationScale', rand(1,nj(j)), mu, sigma, shp);
            
            
        end
        
        modelCheck.Min(i,j) = min(modelCheck.Sample{i,j});
        modelCheck.Max(i,j) = max(modelCheck.Sample{i,j});
        modelCheck.Mean(i,j) = mean(modelCheck.Sample{i,j});
        modelCheck.StanD(i,j) = std(modelCheck.Sample{i,j});
        
    end
    
    
end

%   Generate T(y, \theta)
tmpenergyObsTrns = energyObs'; % Cycle through months then farms !!
% tmpenergyObsTrns = energyObs; % Cycle through famrs then months !!

for j = 1:numel(energyObs)
    
    modelCheck.ObsStat(1,j) = min(tmpenergyObsTrns{j});
    modelCheck.ObsStat(2,j) = max(tmpenergyObsTrns{j});
    modelCheck.ObsStat(3,j) = mean(tmpenergyObsTrns{j});
    modelCheck.ObsStat(4,j) = std(tmpenergyObsTrns{j});
    
end

modelCheck.PrMin = sum(ge(modelCheck.Min-modelCheck.ObsStat(1,:),0))/size(modelCheck.Min,1);
modelCheck.PrMax = sum(ge(modelCheck.Max-modelCheck.ObsStat(2,:),0))/size(modelCheck.Max,1);
modelCheck.PrMean = sum(ge(modelCheck.Mean-modelCheck.ObsStat(3,:),0))/size(modelCheck.Mean,1);
modelCheck.PrStanD = sum(ge(modelCheck.StanD-modelCheck.ObsStat(4,:),0))/size(modelCheck.StanD,1);

modelCheck.SumTable = [modelCheck.PrMin; modelCheck.PrMax; modelCheck.PrMean; modelCheck.PrStanD];

end


