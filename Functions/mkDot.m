function mkDot(d,labels)
    if nargin<=4
%         colors = [.4 .4 .8; .3 .3 .8; .2 .2 .8; .1 .1 .8];
%         colors = [[255 153 0]./255; [255 75 25]./255; .2 .2 .8; .1 .1 .8];
        colors = ones(30,3).*0.6;
    end
    
    markers = 'ooooooooooooooooooooo';
    
    if ~iscell(d)
        tmp = [];
        for i = 1:length(d(1,:))
            tmp = [tmp {d(:,i)}];
        end
        d = tmp;
    end
    
    groups = length(d(:,1));
    jitterAmount = 0.25;
    jitter = (([1:groups]-1)./(groups-1)).*jitterAmount - jitterAmount./2;
    jitter(isnan(jitter)) = 0;
    meanLineSize = 0.5.*jitterAmount./groups;
    
    for i = 1:length(d(1,:))
        for j = 1:length(d(:,1))
            if isempty(d{j,i})
                continue
            end

                scalar = sqrt(abs([d{j,i}-nanmean(d{j,i})]));
                scalar = (1./scalar).*0.00;
                plot(i+jitter(j)+(((randn(length(d{j,i}),1)<0.5).*2)-1).*scalar+ ...
                    randn(length(d{j,i}),1).*0.05,d{j,i},'linestyle','none','marker',markers(j),'markerfacecolor','none',...
                    'markeredgecolor',colors(j,:),'markersize',7,'linewidth',1)
                hold on
                
                sem = (nanstd(d{j,i})./sqrt(sum(~isnan(d{j,i}))));

                plot([i-jitterAmount i+jitterAmount],...
                    [nanmean(d{j,i})+sem nanmean(d{j,i})+sem],'color','k',...
                    'linestyle','-','linewidth',2);
                
                plot([i-jitterAmount i+jitterAmount],...
                    [nanmean(d{j,i})-sem nanmean(d{j,i})-sem],'color','k',...
                    'linestyle','-','linewidth',2);

                plot([i i],...
                    [nanmean(d{j,i})-sem nanmean(d{j,i})+sem],'color','k',...
                    'linestyle','-','linewidth',2);
                
                plot([i],[nanmean(d{j,i})],'color','k','marker',markers(j),'markerfacecolor','k',...
                    'markeredgecolor','k','markersize',8,'linewidth',1)
                
%                 seg = 2.5;
% %                 range = [nanmin(d{j,i})-seg:seg:nanmax(d{j,i})+2.*seg];
%                 range = [-30:seg:60];
%                 hi = histc(d{j,i},range);
%                 hi = boxcar(hi',10);
%                 hi = (hi./max(hi)).*jitterAmount.*1.5;
%                 plot(i+jitter(j)+hi',range','color','k','linewidth',2);
%                 plot(i+jitter(j)-hi',range','color','k','linewidth',2);
        end        
    end
%     set(gcf,'position',[50 50 100+50.*length(d(1,:)) 300])
end