function ModelCheckingPlot_Yearly(energyObs, modelCheck, farmNames, saveLoc)


%   Plot the results
monthName = {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};

smpFarmInd = repelem(1:11, 12);
smpMonthInd = repmat(1:12, [1,11]);


for i = 1:numel(energyObs)
    
    %%  Figure 1 - Minimum
    Pos = [8, 8, 8, 8];
    
    fig{1} = figure('Units', 'centimeters', 'Position', Pos);
    ax{1} = axes;
    
    hold on
    histogram(modelCheck.Min(:,i), 'Normalization', 'pdf')
    plt1 = plot([modelCheck.ObsStat(1,i) modelCheck.ObsStat(1,i)], [ax{1}.YLim(1) ax{1}.YLim(2)]);
    
    %   Line properties
    ax{1}.Children(2).FaceColor = [0.4 0.4 0.4];
    ax{1}.Children(2).EdgeColor = [0.4 0.4 0.4];
    plt1.Color = [0 0 0];
    
    %   Annotation
    dim = [.6 .5 .3 .3];
    str = sprintf('p-value %.3f', modelCheck.PrMin(i));
    ann1 = annotation('textbox',dim,'String',str,'FitBoxToText','on');
    ann1.LineStyle = 'none';
    
    
    %   Label
    ax{1}.XLabel.String = 'Minimum capacity factor (%)';
    ax{1}.YLabel.String = 'PMF value';
    ax{1}.Title.String = ['Farm name:' farmNames{i} ', Yearly'];
    

    
    % Figure 2 - Maximum
    fig{2} = figure('Units', 'centimeters', 'Position', Pos);
    ax{2} = axes;
    
    hold on
    histogram(modelCheck.Max(:,i), 'Normalization', 'pdf')
    plt2 = plot([modelCheck.ObsStat(2,i) modelCheck.ObsStat(2,i)], [ax{2}.YLim(1) ax{2}.YLim(2)]);
    
    %   Line properties
    ax{2}.Children(2).FaceColor = [0.4 0.4 0.4];
    ax{2}.Children(2).EdgeColor = [0.4 0.4 0.4];
    plt2.Color = [0 0 0];
    
    %   Annotation
    dim = [.6 .5 .3 .3];
    str = sprintf('p-value %.3f', modelCheck.PrMax(i));
    ann1 = annotation('textbox',dim,'String',str,'FitBoxToText','on');
    ann1.LineStyle = 'none';
    
    %   Label
    ax{2}.XLabel.String = 'Maximum capacity factor (%)';
    ax{2}.YLabel.String = 'PMF value';
    ax{2}.Title.String = ['Farm name:' farmNames{i} ', Yearly'];
    

    
    % Figure 3 - Mean
    fig{3} = figure('Units', 'centimeters', 'Position', Pos);
    ax{3} = axes;
    
    hold on
    histogram(modelCheck.Mean(:,i), 'Normalization', 'pdf')
    plt3 = plot([modelCheck.ObsStat(3,i) modelCheck.ObsStat(3,i)], [ax{3}.YLim(1) ax{3}.YLim(2)]);
    
    %   Line properties
    ax{3}.Children(2).FaceColor = [0.4 0.4 0.4];
    ax{3}.Children(2).EdgeColor = [0.4 0.4 0.4];
    plt3.Color = [0 0 0];
    
    %   Annotation
    dim = [.6 .5 .3 .3];
    str = sprintf('p-value %.3f', modelCheck.PrMean(i));
    ann1 = annotation('textbox',dim,'String',str,'FitBoxToText','on');
    ann1.LineStyle = 'none';
    
    %   Label
    ax{3}.XLabel.String = 'Mean capacity factor (%)';
    ax{3}.YLabel.String = 'PMF value';
    ax{3}.Title.String = ['Farm name:' farmNames{i} ', Yearly'];
    
    

    % Figure 4 - Standard deviation
    fig{4} = figure('Units', 'centimeters', 'Position', Pos);
    ax{4} = axes;
    
    hold on
    histogram(modelCheck.StanD(:,i), 'Normalization', 'pdf')
    plt4 = plot([modelCheck.ObsStat(4,i) modelCheck.ObsStat(4,i)], [ax{4}.YLim(1) ax{4}.YLim(2)]);
    
    %   Line properties
    ax{4}.Children(2).FaceColor = [0.4 0.4 0.4];
    ax{4}.Children(2).EdgeColor = [0.4 0.4 0.4];
    plt4.Color = [0 0 0];
    
    %   Annotation
    dim = [.6 .5 .3 .3];
    str = sprintf('p-value %.3f', modelCheck.PrStanD(i));
    ann1 = annotation('textbox',dim,'String',str,'FitBoxToText','on');
    ann1.LineStyle = 'none';
    
    %   Label
    ax{4}.XLabel.String = 'Standard deviation capacity factor (%)';
    ax{4}.YLabel.String = 'PMF value';
    ax{4}.Title.String = ['Farm name:' farmNames{i} ', Yearly'];

    
    %   Axis limits
    yLimCon = max(max(cell2mat(cellfun(@(x) x.YLim, ax, 'UniformOutput', false))));
    for j = 1:4
       ax{j}.YLim = [0, yLimCon];
       ax{j}.Children(1).YData = [0, yLimCon];
    end
    
    
   	%   Save figure
    figName{1} = [saveLoc 'ModelCheck_PrMin_' farmNames{i} '_Yearly'];
    figName{2} = [saveLoc 'ModelCheck_PrMax_' farmNames{i} '_Yearly'];
    figName{3} = [saveLoc 'ModelCheck_PrMean_' farmNames{i} '_Yearly'];
    figName{4} = [saveLoc 'ModelCheck_PrStanD_' farmNames{i} '_Yearly'];
    
    for j = 1:4
        saveas(fig{j}, [figName{j}, '.fig'])
        print(fig{j}, figName{j}, '-dpng', '-r800')  
    end


    
    close(fig{1})
    close(fig{2})
    close(fig{3})
    close(fig{4})
    
end
