%%  Capacity factor calculaiton 
%   Using Ofgem data
%
%   TODO - The monthly estimates are eratic compared to https://energynumbers.info/uk-offshore-wind-capacity-factors
%   
%   DW - 31/08/20 - Created
%   DW - 05/10/20 - Updated method for efficiency
%   DW - 06/10/20 - Updated to allow REGO certificates to overlap on date (or
%   have an REGO spanning multiple months)
%   DW - 06/01/21 - Updated REGO certificate database
%%  Initial
% CSV file with modified OFGEM Data
% filename = 'CertificatesExternalPublicDataWarehouse_2000-2020_DWEdit.csv';
filename = 'CertificatesExternalPublicDataWarehouse_2000-2020_060121.csv';

%   Read it
dataFrmt = '%s %q %f %s %s %s %s %{dd/MM/uuuu}D %f %q %s %f %{dd/MM/uuuu}D %s %{dd/MM/uuuu}D %q %q'; 
T = readtable(filename, 'HeaderLines', 4, 'ReadVariableNames', true, 'Delimiter', 'tab', 'Format', dataFrmt);
nameList = unique(T(:,2));

%   MANUAL



%   Read table with wind farm data (commissioning year etc)
filename =  '../YearlyCapacityFactor_Calculated.xlsx';
opts = spreadsheetImportOptions('NumVariables', 16, 'Sheet', 'WindFarm_Comparison', 'DataRange',  'B11:Q54');
windfarmData = readtable(filename, opts);



%%  Calcualtion
%   List of all years and months covered 
yearList = 2003:2020;
monthList =  datetime(2003,1,1):calmonths(1):datetime(2020,9,1);

%   Pre-allocate output variables
prodMonth = zeros(length(monthList), height(nameList));
capFacMonth = zeros(length(monthList), height(nameList));
capFacYear = zeros(length(yearList), height(nameList));

%   Find indices where certificate is issued
isIssued = ge(cellfun( @(X)strcmp(X, 'Redeemed '), T.CertificateStatus)+...
    cellfun( @(X)strcmp(X, 'Issued'), T.CertificateStatus)+...
    cellfun( @(X)strcmp(X, 'Retired'), T.CertificateStatus)+...
    cellfun( @(X)strcmp(X, 'Expired'), T.CertificateStatus)...
    ,0.5);

%   A generation number (other codes e.g., for sale of certificates)
isGeneration = cellfun( @(X) X(1) == 'G', T.StartCertificateNumber(:));
% isROCert = cellfun( @(X) strcmp(X, 'RO'), T.Scheme(:));       % RO seem
% to overlap with REGO

% isCorrectGen = logical(isGeneration+isROCert);



