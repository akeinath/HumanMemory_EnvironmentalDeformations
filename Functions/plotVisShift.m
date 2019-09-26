function data = plotVisShift(data,folder)
    colors = hsv(4);
    for si = 1:length(data)
        figure
        set(gcf,'position',[50 50 1050 300])
        ind = 0;
        for cond = [{'familiar'} {'compress'}  {'stretch'}]; %{'familiar'}
            if isempty(data(si).(cond{1}))
                continue
            end
            
            ind = ind+1;
            subplot(1,3,ind)
            title(cond{1})
            hold on
            
            
            allRep = cat(1,data(si).(cond{1})(:).replacelocation);
            
%             averages = [];
%             variability = [];
%             ishift = [];
%             for item = 1:4
%                 doItem = allRep((item-1).*4+1:item.*4,:);
%                 a = doItem(cat(1,data(si).(cond{1})((item-1).*4+1:item.*4).trialtype)==1,:);
%                 b = doItem(cat(1,data(si).(cond{1})((item-1).*4+1:item.*4).trialtype)==2,:);
%                 c = doItem(cat(1,data(si).(cond{1})((item-1).*4+1:item.*4).trialtype)==3,:);
%                 d = doItem(cat(1,data(si).(cond{1})((item-1).*4+1:item.*4).trialtype)==4,:);
%                 averages(item,:) = [c(1)-a(1) d(2)-b(2)];
%             end

            for i = 1:4
                allRep((i-1).*4+1:i.*4,:) = bsxfun(@minus,allRep((i-1).*4+1:i.*4,:),...
                    nanmedian(allRep((i-1).*4+1:i.*4,:)));
            end
            colormap('hsv')
            scatter(allRep(:,1),allRep(:,2),15,colors(cat(1,data(si).(cond{1})(:).trialtype),:).*1,'filled');
            hold on
            averages = [];
            variability = [];
            for i = 1:4
%                 averages(i,:) = nanmedian(allRep([1 5 9 13]+(i-1),:));
%                 variability(i,:) = nanmean(sqrt(sum((bsxfun(@minus,allRep([1 5 9 13]+(i-1),:),averages(i,:))).^2,2))./16);
                averages(i,:) = nanmedian(allRep(cat(1,data(si).(cond{1})(:).trialtype)==i,:),1);
                variability(i,:) = nanmean(sqrt(sum((bsxfun(@minus,allRep(cat(data(si).(cond{1})(:).trialtype,1)==i,:),averages(i,:))).^2,2))./16);
            end
            scatter(averages(:,1),averages(:,2),50,colors.*0.8,'filled','marker','s');
            set(gca,'xlim',[-0.4 0.4],'ylim',[-0.4 0.4])
            if any(abs(allRep(:))>10)
                set(gca,'xlim',[-700 700],'ylim',[-700 700])
            end
            data(si).avg_replace.(cond{1}) = averages;
            data(si).replace_var.(cond{1}) = variability;
            data(si).avg_replace.(cond{1}) = averages;
        end
        outP = ['Plots/' folder '/VisualizedShift/' data(si).id];
        saveFig(gcf,outP,'tiff'); close all;
    end
end