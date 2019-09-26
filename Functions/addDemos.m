function d = addDemos(d,folder)
    sex = [];
    age = [];
    noticed = [];
    
    sheet = 'SubjectInfo';
    [a b allStuff] = xlsread(sheet);
    allStuff(cellfun(@all,cellfun(@isnan,allStuff,'uniformoutput',false))) = {'was_NaN'};
    sidcol = find(ismember(allStuff(1,:),{'SID'}));
    agecol = find(ismember(allStuff(1,:),{'Age'}));
    sexcol = find(ismember(allStuff(1,:),{'Sex'}));
    noticedcol = find(ismember(allStuff(1,:),{'Noticed manipulation'}));
    for si = 1:length(d)
        sid = d(si).id;
        ind = ismember(allStuff(:,sidcol),sid);
        
        d(si).demo.age = allStuff{ind,agecol};
        d(si).demo.sex = upper(allStuff{ind,sexcol});
        d(si).demo.noticed = upper(allStuff{ind,noticedcol});
        
        try
            sex = [sex; d(si).demo.sex];
        catch
            sex = [sex; nan];
        end
        
        try
            noticed = [noticed; d(si).demo.noticed(1)];
        catch
            noticed = [noticed; 'E'];
        end
        
        try
            age = [age; d(si).demo.age];
        catch
            age = [age; nan];
        end
        try
            age = [age; d(si).demo.age];
        catch
            age = [age; nan];
        end
    end
    
    fid = fopen(['All_Stats_' folder '.txt'],'a');
    fprintf(fid,['\n\t\tDemographics']);
    fprintf(fid,['\n\tAge -- Mean: ' num2str(nanmean(age)) '; Range: ' num2str(nanmin(age)) '-' num2str(nanmax(age)) '\n']);
    fprintf(fid,['\tFemales: ' num2str(nansum(sex=='F')) ';\tMales: ' num2str(nansum(sex=='M')) '\n\n']);
    fprintf(fid,['\tDid not notice: ' num2str(nansum(ismember(noticed,{'N'}))) ';\tNoticed: ' num2str(nansum(ismember(noticed,{'Y'}))) '\n\n']);
    fclose(fid);
end