%   For all wind farms
for i = 1:height(nameList)

    nameInd = i;
    nameList{nameInd,1}{1}

    %   Clear old data
    capFac = [];
    yearMatFull = [];
    yearMat = [];
    monthlyResults = [];
    monthlyResults = zeros(length(monthList), 2);
    
    %   Find wind farms with name matching index
    nameMatch = cellfun( @(X)strcmp(X, nameList{nameInd,1}{1}), T{:,2});
    % 27 = London Array


    %   Extract data from correct wind farm and only certificates in isIssued
    cellExtract = and(nameMatch, and(isIssued, isGeneration));
    
    
    %   Data for capacity calcualtion 
    farmCapProd = { T.OutputPeriod_startOfMonth_(cellExtract), ...
                    T.StationTotalInstalledCapacity_W_(cellExtract), ...
                    T.NoCertificates(cellExtract), ...
                    T.MWhPerCertificate(cellExtract), ...
                    T.StartCertificateNumber(cellExtract)};
    
         
    %   Cycle each certificate, calculating capacity factor and start/end date         
    for j = 1:length(farmCapProd{1,1})
        
        %   Certificate starting date
        capFac{j,1} = [str2double(farmCapProd{1,5}{j}(25:26))+2000, str2double(farmCapProd{1,5}{j}(23:24)), str2double(farmCapProd{1,5}{j}(21:22))];

        %   Certificate end date
        capFac{j,2} = [str2double(farmCapProd{1,5}{j}(31:32))+2000, str2double(farmCapProd{1,5}{j}(29:30)), str2double(farmCapProd{1,5}{j}(27:28))];        
      	%   year, month, day
        
        
        %   How many months does the certificate cover?
        if capFac{j,1}(2) == capFac{j,2}(2)
          	noMonths = 1;
            
        else
         	noMonths = capFac{j,2}(2) - capFac{j,1}(2);
            
        end       
        
        
      	% Assign monthly capacity factor - note that a certificate may
      	% cover a number of months
        monthInd = 0;
        
        for k = 1:noMonths
            capFacMonthInd = datetime([capFac{j,1}(1), capFac{j,1}(2)+monthInd, 1]) == monthList;
            
            %   Energy produced (No certificates* MWhPerCertificate) (MWh)
            monthlyResults(capFacMonthInd, 1) = monthlyResults(capFacMonthInd, 1)+farmCapProd{1,3}(j,1).*farmCapProd{1,4}(j,1)/noMonths;
            %   Divide by number of months the certificate generation is
            %   spread over (if any)
            
            % Monthly Energy potential (based on capacity) - will overwrite
            % but that's ok
            monthlyResults(capFacMonthInd, 2) = farmCapProd{1,2}(j,1)*(24*30.4375/1000);
            % Capacity [kW] * (hours per month / 1000) MWh per month
            % Note typo in spreadsheet form OfGem capacity IS kW
            % Note:  365.25/12 = 30.4375 = average number of days in a month         
            
            monthInd = monthInd+1;
            
        end      
    end
    
    
    % Monthly capacity factors     
    prodMonth(:,i) = monthlyResults(:,1);
    capFacMonth(:,i) = monthlyResults(:,1)./monthlyResults(:,2).*100;
    capFacMonth(isnan(capFacMonth(:,i)),i) = 0;

        
    %   Define yearly capacity factors (%)
    for k = 1:length(yearList)
        yearInd = eq(year(monthList),  yearList(k));

        tempCapFac = capFacMonth(yearInd', i);
        
        if eq(sum(eq(tempCapFac,0)), length(eq(tempCapFac,0)))
            capFacYear(k, i) = 0; 
            
        elseif eq(sum(eq(tempCapFac,0)), 0) % full year available
            capFacYear(k, i) = mean(tempCapFac(not(eq(tempCapFac,0))));
            
        elseif eq(yearList(k), 2020)
            capFacYear(k, i) = 0; 
            
        elseif lt(sum(eq(tempCapFac,0)), 6) % at least 6 months
            temp = tempCapFac(not(eq(tempCapFac,0)));
            capFacYear(k, i) = mean(temp(end-5:end));
            
        else % no data or less than 6 months
           capFacYear(k, i) = 0; 
           
        end


    end
    
    
end



%%  Cycle through and cut years before commissioning

%   Extract farms with commissioning year
farmInd = [];
tempComYear = [];

for i = 1:height(windfarmData) 
    if not(isempty(windfarmData{i,12}{1}))
        farmInd(end+1) = i;
        
        tempComYear{end+1,1} = windfarmData{i, 1}{1}; 
        tempComYear{end,2} = windfarmData{i, 12}{1};
        
    end
end

%   Make sure first electricity in commisioning year with > 6 months of
%   production
capFacYearCom = capFacYear;

for i = 1:length(tempComYear)
    
    %   Vector for commissioning date
    a  = datevec(tempComYear{i,2});

    if ge(a(2),6) % If commissioned later than June cut first year capactiy factor  
        capFacYearCom(le(yearList, a(1)), farmInd(i)) = 0;
        
    else % If not keep commisioned year, but cut production in previous years
        capFacYearCom(le(yearList, a(1)-1), farmInd(i)) = 0;
        
    end
end




