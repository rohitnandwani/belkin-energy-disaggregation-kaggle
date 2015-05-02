function ProcessedData = Reduce_HFinac(ProcessedData)
ProcessedData.HF_TimeTicks = ProcessedData.HF_TimeTicks(40000:60000);
ProcessedData.HF = ProcessedData.HF(:, 40000:60000);
end