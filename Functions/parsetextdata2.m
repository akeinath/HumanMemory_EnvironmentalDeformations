function out = parsetextdata(d)
    parsed = [];

    names = [{'Cake'} {'Lamp'} {'Radiator'} {'OilDrum'}];
    labels = [];
    for i = 1:length(names)
        for j = 1:4
            labels = [labels; {['Unknowncommand:' names{i} 'Replaced' num2str(j)]} names(i) {j}];
        end
    end
    labels{ismember(labels(:,1),{'Unknowncommand:OilDrumReplaced4'}),1} = 'Unknowncommand:OilDrumlReplaced4';
    
    [a b coord] = xlsread('Exp2_Coordinates');
    
    isMeasurement = ismember(d,{'setpos'});
    ind = find(isMeasurement,1,'first');
    while any(isMeasurement)
        parsed = [parsed; d(ind:ind+6)'];
        
        isMeasurement(ind) = false;
        if ind+7>length(isMeasurement)
            parsed = [parsed; {['endOfFile_' cat(2,d{ind+7:length(d)})]} repmat({[]},[1 6])];
            break
        end
        if ~isMeasurement(ind+7)
            stop = find(isMeasurement,1,'first')-1;
            if isempty(stop)
                stop  = length(d);
            end
            parsed = [parsed; {cat(2,d{ind+7:stop})} repmat({[]},[1 6])];
        end
        ind = find(isMeasurement,1,'first');
    end
    
    parsed(cellfun(@isempty,parsed(:,1)),:) = [];
    parsed(~ismember(parsed(:,1),[labels(:,1); {'setpos'}]),:) = [];
    
    order = [];
    for i = 1:length(labels(:,1))
        order(i) = find(ismember(parsed(:,1),labels(i,1)),1,'first')-1;
    end
    [a order] = sort(order,'ascend');
    
    %%% Gather trajectories associated with each label
    out = struct; % Item TrialNum Order Path FinalLoc
    sls = [{'west'} {'north'} {'east'} {'south'}];
    for i = 1:length(labels(:,1))
        stop = find(ismember(parsed(:,1),labels(i,1)),1,'last')-1;
        start = find(cellfun(@isempty,parsed(1:stop,2)),1,'last')+1;
        if isempty(start)
            start = 1;
        end
        
        clip = parsed(start:stop,:);
        clip = cellfun(@str2num,clip,'uniformoutput',false);
        if any(cellfun(@isempty,clip(:,6)))
            clip{cellfun(@isempty,clip(:,6)),6} = clip{circshift(cellfun(@isempty,clip(:,6)),[1 0]),6};
        end
        path = [cat(1,clip{:,2}) cat(1,clip{:,3}) cat(1,clip{:,6})];
        
        teleport = find(sqrt(diff(path(:,1)).^2 + diff(path(:,2)).^2)>100,2,'last')+1;
        vec = bsxfun(@plus,path(teleport(end):end,1:2),-path(teleport(end),1:2));
        
        rMat = [cosd(-path(teleport(end)-1,3)) -sind(-path(teleport(end)-1,3)); ...
            sind(-path(teleport(end)-1,3)) cosd(-path(teleport(end)-1,3))];
        path(teleport(end):end,:) = [repmat(path(teleport(end)-1,1:2),[length(vec(:,1)) 1])+(vec*rMat) ...
            path(teleport(end)-1,3)+(path(teleport(end):end,3)-180)];
        
        if length(teleport)>1
            path = path(teleport(1):end,:);
        end
        
        isCoord = [false; ismember(coord(2:end,1),labels(i,2)) & ...
            cellfun(@eq,coord(2:end,2),repmat(labels(i,3),[length(coord(2:end,2)) 1]))];
        
        path(:,[1 2]) = [path(:,1)-coord{isCoord,3} path(:,2)-coord{isCoord,4}];
        
        out(i).item = labels(i,2);
        out(i).trialtype = labels{i,3};
        out(i).startlocation = sls(labels{i,3});
        out(i).trialnum = find(order==i);
        out(i).path = path;
        out(i).replacelocation = [path(end,1) path(end,2)];
    end
end