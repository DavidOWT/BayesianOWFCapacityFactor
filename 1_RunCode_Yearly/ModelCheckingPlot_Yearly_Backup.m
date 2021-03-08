function ModelCheckingPlot_Yearly(energyObs, modelCheck, farmNames, saveLoc)


%   Plot the results
monthName = {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};

smpFarmInd = repelem(1:11, 12);
smpMonthInd = repmat(1:12, [1,11]);


for i = 1:numel(energyObs)
    
    %%  Figure 1 - Minimum
    Pos = [8, 8, 8, 8];
    
    fig{1} = figure('Units', 'centimeters', 'Position', Pos);
    ax1 = axes;
    
    hold on
    histogram(modelCheck.Min(:,i), 'Normalization', 'pdf')
    plt1 = plot([modelCheck.ObsStat(1,i) modelCheck.ObsStat(1,i)], [ax1.YLim(1) ax1.YLim(2)]);
    
    %   Line properties
    ax1.Children(2).FaceColor = [0.4 0.4 0.4];
    ax1.Children(2).EdgeColor = [0.4 0.4 0.4];
    plt1.Color = [0 0 0];
    
    %   Annotation
    dim = [.6 .5 .3 .3];
    str = sprintf('p-value %.3f', modelCheck.PrMin(i));
    ann1 = annotation('textbox',dim,'String',str,'FitBoxToText','on');
    ann1.LineStyle = 'none';
    
    
    %   Label
    ax1.XLabel.String = 'Minimum capacity factor (%)';
    ax1.YLabel.String = 'Count';
    ax1.Title.String = ['Farm name:' farmNames{i} ', Yearly'];
    

    
    % Figure 2 - Maximum
    fig{2} = figure('Units', 'centimeters', 'Position', Pos);
    ax2 = axes;
    
    hold on
    histogram(modelCheck.Max(:,i), 'Normalization', 'pdf')
    plt2 = plot([modelCheck.ObsStat(2,i) modelCheck.ObsStat(2,i)], [ax2.YLim(1) ax2.YLim(2)]);
    
    %   Line properties
    ax2.Children(2).FaceColor = [0.4 0.4 0.4];
    ax2.Children(2).EdgeColor = [0.4 0.4 0.4];
    plt2.Color = [0 0 0];
    
    %   Annotation
    dim = [.6 .5 .3 .3];
    str = sprintf('p-value %.3f', modelCheck.PrMax(i));
    ann1 = annotation('textbox',dim,'String',str,'FitBoxToText','on');
    ann1.LineStyle = 'none';
    
    %   Label
    ax2.XLabel.String = 'Maximum capacity factor (%)';
    ax2.YLabel.String = 'Count';
    ax2.Title.String = ['Farm name:' farmNames{i} ', Yearly'];
    

    
    % Figure 3 - Mean
    fig{3} = figure('Units', 'centimeters', 'Position', Pos);
    ax3 = axes;
    
    hold on
    histogram(modelCheck.Mean(:,i), 'Normalization', 'pdf')
    plt3 = plot([modelCheck.ObsStat(3,i) modelCheck.ObsStat(3,i)], [ax3.YLim(1) ax3.YLim(2)]);
    
    %   Line properties
    ax3.Children(2).FaceColor = [0.4 0.4 0.4];
    ax3.Children(2).EdgeColor = [0.4 0.4 0.4];
    plt3.Color = [0 0 0];
    
    %   Annotation
    dim = [.6 .5 .3 .3];
    str = sprintf('p-value %.3f', modelCheck.PrMean(i));
    ann1 = annotation('textbox',dim,'String',str,'FitBoxToText','on');
    ann1.LineStyle = 'none';
    
    %   Label
    ax3.XLabel.String = 'Mean capacity factor (%)';
    ax3.YLabel.String = 'Count';
    ax3.Title.String = ['Farm name:' farmNames{i} ', Yearly'];
    
    

    % Figure 4 - Standard deviation
    fig{4} = figure('Units', 'centimeters', 'Position', Pos);
    ax4 = axes;
    
    hold on
    histogram(modelCheck.StanD(:,i), 'Normalization', 'pdf')
    plt4 = plot([modelCheck.ObsStat(4,i) modelCheck.ObsStat(4,i)], [ax4.YLim(1) ax4.YLim(2)]);
    
    %   Line properties
    ax4.Children(2).FaceColor = [0.4 0.4 0.4];
    ax4.Children(2).EdgeColor = [0.4 0.4 0.4];
    plt4.Color = [0 0 0];
    
    %   Annotation
    dim = [.6 .5 .3 .3];
    str = sprintf('p-value %.3f', modelCheck.PrStanD(i));
    ann1 = annotation('textbox',dim,'String',str,'FitBoxToText','on');
    ann1.LineStyle = 'none';
    
    %   Label
    ax4.XLabel.String = 'Standard deviation capacity factor (%)';
    ax4.YLabel.String = 'Count';
    ax4.Title.String = ['Farm name:' farmNames{i} ', Yearly'];

    
   
   	%   Save figure
    figName{j} = [saveLoc 'ModelCheck_PrMin_' farmNames{i} '_Yearly'];
    figName = [saveLoc 'ModelCheck_PrMax_' farmNames{i} '_Yearly'];
    figName = [saveLoc 'ModelCheck_PrMean_' farmNames{i} '_Yearly'];
     figName = [saveLoc 'ModelCheck_PrStanD_' farmNames{i} '_Yearly'];
   
    
    
    for j = 1:4
        saveas(fig{j}, [figName, '.fig'])
        print(fig{j}, figName, '-dpng', '-r800')  
    end
        figName = 

    
    close(fig1)
    close(fig2)
    close(fig3)
    close(fig4)
    
end
