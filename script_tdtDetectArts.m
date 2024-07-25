% script for detecting DBS artifact occurrences within the .rhd-derived
% channel data using known pulse times from teh TDT file

% load TDT file stim info

% load 

%% Version for ETRO1_pB
selpath = uigetdir

% Read in TDT events 
% heads = TDTbin2mat([selpath], 'HEADERS', 1);
blk = TDTbin2mat([selpath], 'TYPE', {'epocs', 'scalars'});


% Create TDT-based event tables for DBS stim events
ts_stim = blk.epocs.DurA.onset;
idxStim = [1:length(ts_stim)]';
 CnA_onset = blk.epocs.CnA_.onset;
  CnA_data = blk.epocs.CnA_.data;
DurA_onset = blk.epocs.DurA.onset;
 DurA_data = blk.epocs.DurA.data;
 Pu1_onset = blk.epocs.Pu1_.onset;
  Pu1_data = blk.epocs.Pu1_.data;
 PC2_onset = blk.epocs.PC2_.onset; 
  PC2_data = blk.epocs.PC2_.data;
  
  dbsStimInfo = table(idxStim, ts_stim, CnA_onset, CnA_data, DurA_onset, ...
      DurA_data, Pu1_onset, Pu1_data, PC2_onset, PC2_data);


% Create TDT-based event tables for DBS pulse events
ts_pulse = blk.epocs.ChnA.onset;
idxPulse = [1:length(ts_pulse)]';
 PeA_onset = blk.epocs.PeA_.onset;
  PeA_data = blk.epocs.PeA_.data;
ChnA_onset = blk.epocs.ChnA.onset;
 ChnA_data = blk.epocs.ChnA.data;
AmpA_onset = blk.epocs.AmpA.onset;
 AmpA_data = blk.epocs.AmpA.data;

idx_pulse2stim = zeros(size(ts_pulse));

% detect stim time concurrent with pulse time
nStims = length(ts_stim);
for iStim = 1:nStims
    its = ts_stim(iStim);
    ref = ts_pulse - its;
    idx = find(ref == min(abs(ref)));
    idx_pulse2stim(idx) = iStim;
    
end

% update indices connecting stim event with corresponding pulse events
nPulses = length(ts_pulse);
for iPulse = 1:nPulses
    if idx_pulse2stim(iPulse) == 0
        idx_pulse2stim(iPulse) = idx_pulse2stim(iPulse-1); 
        
    end
    
end

idxPulse = [1:nPulses]';
idxStim = idx_pulse2stim;

dbsPulseInfo = table(idxPulse, idxStim, ts_pulse, PeA_onset, PeA_data, ...
   ChnA_onset, ChnA_data, AmpA_onset, AmpA_data);




%% Version for ETRO1_pA

selpath = uigetdir

% Read in TDT events 
% heads = TDTbin2mat([selpath], 'HEADERS', 1);
blk = TDTbin2mat([selpath], 'TYPE', {'epocs', 'scalars'});


% Create TDT-based event tables for DBS stim events
 CnA_onset = blk.epocs.CnA_.onset;
  CnA_data = blk.epocs.CnA_.data;
 Pu1_onset = blk.epocs.Pu1_.onset;
  Pu1_data = blk.epocs.Pu1_.data;
 PC2_onset = blk.epocs.PC2_.onset; 
  PC2_data = blk.epocs.PC2_.data;
  
  ts_stim = blk.epocs.CnA_.onset;
  idxStim = [1:length(ts_stim)]';
  
  dbsStimInfo = table(idxStim, ts_stim, CnA_onset, CnA_data, Pu1_onset, Pu1_data, ...
      PC2_onset, PC2_data);
  
  
 % Create TDT-based event tables for DBS pulse events

 PeA_onset = blk.epocs.PeA_.onset;
  PeA_data = blk.epocs.PeA_.data;
ChnA_onset = blk.epocs.ChnA.onset;
 ChnA_data = blk.epocs.ChnA.data;
AmpA_onset = blk.epocs.AmpA.onset;
 AmpA_data = blk.epocs.AmpA.data;
 ts_pulse = blk.epocs.ChnA.onset;
idxPulse = [1:length(ts_pulse)]';
  

idx_pulse2stim = zeros(size(ts_pulse));

% detect stim time concurrent with pulse time
nStims = length(ts_stim);
for iStim = 1:nStims
    its = ts_stim(iStim);
    ref = ts_pulse - its;
    idx = find(ref == min(abs(ref)));
    idx_pulse2stim(idx) = iStim;
    
end

% update indices connecting stim event with corresponding pulse events
nPulses = length(ts_pulse);
for iPulse = 1:nPulses
    if idx_pulse2stim(iPulse) == 0
        idx_pulse2stim(iPulse) = idx_pulse2stim(iPulse-1); 
        
    end
    
end

idxPulse = [1:nPulses]';
idxStim = idx_pulse2stim;

dbsPulseInfo = table(idxPulse, idxStim, ts_pulse, PeA_onset, PeA_data, ...
   ChnA_onset, ChnA_data, AmpA_onset, AmpA_data);



