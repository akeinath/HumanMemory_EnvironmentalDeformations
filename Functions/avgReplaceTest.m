function avgReplaceTest(data,folder)
    close all
    vals = [{[]} {[]} {[]} {[]}];
    famAcc = [{[]} {[]}];
    spsod = [{[]} {[]}];
    famVar = [{[]} {[]}];
    for i = 1:length(data)
        if isfield(data(i),'include') && ~data(i).include
            continue
        end
        if isfield(data(i).avg_replace,'compress')
            vals{1} = cat(3,vals{1},data(i).avg_replace.compress);
            vals{2} = cat(3,vals{2},data(i).avg_replace.familiar);
            
            famAcc{1} = [famAcc{1}; data(i).familiar_accuracy];
%             famVar{1} = [famVar{1}; nanmean(data(i).replace_var.familiar)];
            spsod{1} = [spsod{1}; 105-data(i).spsod];
        end
        if isfield(data(i).avg_replace,'stretch')
            vals{3} = cat(3,vals{3},data(i).avg_replace.stretch);
            vals{4} = cat(3,vals{4},data(i).avg_replace.familiar);
            
            famAcc{2} = [famAcc{2}; data(i).familiar_accuracy];
%             famVar{2} = [famVar{2}; nanmean(data(i).replace_var.familiar)];
            spsod{2} = [spsod{2}; 105-data(i).spsod];
        end
    end


%     tmp = cellfun(@nanmedian,vals,'uniformoutput',false);
%     tmp = cat(1,tmp{:});
%     tmp = permute(tmp,[3 2 1]);
%     figure(1)
%     subplot(1,3,1:2)
%     mkWhisker([{tmp(:,1,1)} {tmp(:,1,3)}; ...
%         {tmp(:,2,1)} {tmp(:,2,3)}])
%     subplot(1,3,3)
%     mkWhisker([{tmp(:,1,1)-tmp(:,2,1)}; ...
%         {tmp(:,1,3)-tmp(:,2,3)}])
%     [p h stat] = signrank(tmp(:,1,1)-tmp(:,2,1));
%     [p h stat] = signrank(tmp(:,1,3)-tmp(:,2,3));
    
