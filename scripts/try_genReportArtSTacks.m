% scsript for generating a crap-ton of figures, each showing a DBS artifact
% stack and hopefully neuron waveforms entrained to them; each stack would
% be for one recording channel, one stack for each of 12 DBS conditions,
% for a grand total of 128 x 12 = 1536 stacks. 


% General approach: Cycle thru every combo, and in the end save the figures
% as images in a pdf flip-book, 1 page per figure for easy flipping.
clear

%% Create TDT-based event timing info table

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



%% Run thru each recording channel and DBS stim epoch to get artifact stack and save it

savepn = 'L:\Shared drives\Johnson\Lab Projects\Project - ET RO1 preclinical\reports\2023-05-09 Progress report figures\artfigs\';


nChans = 128;
stimChs = [7 11 13 15 17 19 21 23 25 27 29 31];
nStims = length(stimChs);
figCount = 0;
for iChan = 5:nChans

    % Cycle thru each channel:
    % load RHX recorded channel
    % load example channel
    rhdpn = 'C:\DATAtemp\ET RO1 Preclinical\data-acquisition\20230505\';
    rhd_chanData = ['ThalDbsCxRec01_230505_112316amplifier_data_ch' num2str(iChan) '.mat'];
    rhd_chanTimes = 'ThalDbsCxRec01_230505_112316amplifier_data_timestamps.mat';

    load([rhdpn rhd_chanData], 'raw');
    % load([rhdpn rhd_chanTimes], 't');


    % Cycle thru each DBS condition:
    

    % Process:
    % get artifact stack
    % set time-offset correction for DBS pulse events
    toffset = -4.8944e-04; % seconds
    for iStim = 1:nStims
        figCount = figCount+1;
        disp(['processing figure ' num2str(figCount)]);
%         stimCh = 13; % [7 11 13 15 17 19 21 23 25 27 29 31]
        isStimCh = dbsPulseInfo.stimCh == stimChs(iStim);

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

        end

        % save image as .jpg to particular folder
        f = figure; ax = axes;
        plot(tart, art');
        ax.YLim = [-1000 1000];
        grid on

        savefn = ['artStack-recCh' num2str(iChan) '-stimCh' num2str(stimChs(iStim))];
        title(savefn)

        saveas(f, [savepn savefn '.jpg']) 
        disp(['saved ' savefn]);
        close(f)
    
    end

end