function plotPaths(data,folder)
    colors = hsv(4);
    for si = 1:length(data)
        figure
        set(gcf,'position',[50 50 1050 300])
        ind = 0;
        for cond = [{'familiar'} {'compress'} {'stretch'}];
            if isempty(data(si).(cond{1}))
                continue
            end
            
            ind = ind+1;
            
            subplot(1,3,ind)
            hold on
            if ismember(folder,[{'Exp3'} {'Exp4'}])
                for ti = 1:length(data(si).(cond{1}))
                    plot(data(si).(cond{1})(ti).path(:,1), ...
                        data(si).(cond{1})(ti).path(:,2),'color',...
                        colors(data(si).(cond{1})(ti).trialtype,:).*0.8,'linewidth',1.5);
                end
            else
                for ti = 1:length(data(si).(cond{1}))
                    plot(data(si).(cond{1})(ti).path(:,1)./16, ...
                        data(si).(cond{1})(ti).path(:,2)./16,'color',...
                        colors(data(si).(cond{1})(ti).trialtype,:).*0.8,'linewidth',1.5);
                end
            end
            set(gca,'xlim',[-1.5 1.5],'ylim',[-1.5 1.5])
            if ~ismember(folder,[{'Exp3'} {'Exp4'}])
                set(gca,'xlim',[-100 100],'ylim',[-100 100])
            end
            axis equal
%             axis square
        end
        outP = ['Plots/' folder '/IndividualPaths/' data(si).id];
        saveFig(gcf,outP,[{'tiff'} {'pdf'}]); close all;
    end
end