%     for i = 1:numel(vals)
%         vals{i} = cat(1,vals{i}(2:end,:,:),vals{i}(1:end,:,:));
%     end

    if ~ismember(folder,[{'Exp3'} {'Exp4'}])
        vals = cellfun(@rdivide,vals,[{16} {16} {16} {16}],'uniformoutput',false);
    end
    
    meanReplace = cellfun(@nanmean,vals,[{3} {3} {3} {3}],'uniformoutput',false);
    
    stdReplace = cellfun(@nanstd,vals,[{[]} {[]} {[]} {[]}],[{3} {3} {3} {3}],'uniformoutput',false);
    normalizer = sqrt(cellfun(@length,vals));
     
    %% Loc Replace Plot
    figure(1)
    set(gcf,'position',[50 50 600 200])
    for i = 1:4
        for obji = 1:4
            subplot(1,4,i)
            colors = hsv(4);
            hold on
            forRect = [meanReplace{i}(obji,:)-2.*stdReplace{i}(obji,:)./normalizer(i) ...
                4.*stdReplace{i}(obji,:)./normalizer(i)];
            h = rectangle('position',forRect,'curvature',[1 1]);
            set(h,'edgecolor',min((colors(obji,:)+.3),1),'facecolor',min((colors(obji,:)+.3),1))
            scatter(meanReplace{i}(obji,1),meanReplace{i}(obji,2),50,colors(obji,:).*0.7,'filled','marker','o');
            hold on
            set(gca,'xlim',[-300 300],'ylim',[-300 300])
            set(gca,'xlim',[-0.3 0.3],'ylim',[-0.3 0.3])
            axis equal
        end
    end
    outP = ['Plots/' folder '/Analyses/ReplaceLocationGraphic'];
    saveFig(gcf,outP,'tiff');
    outP = ['Plots/' folder '/Analyses/EPS/ReplaceLocationGraphic'];
    saveFig(gcf,outP,'eps');
    
    %% Gather vals
    plotable = repmat({[]},[8 2]);
    for i = [1 2 3 4]
        for j = 1:2
            for k = 1:2
                plotable{((i))+(j-1).*4,k} = -permute(vals{i}(j,k,:)-vals{i}(j+2,k,:),[3 1 2]); %./16
                if j==2
                    plotable{((i))+(j-1).*4,k} = -plotable{((i))+(j-1).*4,k};
                end
            end
        end
    end
    
    plotable(5:8,:) = fliplr(plotable(5:8,:)); 
    plotable = plotable([1 5 2 6 3 7 4 8],:);
    
    forSPSS = [ones(length(plotable{1}),1) cat(2,plotable{[3 4 1 2],1})];
    forSPSS = [forSPSS; 2.*ones(length(plotable{5}),1) cat(2,plotable{[7 8 5 6],1})];
    xlswrite(['ForSPSS_' folder],forSPSS);
    
    figure(2)
    set(gcf,'position',[50 50 400 200])
    subplot(1,3,1:2)
    toPlotHere = [plotable([2 1 6 5],1)]; %plotable([2 3 7 8],1) % 3 4 7 8
    mkWhisker(toPlotHere',[{'familiar'} {'deformed'}]);
    set(gca,'xlim',[0.5 4.5])
    if ismember(folder,[{'Exp3'} {'Exp4'}])
        set(gca,'ylim',[-0.6 0.4])
    else
        set(gca,'ylim',[-50 150])
    end
    plot(get(gca,'xlim'),[0 0],'color','k','linewidth',2,'linestyle','-')
    subplot(1,3,3)
%     tmp = (cat(2,plotable{1:2,1})-cat(2,plotable{4:5,1}));
    
    for i = 1:4
        
        %%% Normalize by familiar accuracy
%         plotable{i,1} = plotable{i,1}./famAcc{1};
%         plotable{i+4,1} = plotable{i+4,1}./famAcc{2};
        
%         %Normalize By UD
%         plotable{i,1} = plotable{i,1}./nanmean([plotable{3,1}; plotable{4,1}]);
%         plotable{i+4,1} = plotable{i+4,1}./nanmean([plotable{7,1}; plotable{8,1}]);
    end

    
    tmp = [{[plotable{1,1}-plotable{2,1}]} {[plotable{5,1}-plotable{6,1}]}];
    
    mkWhisker(tmp,[{'compress'} {'stretch'}]);
    set(gca,'xlim',[0.5 2.5])
    plot(get(gca,'xlim'),[0 0],'color','k','linewidth',2,'linestyle','-')
    if ismember(folder,[{'Exp3'} {'Exp4'}])
        set(gca,'ylim',[-0.4 0.4])
    else
        set(gca,'ylim',[-100 100])
    end
    outP = ['Plots/' folder '/Analyses/ShiftAnalysis'];
    saveFig(gcf,outP,[{'tiff'} {'pdf'}]);
    
    figure(16)
    set(gcf,'position',[50 50 500 200])
    subplot(1,2,1)
    A = [spsod{1}; spsod{2}];
    B = [-(plotable{1,1}-plotable{2,1}); plotable{5,1}-plotable{6,1}];
    scatter(A,B,25,'k','facecolor','k'); % -plotable{2,1}
    hold on
%     scatter(A(A>105-86),B(A>105-86),25,'k','facecolor','k');
    lsline
    subplot(1,2,2)
%     scatter(A,B./cat(1,famVar{:}),25,'k','facecolor','k');
    scatter([famAcc{1}; famAcc{2}],B,25,'k','facecolor','k') % -plotable{6,1}
    lsline
    outP = ['Plots/' folder '/Analyses/SPSOD_Corr'];
    saveFig(gcf,outP,'tiff');
    outP = ['Plots/' folder '/Analyses/EPS/SPSOD_Corr'];
    saveFig(gcf,outP,'eps');
    
    %%% Test
    fid = fopen(['All_Stats_' folder '.txt'],'a');
    
    fprintf(fid,'\nAverage Replace Location Tests:\n\n');
    [h p ci tstat] = ttest(tmp{1});
    fprintf(fid,['\tCompression T-Test:  \n\t\tt(' num2str(tstat.df) ')=' num2str(tstat.tstat) ...
        ',  p=' num2str(p) '\n\n']);
    
    [h p ci tstat] = ttest(tmp{2});
    fprintf(fid,['\tStretch T-Test:  \n\t\tt(' num2str(tstat.df) ')=' num2str(tstat.tstat) ...
        ',  p=' num2str(p) '\n\n']);
    
    [h p ci tstat] = ttest2(tmp{1},tmp{2});
    fprintf(fid,['\tDifference T-Test:  \n\t\tt(' num2str(tstat.df) ')=' num2str(tstat.tstat) ...
        ',  p=' num2str(p) '\n\n']);
    
    [h p ci tstat] = ttest2(plotable{2,1},plotable{6,1});
    fprintf(fid,['\tUndeformed Axis T-Test:  \n\t\tt(' num2str(tstat.df) ')=' num2str(tstat.tstat) ...
        ',  p=' num2str(p) '\n']);
    
    fprintf(fid,'\nAverage Replace Location Tests (Nonparametric):\n\n');
    [p h stat] = signrank(tmp{1});
    p = p./2;
    fprintf(fid,['\tCompression Signed-rank Test; one-tailed:  \n\t\tt(' num2str(stat.signedrank) ')=' num2str(stat.zval) ...
        ',  p=' num2str(p) '\n\n']);
    
    [p h stat] = signrank(tmp{2});
    p = p./2;
    fprintf(fid,['\tStretch Signed-rank Test; one-tailed:  \n\t\tt(' num2str(stat.signedrank) ')=' num2str(stat.zval) ...
        ',  p=' num2str(p) '\n\n']);
    
    [p h stat] = ranksum(tmp{1},tmp{2});
    fprintf(fid,['\tDifference Rank-sum Test:  \n\t\tt(' num2str(stat.ranksum) ')=' num2str(stat.zval) ...
        ',  p=' num2str(p) '\n\n']);
    
    [p h stat] = ranksum(plotable{2,1},plotable{6,1});
    fprintf(fid,['\tUndeformed Rank-sum Test:  \n\t\tt(' num2str(stat.ranksum) ')=' num2str(stat.zval) ...
        ',  p=' num2str(p) '\n']);
%     
%     
%     [r p] = corr([spsod{1}; spsod{2}],[-(plotable{1,1}-plotable{2,1}); plotable{5,1}-plotable{6,1}]);
%     fprintf(fid,['\n\tSPSOD vs. Shift Score (Pearson):  \n\t\tr=' num2str(r) ',  p=' num2str(p) '\n']);
    
    A = [spsod{1}; spsod{2}];
    B = [-(plotable{1,1}-plotable{2,1}); plotable{5,1}-plotable{6,1}];
    C = [famVar{1}; famVar{2}];
    D = [famAcc{1}; famAcc{2}];
    
    
    [r p] = corr(A(~isnan(B)),B(~isnan(B)));
    fprintf(fid,['\n\tSPSOD vs. Shift Score (Pearson):  \n\t\tr=' num2str(r) ',  p=' num2str(p) '\n']);
    
    
    
%     [r p] = corr([spsod{1}; spsod{2}],[-(plotable{1,1}-plotable{2,1}); plotable{5,1}-plotable{6,1}],'type','spearman');
%     fprintf(fid,['\n\tSPSOD vs. Shift Score (Spearman):  \n\t\tr=' num2str(r) ',  p=' num2str(p) '\n']);
    
%     [r p] = corr(A(A>(105-86)),B(A>(105-86)),'type','spearman');
%     fprintf(fid,['\n\tSPSOD vs. Shift Score (Spearman; sans outlier):  \n\t\tr=' num2str(r) ',  p=' num2str(p) '\n']);
    
%     [r p] = corr(famAcc{1},plotable{1,1}); % -plotable{2,1}
%     [r p] = corr(famAcc{2},plotable{5,1}); % -plotable{6,1}
%     [r p] = corr([famAcc{1}; famAcc{2}],[-(plotable{1,1}-plotable{2,1}); plotable{5,1}-plotable{6,1}])
    
    fclose(fid);
end

    
    
    
    
    
    
% %     
    
    
    
    
    
    
    