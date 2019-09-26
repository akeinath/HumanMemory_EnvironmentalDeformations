function d = addLBA(d)
    cutoff = 5.*16;
    for si = 1:length(d)
        assigned = cat(2,d(si).familiar.trialtype);
        for tri = 1:length(d(si).familiar)
            isB = [(d(si).familiar(tri).path(:,1))<-(880-cutoff) (d(si).familiar(tri).path(:,2))>(880-cutoff) ...
                (d(si).familiar(tri).path(:,1))>(880-cutoff) (d(si).familiar(tri).path(:,2))<-(880-cutoff) ...
                ];
            x = find(any(isB,2),1,'last');
            y = find(isB(x,:),1);
            if isempty(y)
                y = assigned(tri);
            end
            
%             if assigned(tri)==y
%                 d(si).familiar(tri).trialtype = 0;
%             else
                d(si).familiar(tri).trialtype = y;
%             end
        end
        
        if ~isempty(d(si).compress)
            assigned = cat(2,d(si).compress.trialtype);
            for tri = 1:length(d(si).compress)
                isB = [(d(si).compress(tri).path(:,1))<-(880.*0.5-cutoff) (d(si).compress(tri).path(:,2))>(880-cutoff) ...
                    (d(si).compress(tri).path(:,1))>(880.*0.5-cutoff) (d(si).compress(tri).path(:,2))<-(880-cutoff) ...
                    ];
                x = find(any(isB,2),1,'last');
                y = find(isB(x,:),1);
                if isempty(y)
                    y = assigned(tri);
                end
                
%                 if assigned(tri)==y
%                     d(si).compress(tri).trialtype = 0;
%                 else
                    d(si).compress(tri).trialtype = y;
%                 end
            end
        end
        
        if ~isempty(d(si).stretch)
            assigned = cat(2,d(si).stretch.trialtype);
            for tri = 1:length(d(si).stretch)
                isB = [(d(si).stretch(tri).path(:,1))<-(880.*1.5-cutoff) (d(si).stretch(tri).path(:,2))>(880-cutoff) ...
                    (d(si).stretch(tri).path(:,1))>(880.*1.5-cutoff) (d(si).stretch(tri).path(:,2))<-(880-cutoff) ...
                    ];
                x = find(any(isB,2),1,'last');
                y = find(isB(x,:),1);
                if isempty(y)
                    y = assigned(tri);
                end
                
%                 if assigned(tri)==y
%                     d(si).stretch(tri).trialtype = 0;
%                 else
                    d(si).stretch(tri).trialtype = y;
%                 end
            end
        end
    end
end