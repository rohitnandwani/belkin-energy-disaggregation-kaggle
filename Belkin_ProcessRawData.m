function [ProcessedData] =  Belkin_ProcessRawData(Buffer)
% PROCESSRAWBELKINDATA  Takes raw Current and Voltage harmonics to yield
% Real, Reactive and Apparent Power along with Power Factor for each phase
% of a home's power usage.

% ------
% Compute Power
% Calculate the real and imaginary power at each harmonic content

% Phase 1
L1_P = Buffer.LF1V .* conj(Buffer.LF1I);
% Phase 2
L2_P = Buffer.LF2V .* conj(Buffer.LF2I);

% Compute net Complex power
L1_ComplexPower = sum(L1_P, 2);
L2_ComplexPower = sum(L2_P, 2);

% Real, Reactive, Apparent powers
% Phase-1
ProcessedData.L1_Real = real(L1_ComplexPower);
ProcessedData.L1_Imag = imag(L1_ComplexPower);
ProcessedData.L1_App = abs(L1_ComplexPower);

%Phase-2
ProcessedData.L2_Real = real(L2_ComplexPower);
ProcessedData.L2_Imag = imag(L2_ComplexPower);
ProcessedData.L2_App = abs(L2_ComplexPower);

% Compute Power Factor, we only consider the first 60Hz component
ProcessedData.L1_Pf = cos(angle(L1_P(:,1)));
ProcessedData.L2_Pf = cos(angle(L2_P(:,1)));

% Copy Time ticks to our processed structure
ProcessedData.L1_TimeTicks = Buffer.TimeTicks1;
ProcessedData.L2_TimeTicks = Buffer.TimeTicks2;

% -------
% Move over HF Noise and Device label (tagging) data to our final structure as well
ProcessedData.HF = Buffer.HF;
ProcessedData.HF_TimeTicks = Buffer.TimeTicksHF;
% Copy Labels/TaggingInfo id they exist
if( isfield(Buffer,'TaggingInfo') )
    ProcessedData.TaggingInfo = Buffer.TaggingInfo;
end

% --------
end