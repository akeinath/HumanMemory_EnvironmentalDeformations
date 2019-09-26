function mkObjPlaceFields(data,folder)
    vals = repmat({[]},[4 3]);
    objLabels = unique(cat(1,data(1).familiar.item));
    for i = 1:length(data)
        if ~data(i).include
            continue
        end
        for lbi = 1:4
            tmp = cat(1,data(i).familiar.replacelocation)./16;
%             doVals = cat(1,data(i).familiar.trialtype)==lbi;
            doVals = ismember(cat(1,data(i).familiar.item),objLabels(lbi));
            vals{lbi,2} = [vals{lbi,2}; nanmean(tmp(doVals,:))];
            if isfield(data(i).avg_replace,'compress')
                tmp = cat(1,data(i).compress.replacelocation)./16;
%                 doVals = cat(1,data(i).compress.trialtype)==lbi;
                doVals = ismember(cat(1,data(i).compress.item),objLabels(lbi));
                vals{lbi,1} = [vals{lbi,1}; nanmean(tmp(doVals,:))];
            end
            if isfield(data(i).avg_replace,'stretch')
                tmp = cat(1,data(i).stretch.replacelocation)./16;
%                 doVals = cat(1,data(i).stretch.trialtype)==lbi;
                doVals = ismember(cat(1,data(i).stretch.item),objLabels(lbi));
                vals{lbi,3} = [vals{lbi,3}; nanmean(tmp(doVals,:))];
            end
        end
    end
    
    pixelSize = 2;
    rangeVals = [-100 200];
    maps = zeros(floor(rangeVals(2)./pixelSize)+1,floor(rangeVals(2)./pixelSize)+1,4,3);
    figure(4)
    set(gcf,'position',[50 50 500 600])
    for i = 1:4
        for j = 1:3
            tv = floor((vals{i,j}-rangeVals(1))./pixelSize)+1;
            for q = 1:length(tv(:,1))
                maps(tv(q,1),tv(q,2),i,j) = maps(tv(q,1),tv(q,2),i,j)+1;
            end
            maps(:,:,i,j) = maps(:,:,i,j)./length(tv(:,1));
            subplot(4,3,(i-1).*3+j)
            imagesc(imfilter(maps(:,:,i,j)',fspecial('gauss',[20 20],4)))
            title(objLabels{i})
            axis equal
            axis off
        end
    end
    
    outP = ['Plots/' folder '/Analyses/Obj_PlaceFields'];
    saveFig(gcf,outP,'tiff');
    outP = ['Plots/' folder '/Analyses/EPS/Obj_PlaceFields'];
    saveFig(gcf,outP,'eps');

end