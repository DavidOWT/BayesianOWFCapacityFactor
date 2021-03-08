%%  Capacity factor calculaiton 
%   Using data downloaded from Elexon database
%
%   
%   DW - 31/08/20 - Created
%   DW - 06/10/20 - Updated method for efficiency
%%  Main
%   Load list of OWF downloaded from elexon database
listOWF = readtable('ElexonOWFList.xlsx');
%   Code, OWF name, Capacity (MW), Date added

%   List of results files (in pwd)
cd('./ElexonProduction')
fileList = ls;

%   List of farm names with results in folder
for i = 1:length(fileList)
   temptName = split(fileList(i,:), {'_', '.'});
   
   farmNameList{i} = temptName{2};
   
end

monthDays = [31, 28.25, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

%   Loop all turbines in Elexon databae 
for i = 1:height(listOWF)
    %   Define farm name and capacity
    FarmResult{i}.Name = listOWF.GeneratorName{i};
    FarmResult{i}.Capacity = listOWF.RegisteredCapacity(i);  % MW
    
    %   Check that results exist
    indFarm = ismember(farmNameList, listOWF.GeneratorName{i});
    
    %   Read results 
    a = readtable(strtrim(fileList(indFarm,:)));
    
    
    yearList = year(a.Date);
    monthList = month(a.Date);
    
    %   Power generated 
    powerGenClean = a.PowerGenMW;
    
    powerGenClean(isnan(powerGenClean)) = 0;
    
    
    FarmResult{i}.GenYear = unique(yearList);
    FarmResult{i}.NoErrorReadings = sum(isnan(powerGenClean));
    
    for j = 1:length(FarmResult{i}.GenYear)
        indYear = ismember(yearList, FarmResult{i}.GenYear(j));
    
        for k = 1:12
            monthInd = and(indYear, k==monthList);
            
            FarmResult{i}.Date((j-1)*12+k, 1:2)  = [k, FarmResult{i}.GenYear(j)];
            
            FarmResult{i}.MonthPower((j-1)*12+k) = sum(powerGenClean(monthInd));
            
            FarmResult{i}.MonthCapFac((j-1)*12+k) = FarmResult{i}.MonthPower((j-1)*12+k)'...
                ./FarmResult{i}.Capacity/(24*monthDays(k))*100;
        end
        
        FarmResult{i}.YearPower(j) = sum(powerGenClean(indYear)); % CHECK
        % powerGenClean in MW per day
        % FarmResult{i}.YearPower(j) in MWh/year
        
        tempMonthCapFac = FarmResult{i}.MonthCapFac((j-1)*12+1:j*12);
        
        FarmResult{i}.YearCapFac(j) = sum(tempMonthCapFac) ./ ...
            length(tempMonthCapFac(not(tempMonthCapFac==0))); % CHECK
        
        
        
    end
    
    FarmResult{i}.YearCapFac(isnan(FarmResult{i}.YearCapFac)) = 0;
    
    
    
end
% 
% 
% % % Capacity Factor
% for i = 1:length(FarmResult)
%     FarmResult{i}.CapFac = FarmResult{i}.YearPower./FarmResult{i}.Capacity/(24*365.25)*100; % CHECK
%     % / MWh per year
% end

% Make table
yearList = 2003:2020;

capTable = table(yearList');
capTable.Properties.VariableNames{1} = 'Year';

for i = 1:length(FarmResult)
           
    capTable(:,i+1) = table([zeros(length(yearList)-length(FarmResult{i}.YearCapFac),1) ...
        ; FarmResult{i}.YearCapFac']);
    capTable.Properties.VariableNames{1+i} = listOWF.FullName{i};
    
end

cd('../')
fileName = 'ElexonCapFactorOutput';
writetable(capTable,fileName)




