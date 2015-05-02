function [X, Y] = Format_L1L2(ProcessedData)
%Assumption: L1 and L2 time ticks are the same
count = 0;
activityseconds = 0;
firstactivity = 0;
lastactivity = 0;
Y = cell([length(ProcessedData.L2_TimeTicks), 1]);
if( isfield(ProcessedData,'TaggingInfo') )
    for i = 1:length(ProcessedData.L2_TimeTicks)
        count = count + 1;
        tickfound = 0;
        for k = 1:35
            if ProcessedData.TaggingInfo{k, 3} <= ProcessedData.L1_TimeTicks(i) && ProcessedData.L1_TimeTicks(i) <= ProcessedData.TaggingInfo{k, 4}
                activityseconds = activityseconds + 1;
                tickfound = k;
            end
        end
        %L1_Real2(count) = ProcessedData.L1_Real(i);
        %L2_Real2(count) = ProcessedData.L2_Real(i);
        if tickfound == 0
                Y{count} = 'None';
        end
        if tickfound ~= 0
                Y(count) = ProcessedData.TaggingInfo{tickfound, 2};
                if firstactivity == 0
                    firstactivity = i;
                end
                lastactivity = i;
        end
    end
end
X = [ProcessedData.L1_Real, ProcessedData.L2_Real];
fprintf(1, 'Done formatting L1-L2 data for KNN.\n');
end