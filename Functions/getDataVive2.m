function data = getDataVive2(folder)
    snames = dir(folder);
    snames = cat(1,{snames(:).name});
    snames(ismember(snames,[{'.'} {'..'}])) = [];
    itemList = [{'Cube'} {'Sphere'} {'Cylinder'} {'Capsule'}];
%     [a b subInfo] = xlsread('SubjectInfo',2);
    for si = snames
        fprintf(['\n\t\tLoading:  ' si{1}]);
        try 
            data(find(ismember(snames,si))) =load([folder '/' si{1} '/preloaded.mat']);
        	continue
        catch
            
        end
        data(find(ismember(snames,si))).id = si{1};
%         data(find(ismember(snames,si))).spsod = subInfo{end,ismember(subInfo(2,:),si(1))};
        data(find(ismember(snames,si))).block_order = [];
        data(find(ismember(snames,si))).familiar = [];
        data(find(ismember(snames,si))).compress = [];
        data(find(ismember(snames,si))).stretch = [];
        data(find(ismember(snames,si))).include = true;
            
        files = getFilePaths([folder '/' si{1}],'.txt');
        segmentedData = repmat({[]},[2 80]);
        for fi = 1:length(files)
            fid = fopen(files{fi});
            tmp = textread(files{fi},'%s');
            segment = {[]};
            parsed = [];
            i = 1;
            currSegment = 0;
            startNewSegment = true;
            while i < length(tmp)
                if ismember(tmp(i),{'Player'})
                    parsed = [parsed; {cat(2,tmp{i:i+7})}];
                    i = i+8;
                    
                    segment{currSegment} = [segment{currSegment}; parsed(end)];
                    startNewSegment = true;
                else
                    parsed = [parsed; tmp(i)];
                    i = i+1;
                    
                    if startNewSegment
                        startNewSegment = false;
                        currSegment = currSegment+1;
                        segment = [segment {[]}];
                    end
                    
                    segment{currSegment} = [segment{currSegment}; parsed(end)];
                end
            end
            segmentedData(fi,:) = segment(1:80);
        end
        fclose all;
        replaceTrials = segmentedData(:,18:4:end);
        
        
        %%% Familiar First
        for gi = 1:2
            for ti = 1:16
                ct = replaceTrials{gi,ti};
                path = [];
                for tri = 1:length(ct)
                    if length(ct{tri})>6 && (ismember({ct{tri}(1:6)},{'Player'}))
                        parinds = find(ct{tri}=='(');
                        commainds = find(ct{tri}==',');
                        x = str2num(ct{tri}(parinds(1)+1:commainds(2)-1));
                        y = str2num(ct{tri}(commainds(3)+1:commainds(4)-2));
                        hd = str2num(ct{tri}(parinds(2)+1:commainds(end)-2));
                        [theta b] = cart2pol(hd(1),hd(3));
                        path = [path; x y (theta./pi).*180];
                    end
                end
                
                centerOfRoom = [0.2 0.2];
                path(:,1:2) = bsxfun(@minus,path(:,1:2),centerOfRoom);

%                 plot(path(:,1),path(:,2))
%                 hold on



                if path(1,1)<-0.5
                    startlocation = {'west'};
                    trialtype = 1;
                elseif path(1,1)>0.5
                    startlocation = {'east'};
                    trialtype = 3;
                elseif path(1,2)>0.5
                    startlocation = {'north'};
                    trialtype = 2;
                elseif path(1,2)<-0.5
                    startlocation = {'south'};
                    trialtype = 4;
                end
                
                if gi==2
                    if ismember(replaceTrials{gi,1}{1},{'Compress,'})
                        if ismember(startlocation,{'west'})
                            path(:,1) = path(:,1) + 0.2;
                        elseif ismember(startlocation,{'east'})
                            path(:,1) = path(:,1) - 0.2;
                        end
                    elseif ismember(replaceTrials{gi,1}{1},{'Stretch,'})
                        if ismember(startlocation,{'west'})
                            path(:,1) = path(:,1) - 0.2;
                        elseif ismember(startlocation,{'east'})
                            path(:,1) = path(:,1) + 0.2;
                        end
                    end
                end
                
                objPres = false(1,4);
                for obji = 1:4
                    objPres(obji) = any(ismember(replaceTrials{gi,ti},[itemList{obji} ',']));
                end
                
                trialSlot = ((find(objPres)-1).*4)+trialtype;

                if ismember(replaceTrials{gi,1}{1},{'Compress,'})
                    if trialSlot==1
                        data(find(ismember(snames,si))).block_order = ...
                            [data(find(ismember(snames,si))).block_order {'compress'}];
                    end
                    data(find(ismember(snames,si))).compress(trialSlot).item = itemList(objPres);
                    data(find(ismember(snames,si))).compress(trialSlot).trialtype = trialtype;
                    data(find(ismember(snames,si))).compress(trialSlot).startlocation = startlocation;
                    data(find(ismember(snames,si))).compress(trialSlot).trialnum = ti;
                    data(find(ismember(snames,si))).compress(trialSlot).path = path;
                    data(find(ismember(snames,si))).compress(trialSlot).replacelocation = path(end,1:2);

                elseif ismember(replaceTrials{gi,1}{1},{'Stretch,'})
                    if trialSlot==1
                        data(find(ismember(snames,si))).block_order = ...
                            [data(find(ismember(snames,si))).block_order {'stretch'}];
                    end
                    data(find(ismember(snames,si))).stretch(trialSlot).item = itemList(objPres);
                    data(find(ismember(snames,si))).stretch(trialSlot).trialtype = trialtype;
                    data(find(ismember(snames,si))).stretch(trialSlot).startlocation = startlocation;
                    data(find(ismember(snames,si))).stretch(trialSlot).trialnum = ti;
                    data(find(ismember(snames,si))).stretch(trialSlot).path = path;
                    data(find(ismember(snames,si))).stretch(trialSlot).replacelocation = path(end,1:2);

                else
                    if trialSlot==1
                        data(find(ismember(snames,si))).block_order = {'familiar'};
                    end
                    data(find(ismember(snames,si))).familiar(trialSlot).item = itemList(objPres);
                    data(find(ismember(snames,si))).familiar(trialSlot).trialtype = trialtype;
                    data(find(ismember(snames,si))).familiar(trialSlot).startlocation = startlocation;
                    data(find(ismember(snames,si))).familiar(trialSlot).trialnum = ti;
                    data(find(ismember(snames,si))).familiar(trialSlot).path = path;
                    data(find(ismember(snames,si))).familiar(trialSlot).replacelocation = path(end,1:2);
                end
            end
        end
        tosave = data(find(ismember(snames,si)));
        save([folder '/' si{1} '/preloaded.mat'],'-struct','tosave','-v7.3');
    end
end

























