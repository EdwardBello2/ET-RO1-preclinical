% script for reading in and messing with TDT data & RHD data

%%

pn = '';

% load in TDT stim event data
tdt = TDTbin2mat('C:\DATAtemp\ET RO1 Preclinical\data-acquisition\ETRO1_pB-230413-161006\Zebel-230414-113709');
% load in one channel of RHD data (a deep one)


%% Synchronize TDT DBS pulse time data to occurrences of DBS artifacts in
% the RHD data
filename = 'C:\DATAtemp\ET RO1 Preclinical\data-acquisition\test';
%% Compare known channel of stim with artifact shape/size as it appears on
% RHD data. Are they similar in batches of 3? Can I recover 3-channel
% "ring" groups using this visualization?



