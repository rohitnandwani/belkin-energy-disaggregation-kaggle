function ProcessedData = Reduce_Common(ProcessedData)
hfcount1 = 1;
hfcount2 = 1;
for i = 1:length(ProcessedData.L2_TimeTicks)
    if ceil(ProcessedData.L1_TimeTicks(i)) == ceil(ProcessedData.HF_TimeTicks(hfcount1))
        tempL1_TimeTicks(hfcount1) = ProcessedData.L1_TimeTicks(i);
        tempL1_Real(hfcount1) = ProcessedData.L1_Real(i);
        hfcount1 = hfcount1 + 1;
    end
    if ceil(ProcessedData.L2_TimeTicks(i)) == ceil(ProcessedData.HF_TimeTicks(hfcount2))
        tempL2_TimeTicks(hfcount2) = ProcessedData.L2_TimeTicks(i);
        tempL2_Real(hfcount2) = ProcessedData.L2_Real(i);
        hfcount2 = hfcount2 + 1;
    end
end
ProcessedData.L1_TimeTicks = tempL1_TimeTicks;
ProcessedData.L2_TimeTicks = tempL2_TimeTicks;
ProcessedData.L1_Real = tempL1_Real;
ProcessedData.L2_Real = tempL2_Real;
clear('tempL1_TimeTicks', 'tempL2_TimeTicks', 'tempL1_Real', 'tempL2_Real')
end