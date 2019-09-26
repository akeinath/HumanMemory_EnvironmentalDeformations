function data = plotVariability(data,folder)
    labels = [{'compress'} {'familiar'} {'stretch'}];
    variability = repmat({[]},[1 3]);
    for si = 1:length(data)
        for cond = data(si).block_order
            variability{ismember(labels,cond)} = [variability{ismember(labels,cond)}; ...
                {data(si).id} nanmean(data(si).replace_var.(cond{1}))];
        end
    end
    scalars = [116./2 116 116.*1.5];
    figure(1)
    set(gcf,'position',[50 50 500 200])
    isBad = [];
    for i = 1:3
        subplot(1,3,i)
        hist(cat(1,variability{i}{:,2})./scalars(i))
        
        % toss subs who have average dist to replace mean greater than 25%
        % of the deformed axis of the environment
        
        unused = [cat(1,variability{i}{:,2})./scalars(i)]>0.5;
        isBad = [isBad; variability{i}(unused,1)];
    end
    isBad = unique(isBad);
    
    for i = 1:length(data)
        if ismember(data(si).id,isBad)
            data(si).include = false;
        else
            data(si).include = true;
        end
    end
end