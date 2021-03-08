%%  Input
%   XREF version on carmine HPC
%   Information about farm necessary in the updating
%   EDIT MANUALLY
FarmDataPart.Index = [3 7 8 9 13 17 20 22 23 24 26];
FarmDataPart.Round = [1 2 1 2 2 2 2 1 2 1 2];


% With rampion cut & others
FarmData.Index = [3 8 13 15 16 17 20 22 23 24 26 27 28 29 30 33 34 35 36 37 38 41 42 43];
FarmData.Round = [1 1 2  1  2  2  2  1  2  1  2  2  1  1  1  1  1  1  1  2  1  2  2  2];

% FarmData.Index = [3 7 8 9 12 13 15 16 17 20 22 23 24 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44];
% FarmData.Round = [1 2 1 2 2  2  1  2  2  2  1  2  1  2  2  1  1  1  2  2  1  1  1  1  2  1  2  2  2  2  2  2];
% FarmData.Round = [1 2 1 2 2  2  1  2  2  2  1  2  1  2  2  1  1  1  2  3  1  1  1  1  2  1  2  2  2  2  2  2];



%   Indexes for partial set (11 OWF)
partIndex = ismember(FarmData.Index, FarmDataPart.Index);

%   Calculate capacity factor
capFacObs = generateInputInfo(FarmData);

%   DW test - calculate ramp up factor (average between initial yearly and mean later)
% rampUpFactor = cellfun(@(x) x(1)./mean(x(2:end)), capFacObs)



% farmNames = {'Barrow', 'Burbo bank extension', 'Burbo bank', 'Dudgeon', 'Greater gabbard', ...
%     'Gwynt y Mor', 'Humber gateway', 'Inner dowsing', 'Kentish flats ext', 'Kentish flats', 'Lincs'};

% farmNames = {'Barrow', 'Burbo bank extension', 'Burbo bank', 'Dudgeon', 'Galloper', 'Greater gabbard', ...
%     'Gunfleet Sands 1', 'Gunfleet Sands 2', 'Gwynt y Mor', 'Humber gateway', 'Inner dowsing', 'Kentish flats ext', 'Kentish flats',  ...
%     'Lincs', 'London array', 'Lynn', 'North Hoyle', 'Ormonde', 'Race Bank', 'Rampion', 'Rhyl Flats', ...
%     'Robin Rigg (East)', 'Robin Rigg (West)', 'Scroby Sands', 'Sheringham Shoal', 'Teesside windfarm', ...
%     'Thanet', 'Walney Extension', 'Walney Phase I', 'Walney Phase II', 'West of Duddon Sands', 'Westermost Rough'};

farmNames = {'Barrow', 'Burbo bank', 'Greater gabbard', ...
    'Gunfleet Sands 1', 'Gunfleet Sands 2', 'Gwynt y Mor', 'Humber gateway', 'Inner dowsing', 'Kentish flats ext', 'Kentish flats',  ...
    'Lincs', 'London array', 'Lynn', 'North Hoyle', 'Ormonde', 'Rhyl Flats', ...
    'Robin Rigg (East)', 'Robin Rigg (West)', 'Scroby Sands', 'Sheringham Shoal', 'Teesside windfarm', ...
    'Walney Phase I', 'Walney Phase II', 'West of Duddon Sands'};



%%  Deinfe models

%   Model 1 - Truncated Gaussian - N N
Yearly_InputInfo{1}.Name = 'YearRound_TncNrm_NN';
Yearly_InputInfo{1}.Data = capFacObs;
Yearly_InputInfo{1}.noChain = 12;
Yearly_InputInfo{1}.iterations = 15000;
Yearly_InputInfo{1}.jumpCovMat = [0.1*ones(1,numel(Yearly_InputInfo{1}.Data)), ... 
                                0.05*ones(1,numel(Yearly_InputInfo{1}.Data)), ... 
                                0.1, 0.01, 0.1, 0.01,...
                                0.1, 0.01,...
                                0.05, 0.02, 0.008, 0.0005];
