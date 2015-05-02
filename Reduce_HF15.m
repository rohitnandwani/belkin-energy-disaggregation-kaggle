function ProcessedData = Reduce_HF15(ProcessedData)
hfcount = 1;
for i = 1:length(ProcessedData.HF_TimeTicks)
    if mod(ceil(ProcessedData.HF_TimeTicks(i)), 15) == 0
        tempHF_TimeTicks(hfcount) = ProcessedData.HF_TimeTicks(i);
        tempHF(1:size(ProcessedData.HF, 1), hfcount) = ProcessedData.HF(:, i);
        hfcount = hfcount + 1;
    end
end
ProcessedData.HF_TimeTicks = tempHF_TimeTicks;
ProcessedData.HF = tempHF;
clear('tempL1_TimeTicks', 'tempHF')
end
