function [figure_handle] = Belkin_PlotData(ProcessedData, hasLabels, varargin)
% Belkin_PlotData   Plots various measurement in a single figure with
% linked axis for quickly looking at the data. Plot, real, reactive,
% apparent and power factor for each phase. Also plots the High Frequency
% Continuous EMI (HF).
% ProcessedData = input data structure that Belkin_ProcessRawData returns
% hasLabels = bool. True if TaggingInfo exists inside of ProcessedData
% that encodes device labels and ON/OFF timestamps. Set this TRUE for
% Training datasets as those come with labels/tagging information.
% Next two parameters are optional that indicate start and stop timestamps
% to limit the plot to data between those.
% Belkin_PlotData(ProcessedData, true, start_timestamp, stop_timestamp)
% Returns handle to the figure.

if (nargin ~=2 && nargin ~= 4)
    fprintf(1, 'Incorrect number of optional arguments. Expected 2 or 4, given %d\n', nargin);
    h = 0;
    return;
elseif (nargin == 4)
    start_TS = varargin{1};
    stop_TS = varargin{2};
    
    % Check if time valid for this data
    check = max(int64(ProcessedData.L1_TimeTicks(:,1))) >= stop_TS ...
                && min(int64(ProcessedData.L1_TimeTicks(:,1))) <= start_TS;
    if( ~check )
        fprintf(1, 'Start or Stop time out of bounds\n');
        return;
    end
    
    %Truncate all data to be withing start and stop timestamps
    % Find start and top indexes for L1 data. Since there are 6 values per
    % second, we use min/max.
    start_idx_L1 = min(find(int64(ProcessedData.L1_TimeTicks(:,1)) == int64(start_TS) ));
    stop_idx_L1 = max(find(int64(ProcessedData.L1_TimeTicks(:,1)) == int64(stop_TS) ));
    %Find indexes for L2
    start_idx_L2 = min(find(int64(ProcessedData.L2_TimeTicks(:,1)) == int64(start_TS) ));
    stop_idx_L2 = max(find(int64(ProcessedData.L2_TimeTicks(:,1)) == int64(stop_TS) ));
    % HF Indexes
    start_idx_HF = min(find(int64(ProcessedData.HF_TimeTicks(:,1)) == int64(start_TS) ));
    stop_idx_HF = max(find(int64(ProcessedData.HF_TimeTicks(:,1)) == int64(stop_TS) ));
    
    %Truncate data
    ProcessedData.HF = ProcessedData.HF(:, start_idx_HF:stop_idx_HF);
    ProcessedData.HF_TimeTicks = ProcessedData.HF_TimeTicks(start_idx_HF:stop_idx_HF, :);
    
    ProcessedData.L1_Real = ProcessedData.L1_Real(start_idx_L1:stop_idx_L1, :);
    ProcessedData.L1_App = ProcessedData.L1_App(start_idx_L1:stop_idx_L1 , :);
    ProcessedData.L1_Imag = ProcessedData.L1_Imag(start_idx_L1:stop_idx_L1, :);
    ProcessedData.L1_Pf = ProcessedData.L1_Pf(start_idx_L1:stop_idx_L1, :);
    ProcessedData.L1_TimeTicks = ProcessedData.L1_TimeTicks(start_idx_L1:stop_idx_L1, :);
    
    ProcessedData.L2_Real = ProcessedData.L2_Real(start_idx_L2:stop_idx_L2, :);
    ProcessedData.L2_App = ProcessedData.L2_App(start_idx_L2:stop_idx_L2, :);
    ProcessedData.L2_Imag = ProcessedData.L2_Imag(start_idx_L2:stop_idx_L2, :);
    ProcessedData.L2_Pf = ProcessedData.L2_Pf(start_idx_L2:stop_idx_L2, :);
    ProcessedData.L2_TimeTicks = ProcessedData.L2_TimeTicks(start_idx_L2:stop_idx_L2, :);
    
end

% Labels (TaggingInfo) part relevant only for Training Datasets 
% **************************************************************
% Plot the data on Phase 1 (L1) as blue and Phase 2 (L2) as red
% Plot Real Power(W) and labels. Green is ON and Red line is OFF, along with
% device category ID.
h(1) = subplot(411); 
plot(ProcessedData.L1_TimeTicks, ProcessedData.L1_Real); grid; hold on;
plot(ProcessedData.L2_TimeTicks, ProcessedData.L2_Real, 'r');
title('Real Power (W) and ON/OFF Device Category IDs');

if(hasLabels == true && isfield(ProcessedData,'TaggingInfo') )
    % Draw ON/OFF and device labels. TaggingInfo's each row is:
    % <ApplianceID, ApplianceName, Start_UNIX_TimeStamp, Stop_UNIX_TimeStamp>
    for i=1:size(ProcessedData.TaggingInfo,1)
        line([ProcessedData.TaggingInfo{i,3},ProcessedData.TaggingInfo{i,3}],[0,500],'Color','g','LineWidth',2);
        %We add a little offset for display purposes to end marker since event could be +- 30
        %seconds of the timestamp.
        offset = 0;
        line([ProcessedData.TaggingInfo{i,4} + offset,ProcessedData.TaggingInfo{i,4} + offset],[0,500],'Color','r', 'LineWidth',2);    
        text(double(ProcessedData.TaggingInfo{i,3}),500,['ON-' ProcessedData.TaggingInfo{i, 2}] );
        text(double(ProcessedData.TaggingInfo{i,4}),500,['OFF'] );
    end
end

hold off;

% Plot Imaginary/Reactive power (VAR)
h(2) = subplot(412); plot(ProcessedData.L1_TimeTicks, ProcessedData.L1_Imag); grid; hold on;
plot(ProcessedData.L2_TimeTicks, ProcessedData.L2_Imag,'r'); hold off;

title('Imaginary/Reactive power (VAR)');
% Plot Power Factor
h(3) = subplot(413); plot(ProcessedData.L1_TimeTicks, ProcessedData.L1_Pf); grid; hold on;
plot(ProcessedData.L2_TimeTicks, ProcessedData.L2_Pf,'r');  hold off;
title('Power Factor');
xlabel('Unix Timestamp');

% Plot HF Noise
freq = linspace(1000000,0,4096); % FFT is of size 4096 point across 1 Mhz
h(4) = subplot(414);
imagesc(ProcessedData.HF_TimeTicks, freq, ProcessedData.HF);
title('High Frequency Noise');
ylabel('Frequency KHz');
axis xy;
y = [0:200000:1e6];
set(gca,'YTick',y);  % Apply the ticks to the current axes
set(gca,'YTickLabel', arrayfun(@(v) sprintf('%dK',v/1000), y, 'UniformOutput', false) ); % Define the tick labels based on the user-defined format

linkaxes(h,'x');

figure_handle = h;

end
