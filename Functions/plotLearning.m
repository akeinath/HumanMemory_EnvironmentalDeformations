function data = plotLearning(data,folder)
    [Vals b objectOffsets] = xlsread([folder '_ObjectOffsets']);
    
    doConditions = [{'familiar'}];
    allAcc = repmat({[]},[4 length(doConditions)]);
    allRT = repmat({[]},[4 length(doConditions)]);
%     figure(1)
    for si = 1:length(data)
        if isfield(data(si),'include')&&~data(si).include
            continue
        end
        for cond = doConditions
            trialItems = cat(1,data(si).familiar.item);
            items = unique(trialItems);
            condAcc = nan(4,length(items));
            condRT = nan(4,length(items));
            trialNum = cat(1,data(si).familiar.trialnum);
            for i = 1:length(items)
                trials = sort(trialNum(ismember(trialItems,items(i))),'ascend');
                for j = 1:4
                    dd = data(si).familiar(trialNum==trials(j)).replacelocation - ...
                        cat(2,objectOffsets{ismember(objectOffsets(:,1),items(i)),2:3});
                    if ismember(folder,[{'Exp3'} {'Exp4'}])
                        condAcc(i,j) = sqrt(sum(dd.^2));
                    else
                        condAcc(i,j) = sqrt(sum(dd.^2))./16;
                    end
                    condRT(i,j) = length(data(si).familiar(trialNum==trials(j)).path(:,1)).*0.1;
                end
            end
            for j = 1:4
                allAcc{j,ismember(cond,doConditions)} = [allAcc{j,ismember(cond,doConditions)}; ...
                    nanmean(condAcc(:,j),1)];
                allRT{j,ismember(cond,doConditions)} = [allRT{j,ismember(cond,doConditions)}; ...
                    nanmedian(condRT(:,j),1)];
            end
        end
    end
    
%     if ~isfield(data,'include')
%         tmp = cat(2,allAcc{:});
%         aacc = nanmean(tmp(:,4),2);
%         [aacc medSplit] = sort(aacc);
%         for si = 1:length(data)
% %             data(si).include = ~any(tmp(si,4)>51.3725);
% 
% %             data(si).include = ~any(nanmean(tmp(si,:),2)>51.3725);
% %             data(si).include = find(si==medSplit)>length(medSplit)./2;
%         end
%     end
    
%     mkGraph(allAcc,1:4);
    accuracy = nanmean(cat(2,allAcc{:}),2);
    rt = nanmedian(cat(2,allRT{:}),2);
    for si = 1:length(accuracy)
        data(si).familiar_accuracy = accuracy(si); % 4 subs tossed for accuracy in exp1
        data(si).familiar_rt = rt(si);
    end
    group = cat(1,data.block_order);
    
    if isfield(data(si),'include')
        group = group(cat(1,data.include),:);
    end
    
    figure(9)
    set(gcf,'position',[50 50 300 200])
    subplot(1,2,1)
    mkGraph([{accuracy(ismember(group(:,end),{'compress'}))} ...
        {accuracy(ismember(group(:,end),{'stretch'}))}],[{'compress'} {'stretch'}]);
%     mkDot([{accuracy(ismember(group(:,2),{'compress'}))} ...
%         {accuracy(ismember(group(:,2),{'stretch'}))}],[{'compress'} {'stretch'}],true,false,false);
    if ismember(folder,[{'Exp3'} {'Exp4'}])
        ylabel('Distance error (m)')
    else
        ylabel('Distance error (v.u.)')
        set(gca,'ylim',[0 50])
    end
    subplot(1,2,2)
    mkGraph([{rt(ismember(group(:,end),{'compress'}))} ...
        {rt(ismember(group(:,end),{'stretch'}))}],[{'compress'} {'stretch'}]);
