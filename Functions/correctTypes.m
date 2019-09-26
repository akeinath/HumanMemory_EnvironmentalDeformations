function d = correctTypes(d)
    stuff = [];
    labels = [1 2 3 4];
    for si = 1:length(d)
        for fields = [{'familiar'} {'stretch'} {'compress'}];
            if ~isempty(d(si).(fields{1}))
                assigned = cat(1,d(si).(fields{1}).trialtype);
                for tri = 1:length(d(si).(fields{1}))
                    d(si).(fields{1})(tri).trialtype = labels(d(si).(fields{1})(tri).trialtype);
                end
                stuff = [stuff; cat(2,d(si).(fields{1}).trialtype)];
            end
        end
    end
end