Yearly_InputInfo{1}.TargetDesnity = @(smpPar, capFacObsTrn, FarmData)  JointTargetDensity_OWFYearlyRound_TrnNrm_NN(smpPar', capFacObsTrn, FarmData);
% Yearly_InputInfo{1}.strSample = [36.14546773	39.37897847	34.58252646	45.02408655	41.48984304	36.53049244	42.06896664	35.98197841	44.01191622	32.19855712	41.03629391	4.274357885	4.074707498	3.982269321	3.962553666	3.954155585	4.294458728	4.411511796	4.282768447	4.610610826	4.086960289	3.464609405	39.2440931	4.108207279	5.69681164	1.028578298];                        
Yearly_InputInfo{1}.strSample = [40.*ones(1,numel(Yearly_InputInfo{1}.Data)), ...
                                2.*ones(1,numel(Yearly_InputInfo{1}.Data)), ...
                                40, 40, 2, 2, ... % 40.*ones(1,6), ...
                                40, 2, ...
                                2, 1, 2, 1];
Yearly_InputInfo{1}.positiveInd = [numel(Yearly_InputInfo{1}.Data)+1:2*numel(Yearly_InputInfo{1}.Data), 2*numel(Yearly_InputInfo{1}.Data)+3:2*numel(Yearly_InputInfo{1}.Data)+4];
Yearly_InputInfo{1}.FolderName = '1_Model_YearRound_TncNormal_NN'; 
Yearly_InputInfo{1}.farmNames  = farmNames;
Yearly_InputInfo{1}.farmData.Round  = FarmData.Round;
Yearly_InputInfo{1}.farmData.Index  = FarmData.Index;
Yearly_InputInfo{1}.obsDist  = 'Norm';


%   Model 2 - Truncated Gaussian - N LN
% Yearly_InputInfo{2}.Name = 'YearRound_TncNrm_NLN';
% Yearly_InputInfo{2}.Data = capFacObs;
% Yearly_InputInfo{2}.noChain = 12;
% Yearly_InputInfo{2}.iterations = 12000;
% Yearly_InputInfo{2}.jumpCovMat = [0.1*ones(1,numel(Yearly_InputInfo{2}.Data)), ... 
%                                 0.05*ones(1,numel(Yearly_InputInfo{2}.Data)), ... 
%                                 0.1, 0.01, 0.1, 0.01,...
%                                 0.1, 0.01,...
%                                 0.05, 0.02, 0.008, 0.0005];
% Yearly_InputInfo{2}.TargetDesnity = @(smpPar, capFacObsTrn, FarmData)  JointTargetDensity_OWFYearlyRound_TrnNrm_NLN(smpPar', capFacObsTrn, FarmData);
% % Yearly_InputInfo{2}.strSample = [36.14546773	39.37897847	34.58252646	45.02408655	41.48984304	36.53049244	42.06896664	35.98197841	44.01191622	32.19855712	41.03629391	4.274357885	4.074707498	3.982269321	3.962553666	3.954155585	4.294458728	4.411511796	4.282768447	4.610610826	4.086960289	3.464609405	39.2440931	4.108207279	5.69681164	1.028578298];                        
% Yearly_InputInfo{2}.strSample = [40.*ones(1,numel(Yearly_InputInfo{2}.Data)), ...
%                                 4.*ones(1,numel(Yearly_InputInfo{2}.Data)), ...
%                                 40, 40, 4, 4, ... % 40.*ones(1,6), ...
%                                 40, 4, ...
%                                 5, 1, 5, 1];
% Yearly_InputInfo{2}.positiveInd = [numel(Yearly_InputInfo{2}.Data)+1:2*numel(Yearly_InputInfo{2}.Data), 2*numel(Yearly_InputInfo{2}.Data)+3:2*numel(Yearly_InputInfo{2}.Data)+4];
% Yearly_InputInfo{2}.FolderName = '1_Model_YearRound_TncNormal_NLN'; 
% Yearly_InputInfo{2}.farmNames  = farmNames;
% Yearly_InputInfo{2}.farmData.Round  = FarmData.Round;
% Yearly_InputInfo{2}.farmData.Index  = FarmData.Index;
% Yearly_InputInfo{2}.obsDist  = 'Norm';


%   Model 3 - Truncated Gaussian - N Chi
Yearly_InputInfo{3}.Name = 'YearRound_TncNrm_NChi';
Yearly_InputInfo{3}.Data = capFacObs;
Yearly_InputInfo{3}.noChain = 12;
Yearly_InputInfo{3}.iterations = 15000;
Yearly_InputInfo{3}.jumpCovMat = [0.1*ones(1,numel(Yearly_InputInfo{3}.Data)), ... 
                                0.05*ones(1,numel(Yearly_InputInfo{3}.Data)), ... 
                                0.1, 0.01, 0.1, 0.01,...
                                0.1, 0.01,...
                                0.05, 0.02, 0.008, 0.0005];
Yearly_InputInfo{3}.TargetDesnity = @(smpPar, capFacObsTrn, FarmData)  JointTargetDensity_OWFYearlyRound_TrnNrm_NChi(smpPar', capFacObsTrn, FarmData);
% Yearly_InputInfo{3}.strSample = [36.14546773	39.37897847	34.58252646	45.02408655	41.48984304	36.53049244	42.06896664	35.98197841	44.01191622	32.19855712	41.03629391	4.274357885	4.074707498	3.982269321	3.962553666	3.954155585	4.294458728	4.411511796	4.282768447	4.610610826	4.086960289	3.464609405	39.2440931	4.108207279	5.69681164	1.028578298];                        
Yearly_InputInfo{3}.strSample = [40.*ones(1,numel(Yearly_InputInfo{3}.Data)), ...
                                2.*ones(1,numel(Yearly_InputInfo{3}.Data)), ...
                                40, 40, 2, 2, ... % 40.*ones(1,6), ...
                                40, 2, ...
                                2, 1, 2, 1];
Yearly_InputInfo{3}.positiveInd = [numel(Yearly_InputInfo{3}.Data)+1:2*numel(Yearly_InputInfo{3}.Data), 2*numel(Yearly_InputInfo{3}.Data)+3:2*numel(Yearly_InputInfo{3}.Data)+4];
Yearly_InputInfo{3}.FolderName = '1_Model_YearRound_TncNormal_NChi'; 
Yearly_InputInfo{3}.farmNames  = farmNames;
Yearly_InputInfo{3}.farmData.Round  = FarmData.Round;
Yearly_InputInfo{3}.farmData.Index  = FarmData.Index;
Yearly_InputInfo{3}.obsDist  = 'Norm';


% %   Model 4 - Logit Gaussian - NN
% Yearly_InputInfo{4}.Name = 'YearRound_LogitNrm_NN';
% Yearly_InputInfo{4}.Data = LogitTrn(capFacObs);
% Yearly_InputInfo{4}.noChain = 12;
% Yearly_InputInfo{4}.iterations = 12000;
% Yearly_InputInfo{4}.jumpCovMat = [0.02*ones(1,numel(Yearly_InputInfo{4}.Data)), ... 
%                                 0.0001*ones(1,numel(Yearly_InputInfo{4}.Data)), ... 
%                                 0.02, 0.0001, 0.02, 0.0001,...
%                                 0.02, 0.0001,...
%                                 0.0001, 0.0001, 0.0001, 0.0001];
% % Yearly_InputInfo{4}.jumpCovMat = [0.02*ones(1,numel(Yearly_InputInfo{4}.Data)), ... 
% %                                 0.0001*ones(1,numel(Yearly_InputInfo{4}.Data)), ... 
% %                                 0.02, 0.0001, 0.0001, 0.00001];
% % Yearly_InputInfo{4}.strSample = [-0.5.*ones(1,numel(Yearly_InputInfo{4}.Data)), ...
% %                                 0.15.*ones(1,numel(Yearly_InputInfo{4}.Data)), ...
% %                                 -0.5, 0.15, 0.2, 0.05];
% Yearly_InputInfo{4}.strSample = [-0.5.*ones(1,numel(Yearly_InputInfo{4}.Data)), ...
%                                 0.15.*ones(1,numel(Yearly_InputInfo{4}.Data)), ...
%                                 -0.5, -0.5, 0.15, 0.15, ... % 40.*ones(1,6), ...
%                                 -0.5, -0.15, ...
%                                 0.2, 0.05, 0.2, 0.05];
% Yearly_InputInfo{4}.TargetDesnity = @(smpPar, capFacObsTrn, FarmData)  JointTargetDensity_OWFYearlyRound_LogitNrm_NN(smpPar', capFacObsTrn, FarmData);
% Yearly_InputInfo{4}.positiveInd = [12:22,25:26];
% Yearly_InputInfo{4}.FolderName = '1_Model_YearRound_LogitNormal_NN'; 
% Yearly_InputInfo{4}.farmNames  = farmNames;
% Yearly_InputInfo{4}.farmData.Round  = FarmData.Round;
% Yearly_InputInfo{4}.farmData.Index  = FarmData.Index;
% Yearly_InputInfo{4}.obsDist  = 'Logit';
% 
% 
% %   Model 5 - Logit Gaussian - N LN
% Yearly_InputInfo{5}.Name = 'YearRound_LogitNrm_NLN';
% Yearly_InputInfo{5}.Data = LogitTrn(capFacObs);
% Yearly_InputInfo{5}.noChain = 12;
% Yearly_InputInfo{5}.iterations = 12000;
% Yearly_InputInfo{5}.jumpCovMat = [0.02*ones(1,numel(Yearly_InputInfo{5}.Data)), ... 
%                                 0.0001*ones(1,numel(Yearly_InputInfo{5}.Data)), ... 
%                                 0.02, 0.0001, 0.02, 0.0001,...
%                                 0.02, 0.0001,...
%                                 0.0001, 0.0001, 0.0001, 0.0001];
% % Yearly_InputInfo{5}.strSample = [-0.5.*ones(1,numel(Yearly_InputInfo{5})), ...
% %                                 0.15.*ones(1,numel(Yearly_InputInfo{5})), ...
% %                                 -0.5, 0.15, 0.2, 0.05];   
% Yearly_InputInfo{5}.strSample = [-0.5.*ones(1,numel(Yearly_InputInfo{5}.Data)), ...
%                                 0.15.*ones(1,numel(Yearly_InputInfo{5}.Data)), ...
%                                 -0.5, -0.5, 0.15, 0.15, ... % 40.*ones(1,6), ...
%                                 -0.5, -0.15, ...
%                                 0.2, 0.05, 0.2, 0.05];
% Yearly_InputInfo{5}.TargetDesnity = @(smpPar, capFacObsTrn, FarmData)  JointTargetDensity_OWFYearlyRound_LogitNrm_NLN(smpPar', capFacObsTrn, FarmData);
% Yearly_InputInfo{5}.positiveInd = [12:22,24:26];
% Yearly_InputInfo{5}.FolderName = '1_Model_YearRound_LogitNormal_NLN'; 
% Yearly_InputInfo{5}.farmNames  = farmNames;
% Yearly_InputInfo{5}.farmData.Round  = FarmData.Round;
% Yearly_InputInfo{5}.farmData.Index  = FarmData.Index;
% Yearly_InputInfo{5}.obsDist  = 'Logit';
% 
% 
% %   Model 6 - Logit Gaussian - N Chi
% Yearly_InputInfo{6}.Name = 'YearRound_LogitNrm_NChi';
% Yearly_InputInfo{6}.Data = LogitTrn(capFacObs);
% Yearly_InputInfo{6}.noChain = 12;
% Yearly_InputInfo{6}.iterations = 12000;
% Yearly_InputInfo{6}.positiveInd = [12:22,24:26];
% Yearly_InputInfo{6}.jumpCovMat = [0.02*ones(1,numel(Yearly_InputInfo{6}.Data)), ... 
%                                 0.0001*ones(1,numel(Yearly_InputInfo{6}.Data)), ... 
%                                 0.02, 0.0001, 0.02, 0.0001,...
%                                 0.02, 0.0001,...
%                                 0.0001, 0.0001, 0.0001, 0.0001];
% % Yearly_InputInfo{6}.strSample = [-0.5.*ones(1,numel(Yearly_InputInfo{6}.Data)), ...
% %                             0.15.*ones(1,numel(Yearly_InputInfo{6}.Data)), ...
% %                             -0.5, 0.15, 0.2, 0.05];  
% Yearly_InputInfo{6}.strSample = [-0.5.*ones(1,numel(Yearly_InputInfo{6}.Data)), ...
%                                 0.15.*ones(1,numel(Yearly_InputInfo{6}.Data)), ...
%                                 -0.5, -0.5, 0.15, 0.15, ... % 40.*ones(1,6), ...
%                                 -0.5, -0.15, ...
%                                 0.2, 0.05, 0.2, 0.05];
% Yearly_InputInfo{6}.TargetDesnity = @(smpPar, capFacObsTrn, FarmData)  JointTargetDensity_OWFYearlyRound_LogitNrm_NChi(smpPar', capFacObsTrn, FarmData);
% Yearly_InputInfo{6}.FolderName = '1_Model_YearRound_LogitNormal_NChi'; 
% Yearly_InputInfo{6}.farmNames  = farmNames;
% Yearly_InputInfo{6}.farmData.Round  = FarmData.Round;
% Yearly_InputInfo{6}.farmData.Index  = FarmData.Index;
% Yearly_InputInfo{6}.obsDist  = 'Logit';


% 
% 
% %   Model 10 - Logit Student-t - N N N 
% Yearly_InputInfo{10}.Name = 'Year_LogitTDist_NNN';
% Yearly_InputInfo{10}.Data = LogitTrn(capFacObs(partIndex));
% Yearly_InputInfo{10}.noChain = 8;
% Yearly_InputInfo{10}.iterations = 3000;
% Yearly_InputInfo{10}.jumpCovMat = [0.02*ones(1,numel(Yearly_InputInfo{10}.Data)), ... 
%                                 0.0001*ones(1,numel(Yearly_InputInfo{10}.Data)), ... 
%                                 0.5*ones(1,numel(Yearly_InputInfo{10}.Data)), ... 
%                                 0.02, 0.0001, 0.5, 0.0019, 0.0001, 0.01];
% Yearly_InputInfo{10}.TargetDesnity = @(smpPar, capFacObsTrn, FarmData)  JointTargetDensity_OWFYearly_LogitTDist_NNN(smpPar', capFacObsTrn, FarmData);
% Yearly_InputInfo{10}.strSample = [-0.5.*ones(1,numel(Yearly_InputInfo{10}.Data)), ...
%                                 0.15.*ones(1,numel(Yearly_InputInfo{10}.Data)), ...
%                                 1.*ones(1,numel(Yearly_InputInfo{10}.Data)), ...
%                                 -0.5, 0.15, 1, 0.2, 0.05, 0.5]; 
% Yearly_InputInfo{10}.positiveInd = [12:33, 35:36, 38:39];
% Yearly_InputInfo{10}.FolderName = '1_Model_Year_LogitTDist_NNN'; 
% 
% 
% %   Model 11 - Logit Student-t - N LN N 
% Yearly_InputInfo{11}.Name = 'Year_LogitTDist_NLNN';
% Yearly_InputInfo{11}.Data = LogitTrn(capFacObs(partIndex));
% Yearly_InputInfo{11}.noChain = 8;
% Yearly_InputInfo{11}.iterations = 3000;
% Yearly_InputInfo{11}.jumpCovMat = [0.02*ones(1,numel(Yearly_InputInfo{11}.Data)), ... 
%                                 0.0001*ones(1,numel(Yearly_InputInfo{11}.Data)), ... 
%                                 0.5*ones(1,numel(Yearly_InputInfo{11}.Data)), ... 
%                                 0.02, 0.0001, 0.5, 0.0019, 0.0001, 0.01];
% Yearly_InputInfo{11}.TargetDesnity = @(smpPar, capFacObsTrn, FarmData)  JointTargetDensity_OWFYearly_LogitTDist_NLNN(smpPar', capFacObsTrn, FarmData);
% Yearly_InputInfo{11}.strSample = [-0.5.*ones(1,numel(Yearly_InputInfo{11}.Data)), ...
%                                 0.15.*ones(1,numel(Yearly_InputInfo{11}.Data)), ...
%                                 1.*ones(1,numel(Yearly_InputInfo{11}.Data)), ...
%                                 -0.5, 0.15, 1, 0.2, 0.05, 0.5]; 
% Yearly_InputInfo{11}.positiveInd = [12:33, 35:36, 38:39];
% Yearly_InputInfo{11}.FolderName = '1_Model_Year_LogitTDist_NLNN'; 
% 
% 
% %   Model 12 - Logit Student-t - N Chi N 
% Yearly_InputInfo{12}.Name = 'Year_LogitTDist_NChiN';
% Yearly_InputInfo{12}.Data = LogitTrn(capFacObs(partIndex));
% Yearly_InputInfo{12}.noChain = 8;
% Yearly_InputInfo{12}.iterations = 3000;
% Yearly_InputInfo{12}.jumpCovMat = [0.02*ones(1,numel(Yearly_InputInfo{12}.Data)), ... 
%                                 0.0001*ones(1,numel(Yearly_InputInfo{12}.Data)), ... 
%                                 0.5*ones(1,numel(Yearly_InputInfo{12}.Data)), ... 
%                                 0.02, 0.0001, 0.5, 0.0019, 0.0001, 0.01];
% Yearly_InputInfo{12}.TargetDesnity = @(smpPar, capFacObsTrn, FarmData)  JointTargetDensity_OWFYearly_LogitTDist_NChiN(smpPar', capFacObsTrn, FarmData);
% Yearly_InputInfo{12}.strSample = [-0.5.*ones(1,numel(Yearly_InputInfo{12}.Data)), ...
%                                 0.15.*ones(1,numel(Yearly_InputInfo{12}.Data)), ...
%                                 1.*ones(1,numel(Yearly_InputInfo{12}.Data)), ...
%                                 -0.5, 0.15, 1, 0.2, 0.05, 0.5]; 
% Yearly_InputInfo{12}.positiveInd = [12:33, 35:36, 37:39];
% Yearly_InputInfo{12}.FolderName = '1_Model_Year_LogitTDist_NChiN'; 


%   Model 19 - Student-t distribution, Level 1 = OWF Level 2 = round
%   N LN N; N N N
% Yearly_InputInfo{19}.Name = 'YearRound_LogitTDist_NLNN';
% Yearly_InputInfo{19}.Data = capFacObs(partIndex);
% Yearly_InputInfo{19}.noChain = 16;
% Yearly_InputInfo{19}.iterations = 4500;
% Yearly_InputInfo{19}.jumpCovMat = [0.1*ones(1,numel(Yearly_InputInfo{19}.Data)), ... 
%                                     0.005*ones(1,numel(Yearly_InputInfo{19}.Data)), ... 
%                                     0.25.*ones(1,numel(Yearly_InputInfo{19}.Data)), ... 
%                                     0.01, 0.05, 0.01, 0.03, 0.2, 0.1, ... % 1*ones(1,6), ... 
%                                     0.02, 0.03, 0.7, 0.05, 0.02, 0.1, 0.008, 0.0005, 0.1];
% Yearly_InputInfo{19}.TargetDesnity = @(smpPar, capFacObsTrn, FarmData)  JointTargetDensity_OWFYearlyRound_TDist_NLNN(smpPar', capFacObsTrn, FarmData);
% Yearly_InputInfo{19}.strSample = [40.*ones(1,numel(Yearly_InputInfo{19}.Data)), ...
%                                 4.*ones(1,numel(Yearly_InputInfo{19}.Data)), ...
%                                 100.*ones(1,numel(Yearly_InputInfo{19}.Data)), ... 
%                                 40, 40, 4, 4, 100, 100, ... % 40.*ones(1,6), ...
%                                 40, 4, 100, 5, 1, 10, 5, 1, 10];
% Yearly_InputInfo{19}.positiveInd = [12:33, 36:39, length(Yearly_InputInfo{19}.strSample)-6:length(Yearly_InputInfo{19}.strSample)];
% Yearly_InputInfo{19}.FolderName = '1_Model_YearRound_LogitTDist_NLNN'; 
% Yearly_InputInfo{19}.farmNames  = farmNames(partIndex);
% Yearly_InputInfo{19}.farmData  = FarmDataPart;
% Yearly_InputInfo{19}.obsDist  = 'StudentT';


% %   Model 20 - Student-t distribution, Level 1 = OWF Level 2 = round
% %   N LN N; N N N
% Yearly_InputInfo{20}.Name = 'YearRound_LogitTDist_NLNN';
% Yearly_InputInfo{20}.Data = capFacObs(1:6);
% Yearly_InputInfo{20}.noChain = 12;
% Yearly_InputInfo{20}.iterations = 10000;
% Yearly_InputInfo{20}.jumpCovMat = [0.1*ones(1,numel(Yearly_InputInfo{20}.Data)), ... 
%                                     0.005*ones(1,numel(Yearly_InputInfo{20}.Data)), ... 
%                                     0.25*ones(1,numel(Yearly_InputInfo{20}.Data)), ... 
%                                     0.01, 0.05, 0.01, 0.03, 0.2, 0.1, ... % 1*ones(1,6), ... 
%                                     0.02, 0.03, 0.7, 0.05, 0.02, 0.1, 0.008, 0.0005, 0.1];
% % Yearly_InputInfo{20}.jumpCovMat = [1*ones(1,numel(Yearly_InputInfo{20}.Data)), ... 
% %                                     0.5*ones(1,numel(Yearly_InputInfo{20}.Data)), ... 
% %                                     25*ones(1,numel(Yearly_InputInfo{20}.Data)), ... 
% %                                     1, 1, 0.3, 0.3, 25, 25, ... % 1*ones(1,6), ... 
% %                                     1, 0.3, 25, 0.5, 0.3, 2.5, 0.5, 0.3, 2.5];
% Yearly_InputInfo{20}.TargetDesnity = @(smpPar, capFacObsTrn, FarmData)  JointTargetDensity_OWFYearlyRound_TDist_NLNN(smpPar', capFacObsTrn, FarmData);
% Yearly_InputInfo{20}.strSample = [40.*ones(1,numel(Yearly_InputInfo{20}.Data)), ...
%                                 4.*ones(1,numel(Yearly_InputInfo{20}.Data)), ...
%                                 100.*ones(1,numel(Yearly_InputInfo{20}.Data)), ... 
%                                 40, 40, 4, 4, 100, 100, ... % 40.*ones(1,6), ...
%                                 40, 4, 100, 5, 1, 10, 5, 1, 10];
% Yearly_InputInfo{20}.positiveInd = [length(Yearly_InputInfo{20}.Data)+1:3*length(Yearly_InputInfo{20}.Data), ...
%                                     3*length(Yearly_InputInfo{20}.Data)+3:3*length(Yearly_InputInfo{20}.Data)+6, ...
%                                     length(Yearly_InputInfo{20}.strSample)-5:length(Yearly_InputInfo{20}.strSample)];
% Yearly_InputInfo{20}.FolderName = '1_Model_YearRound_LogitTDist_NLNN_Full'; 
% Yearly_InputInfo{20}.farmNames  = farmNames;
% Yearly_InputInfo{20}.farmData.Round  = FarmData.Round(1:6);
% Yearly_InputInfo{20}.farmData.Index  = FarmData.Index(1:6);
% Yearly_InputInfo{20}.obsDist  = 'StudentT';




%%  Simulation
%   Prepare input data
mdlUse = gt(cellfun(@length,Yearly_InputInfo),0);
mdlUseInd = 1:length(Yearly_InputInfo);
mdlUseInd = mdlUseInd(mdlUse);


for i = mdlUseInd
    
    %   Prepare inputs
    saveLoc = ['../' Yearly_InputInfo{i}.FolderName '/'];
    if ~exist(saveLoc, 'dir')
        mkdir(saveLoc)
    end
    
    noChain = Yearly_InputInfo{i}.noChain;
    iterations = Yearly_InputInfo{i}.iterations;
    jumpCovMat = Yearly_InputInfo{i}.jumpCovMat;
    TargetDesnity = Yearly_InputInfo{i}.TargetDesnity;
    positiveInd = Yearly_InputInfo{i}.positiveInd;
    strSample = Yearly_InputInfo{i}.strSample;
    Data = Yearly_InputInfo{i}.Data; 
    
    farmNames = Yearly_InputInfo{i}.farmNames; 
    farmData = Yearly_InputInfo{i}.farmData; 
    obsDist = Yearly_InputInfo{i}.obsDist;
    
    %   Simulate MCMC 
    [theta, MCSample] = simulateMCMC(noChain, iterations, jumpCovMat, TargetDesnity, positiveInd, strSample, Data, farmData);
  
    
    r = PlotPostConv(theta(1:floor(length(theta)/5)*5,:));
    
    
    % %%  Model checking - Note cut to 12
    modelCheck = ModelChecking_Yearly(theta, Data, obsDist); 
    ModelCheckingPlot_Yearly(Data, modelCheck, farmNames, saveLoc)
    PlotPostSamples_Yearly(Data, modelCheck, FarmData, farmNames, saveLoc)
    
    runInfo = Yearly_InputInfo{i};
    save([saveLoc 'MatlabData'], 'modelCheck',  'r', 'theta', 'MCSample', 'runInfo');
    
    
end



%%  Local function
function capFacObs = generateInputInfo(FarmData)
%   Load monthly capacity factors (OfGem)
load('..\OfGemData\CapacityFactors.mat')   

FarmData.capFacYear = capFacYearCom(:,FarmData.Index); %   Not needed for
% yearly


for i = 1:size(FarmData.capFacYear,2)
    capFacYear = FarmData.capFacYear(:,i);
    
    %   Identify index of first month
    FirstYearInd = 0;
    j = 1;
    while FirstYearInd == 0
        if eq(capFacYear(j),0)
            j = j+1;
        else
            FirstYearInd = j;
        end
    end
    
    
    capFacYear(1:j-1) = [];
    capFacObs{i} = capFacYear;

end
end