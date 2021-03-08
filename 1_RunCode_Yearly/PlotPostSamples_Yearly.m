function PlotPostSamples_Yearly(energyObs, modelCheck, FarmData, farmNames, saveLoc)


monthName = {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};

smpFarmInd = repelem(1:length(FarmData.Index), 12);
smpMonthInd = repmat(1:12, [1,length(FarmData.Index)]);

obsPlot = energyObs';


for i = 1:numel(energyObs)

    %%  Figure 1 - 
    fig1 = figure;
    ax1 = axes;
    
    hold on
    histogram(cell2mat(modelCheck.Sample(:,i)))
    ax1.Children(1).FaceColor = [0.4 0.4 0.4];
    ax1.Children(1).EdgeColor = [0.4 0.4 0.4];
    
    for j = 1:length(obsPlot{i})
        plt1 = plot([obsPlot{i}(j) obsPlot{i}(j)], [ax1.YLim(1) ax1.YLim(2)]);
        
        %   Line properties
        plt1.Color = [0 0 0];
    end
    
    %   Annotation
%     dim = [.6 .5 .3 .3];
%     str = sprintf('p-value %.3f', modelCheck.PrMin(i));
%     ann1 = annotation('textbox',dim,'String',str,'FitBoxToText','on');
%     ann1.LineStyle = 'none';
    
    
    %   Label
    ax1.XLabel.String = 'Capacity factor';
    ax1.YLabel.String = 'Count';
    ax1.Title.String = ['Farm name: ' farmNames{i}];
    ax1.XLim = [0, 100];
    
    %   Save figure
    figName = [saveLoc 'ModelPredict_' farmNames{i}];
    print(fig1, figName, '-dpng', '-r800')
    
    close(fig1)
end


end


