function ProcessedData = Reduce_L1L2inac(ProcessedData)
ProcessedData.L1_TimeTicks = ProcessedData.L1_TimeTicks(250000:400000);
ProcessedData.L2_TimeTicks = ProcessedData.L2_TimeTicks(250000:400000);
ProcessedData.L1_Real = ProcessedData.L1_Real(250000:400000);
ProcessedData.L2_Real = ProcessedData.L2_Real(250000:400000);
end