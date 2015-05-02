function [X, Y] = Reduce_Format(ProcessedData)
%% Reduce/Resample data

%Reduce L1-L2 inactivity data
ProcessedData = Reduce_L1L2inac(ProcessedData);

%Reduce HF inactivity data
ProcessedData = Reduce_HFinac(ProcessedData);

%Reduce L1-L2 data size to common seconds to HF
%ProcessedData = Reduce_Common(ProcessedData);

%Reduce L1-L2 data considering every 15th second
%ProcessedData = Reduce_L1215(ProcessedData);

%Reduce HF data considering every 15th second
ProcessedData = Reduce_HF15(ProcessedData);

%% Format data for KNN

%HF data
[X, Y] = Format_HF(ProcessedData);

%L1L2 data
%[X, Y] = Format_L1L2(ProcessedData);

end