%     mkDot([{rt(ismember(group(:,2),{'compress'}))} ...
%         {rt(ismember(group(:,2),{'stretch'}))}],[{'compress'} {'stretch'}],true,false,false);
    ylabel('Reaction Time (sec)')
    outP = ['Plots/' folder '/Analyses/FamiliarBlockLearning'];
    saveFig(gcf,outP,'tiff');
    outP = ['Plots/' folder '/Analyses/EPS/FamiliarBlockLearning'];
    saveFig(gcf,outP,'eps');
    
    badSubs = [];
    if isfield(data(si),'include')
        badSubs = cat(2,data(~cat(1,data.include)).id);
    end
    
    fid = fopen(['All_Stats_' folder '.txt'],'a');
    
    fprintf(fid,'\nFamiliar Block Tests:\n\n');
    
    [h p ci tstat] = ttest2(accuracy(ismember(group(:,end),{'compress'})),accuracy(ismember(group(:,end),{'stretch'})));
    fprintf(fid,['\tCompress vs. Stretch Familiar Accuracy T-Test:  \n\t\tt(' num2str(tstat.df) ')=' num2str(tstat.tstat) ...
        ',  p=' num2str(p) '\n\t\tCompress = ' num2str(nanmean(accuracy(ismember(group(:,end),{'compress'})))) '+/-' ...
        num2str(nanstd(accuracy(ismember(group(:,end),{'compress'})))./sqrt(length(accuracy(ismember(group(:,end),{'compress'}))))) ...
        '\n\t\tStretch = ' num2str(nanmean(accuracy(ismember(group(:,end),{'stretch'})))) '+/-' ...
        num2str(nanstd(accuracy(ismember(group(:,end),{'stretch'})))./sqrt(length(accuracy(ismember(group(:,end),{'stretch'}))))) '\n']);
    
    [h p ci tstat] = ttest2(rt(ismember(group(:,end),{'compress'})),rt(ismember(group(:,end),{'stretch'})));
    fprintf(fid,['\n\tCompress vs. Stretch Familiar RT T-Test:  \n\t\tt(' num2str(tstat.df) ')=' num2str(tstat.tstat) ...
        ',  p=' num2str(p) '\n\t\tCompress = ' num2str(nanmean(rt(ismember(group(:,end),{'compress'})))) '+/-' ...
        num2str(nanstd(rt(ismember(group(:,end),{'compress'})))./sqrt(length(rt(ismember(group(:,end),{'compress'}))))) ...
        '\n\t\tStretch = ' num2str(nanmean(rt(ismember(group(:,end),{'stretch'})))) '+/-' ...
        num2str(nanstd(rt(ismember(group(:,end),{'stretch'})))./sqrt(length(rt(ismember(group(:,end),{'stretch'}))))) '\n']);
    
    fprintf(fid,'\nFamiliar Block Nonparametric Tests:\n\n');
    
    [p h stat] = ranksum(accuracy(ismember(group(:,end),{'compress'})),accuracy(ismember(group(:,end),{'stretch'})));
    fprintf(fid,['\tCompress vs. Stretch Familiar Accuracy T-Test:  \n\t\tt(' num2str(stat.ranksum) ')=' num2str(stat.zval) ...
        ',  p=' num2str(p) '\n\t\tCompress = ' num2str(nanmean(accuracy(ismember(group(:,end),{'compress'})))) '+/-' ...
        num2str(nanstd(accuracy(ismember(group(:,end),{'compress'})))./sqrt(length(accuracy(ismember(group(:,end),{'compress'}))))) ...
        '\n\t\tStretch = ' num2str(nanmean(accuracy(ismember(group(:,end),{'stretch'})))) '+/-' ...
        num2str(nanstd(accuracy(ismember(group(:,end),{'stretch'})))./sqrt(length(accuracy(ismember(group(:,end),{'stretch'}))))) '\n']);
    
    [p h stat] = ranksum(rt(ismember(group(:,end),{'compress'})),rt(ismember(group(:,end),{'stretch'})));
    fprintf(fid,['\n\tCompress vs. Stretch Familiar RT T-Test:  \n\t\tt(' num2str(stat.ranksum) ')=' num2str(stat.zval) ...
        ',  p=' num2str(p) '\n\t\tCompress = ' num2str(nanmean(rt(ismember(group(:,end),{'compress'})))) '+/-' ...
        num2str(nanstd(rt(ismember(group(:,end),{'compress'})))./sqrt(length(rt(ismember(group(:,end),{'compress'}))))) ...
        '\n\t\tStretch = ' num2str(nanmean(rt(ismember(group(:,end),{'stretch'})))) '+/-' ...
        num2str(nanstd(rt(ismember(group(:,end),{'stretch'})))./sqrt(length(rt(ismember(group(:,end),{'stretch'}))))) '\n']);
    
%     tmp = sum(~cat(1,data.include));
%     fprintf(fid,['\n\tNumber of Excluded Subjects:  ' num2str(tmp) ' of ' num2str(length(data)) '\n']);
    
    
    fclose(fid);
end