% script for lining up TDT-based event times with rhd-based data


% Read in TDT events 

tdtpn = 'C:\DATAtemp\ET RO1 Preclinical\data-acquisition\20230505\';
tdtfn = 'Zebel-230505-112312';
heads = TDTbin2mat([tdtpn tdtfn], 'HEADERS', 1);
blk = TDTbin2mat([tdtpn tdtfn], 'TYPE', {'epocs', 'scalars'});

% Create TDT-based event tables for DBS stim events
period = blk.epocs.PeA_.data;
count = blk.epocs.CntA.data;
% amp_uA = [];
% stimCh = [];
epocLabel = [1:length(period)]';
epocOnset = blk.epocs.PC2_.onset;
dbsStimInfo = table(epocLabel, epocOnset, period, count);

% Create TDT-based event tables for DBS pulse events
amp_uA = blk.epocs.AmA_.data;
pulseTime = blk.epocs.AmA_.onset;
stimCh = blk.epocs.ChnA.data;


dbsPulseInfo = table(pulseTime, stimCh, amp_uA);

%% Test plotting first pulse event in example channel

% load example channel
rhdpn = 'C:\DATAtemp\ET RO1 Preclinical\data-acquisition\20230505\';
rhd_chanData = 'ThalDbsCxRec01_230505_112316amplifier_data_ch64.mat';
rhd_chanTimes = 'ThalDbsCxRec01_230505_112316amplifier_data_timestamps.mat';

load([rhdpn rhd_chanData], 'raw');
load([rhdpn rhd_chanTimes], 't');

% plot data and DBS pulse event together
figure; plot(t, raw);
hold on;
stem(dbsPulseInfo.pulseTime(1), max(raw));





%% Test gathering DBS artifacts for a given dbs stim epoc

% set time-offset correction for DBS pulse events
toffset = -4.8944e-04; % seconds

stimCh = 13; % [7 11 13 15 17 19 21 23 25 27 29 31]

isStimCh = dbsPulseInfo.stimCh == stimCh;

pulseTimes = dbsPulseInfo.pulseTime(isStimCh);
pulseTimes = pulseTimes + toffset;


nPulses = length(pulseTimes);
fs = 30000; % samples / sec
pp = 7.7 / 1000; % seconds
sampWin = round(pp * fs);
idx = round(pulseTimes * fs);

fc = 300;
[b, a] = butter(2, fc/(fs/2), 'high');
filtdata = filtfilt(b, a, raw);
    
art = zeros(nPulses, sampWin);
tart = (0:sampWin-1) * (1/fs);

for iPulse = 1:nPulses
        iArt = filtdata(idx(iPulse):idx(iPulse)+sampWin-1);
        art(iPulse,:) = iArt;
%         [maxV, maxIdx] = max(iArt);
%         [minV, minIdx] = min(iArt);
%         
%         % record peak-peak value
%         pp(iPulse) = abs(maxV - minV);
%         
%         % record leading peak
%         if maxIdx < minIdx
%             leadingPk(iPulse) = maxV;
%             
%         else 
%             leadingPk(iPulse) = minV;
%             
%         end
%         
        

end
    
figure; ax = axes;
plot(tart, art');
ax.YLim = [-1000 1000];
grid on











