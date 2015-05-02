function [X, Y] = Format_HF(ProcessedData)
matlabpool open 2
count = 0;
%XYinit = length(ProcessedData.HF_TimeTicks) * 4096;
%X = zeros([XYinit, 2]);
%Y = cell([XYinit, 1]);
X = [];
Y = {};
%X = gpuArray(X);
%Y = gpuArray(Y);
parfor i = 1:length(ProcessedData.HF_TimeTicks)
    tickfound = 0;
    for k = 1: 35
        if ProcessedData.TaggingInfo{k, 3} <= ProcessedData.HF_TimeTicks(i) && ProcessedData.HF_TimeTicks(i) <= ProcessedData.TaggingInfo{k, 4}
            tickfound = k;
        end
    end
    %{
    for j = 1:4096
        count = count + 1;
        X(count, 1) = j;
        X(count, 2) = ProcessedData.HF(j, i);
        if tickfound == 0
            Y{count} = 'None';
        end
        if tickfound ~= 0
            Y(count) = ProcessedData.TaggingInfo{tickfound, 2};
        end
    end
    %}
    Phase = (1:4096)';
    temp = [Phase, double(ProcessedData.HF(:, i))];
    X = [X; temp];
    
    Device = cell([4096, 1]);
    if tickfound == 0
        [Device{:}] = deal('None');
        Y = [Y; Device];
    end
    if tickfound ~= 0
        [Device(:)] = deal(ProcessedData.TaggingInfo{tickfound, 2});
        Y = [Y; Device];
    end
    %Append(X, [Phase, ProcessedData.HF(:, i)]);
    
    
end
matlabpool close
X = transpose(X);
fprintf(1, 'Done formatting HF data for KNN.\n');
end