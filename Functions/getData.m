function out = getData(folder,reload)
    if nargin<2 || isempty(reload)
        reload = false;
    end
    
%     [a b xdat] = xlsread('SubjectInfo',2);
%     spsod = xdat([21 37],:);
    
    subs = dir([folder '/*']);
    subs = cat(2,{subs.name});
    subs(ismember(subs,[{'.'} {'..'}])) = [];
    
    for si = 1:length(subs)
        
        fprintf(['\tLoading Subject: Subject ' num2str(subs{si}) '...  ']);
        checkP = [folder '/' subs{si} '/preloaded.mat'];
        if exist(checkP)==2 && ~reload
            clear blah;
            blah = load(checkP);
%             blah.spsod = spsod{2,ismember(spsod(1,:),blah.id)};
%             out(si) = blah;
%             clear blah
            out(si) = blah;
            fprintf('Preloaded\n')
            continue
        end

        tic
        out(si).id = subs{si};
        files = dir([folder '/' subs{si} '/*.txt']);
        
        for i = 1:length(files)
            [Y, M, D, H(i), MN(i), S] = datevec(files(i).date);
        end
        
        ttimes = H.*60+MN;
        [orderedTimes] = sort(ttimes,'ascend');
        
        files = cat(2,{files.name});
        
        out(si).familiar = [];
        out(si).compress = [];
        out(si).stretch = [];
        out(si).nofog = [];
        
        for fi = 1:length(files)
            fid = fopen([folder '/' subs{si} '/' files{fi}]);
            a = textscan(fid,'%s');
            td = a{1};
            fclose(fid);
            blockdata = parsetextdata(td);
            
            
            if files{fi}(find(files{fi}=='_',1,'first')+1)=='c'
                out(si).compress = blockdata;
                tmpOrder(find(ttimes(fi)==orderedTimes)) = {'compress'};
                
            elseif files{fi}(find(files{fi}=='_',1,'first')+1)=='s'
                out(si).stretch = blockdata;
                tmpOrder(find(ttimes(fi)==orderedTimes)) = {'stretch'};
                
            else
                if files{fi}(find(files{fi}=='_',1,'last')+1)=='n'
                    out(si).nofog = blockdata;
                    tmpOrder(find(ttimes(fi)==orderedTimes)) = {'nofog'};
                else
                    out(si).familiar = blockdata;
                    tmpOrder(find(ttimes(fi)==orderedTimes)) = {'familiar'};
                end
            end
        end
        out(si).block_order = tmpOrder;
        out(si).spsod = spsod{2,ismember(spsod(1,:),out(si).id)};
        
        subData = out(si);
        outP = [folder '/' subs{si} '/preloaded'];
        save(outP,'-struct','subData','-v7.3');
        
        toc
    end
end