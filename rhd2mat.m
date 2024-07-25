% script for converting one .rhd "traditional" to many smaller files in .mat format. For the type
% of recording that's running during the experimental protocol, an .rhd
% file with all recording info is generated for every 1 min of recording.
% The idea is to parse out all relevant data into smaller chunks and save
% them as .mat files for ease of loading -- currently each file is pretty
% big and takes a while to load!



%% Code

addpath(genpath('C:\Users\bello043\Documents\GitHub\ET-RO1-preclinical'));


% Specify one .rhd file to load
pn = 'C:\Users\bello043\IntanToNWB\IntanToNWB-main\';
fn = 'ThalDbsCxRec01_230519_111757.rhd';


% By default the save location will be the same as the load location




% 

rhd = read_Intan([pn fn]);

T = rhd_parse2mat(rhd, 'writefiles', 2);


% separate out the following:
% amplifier channels
% digital input channels
% both their timestamps

[~,fnsv,~] = fileparts(fn);

%% save individual amplifier channels data:
nChans = size(rhd.amplifier_data,1);

orig_fileName = cell(nChans,1);
orig_fileType = cell(nChans,1);
proc_fileName = cell(nChans,1);
proc_fileType = cell(nChans,1);
n_samples = zeros(nChans,1);
sampling_rate = zeros(nChans,1);
channelType = cell(nChans,1);

for iCh = 1:nChans
    
    amplifier_data = rhd.amplifier_data(iCh,:);
    savename = [fnsv '_' rhd.amplifier_channels(iCh).native_channel_name];
    
    orig_fileName{iCh,1} = fn;
    orig_fileType{iCh,1} = '.rhd';
    proc_fileName{iCh,1} = savename;
    proc_fileType{iCh,1} = '.mat';
    n_samples(iCh,1) = length(amplifier_data);
    sampling_rate(iCh,1) = rhd.frequency_parameters.amplifier_sample_rate;
    channelType{iCh,1} = 'amplifier_data';
    
    save([pn savename], 'amplifier_data');
    disp(['Saved ' savename '.mat'])
    
end
T_amplifier = [table(orig_fileName), table(orig_fileType), ...
    table(proc_fileName), table(proc_fileType), table(n_samples), ...
    table(sampling_rate), table(channelType), ...
    struct2table(rhd.amplifier_channels)];


% save common amplifier channel timestamps
timestamps = rhd.t_amplifier;
savename = [fnsv '_A-timestamps'];
save([pn savename], 'timestamps');
disp(['Saved ' savename '.mat'])



% add in table row for amplifier timestamps
T_amp_tst = T_amplifier(1,:);
T_amp_tst.proc_fileName{1,1} = savename;
T_amp_tst.proc_fileType{1,1} = '.mat';
T_amp_tst.n_samples(1,1) = length(timestamps);
T_amp_tst.sampling_rate(1,1) = rhd.frequency_parameters.amplifier_sample_rate;
T_amp_tst.channelType{1,1} = 'amplifier_timestamps';
% Also deal with defaults for non-applicable fields
T_amp_tst{1,8:9} = {'<missing>'};
T_amp_tst{1,10:13} = NaN;
T_amp_tst{1,14:15} = {'<missing>'};
T_amp_tst{1,16:18} = NaN;

T_amplifier = [T_amplifier; T_amp_tst];



%% save digital input line data:
nChans = size(rhd.board_dig_in_data,1);

orig_fileName = cell(nChans,1);
orig_fileType = cell(nChans,1);
proc_fileName = cell(nChans,1);
proc_fileType = cell(nChans,1);
n_samples = zeros(nChans,1);
sampling_rate = zeros(nChans,1);
channelType = cell(nChans,1);

for iCh = 1:nChans
    
    dig_in_data = rhd.amplifier_data(iCh,:);
    savename = [fnsv '_' rhd.board_dig_in_channels(iCh).native_channel_name];
    
    orig_fileName{iCh,1} = fn;
    orig_fileType{iCh,1} = '.rhd';
    proc_fileName{iCh,1} = savename;
    proc_fileType{iCh,1} = '.mat';
    n_samples(iCh,1) = length(dig_in_data);
    sampling_rate(iCh,1) = rhd.frequency_parameters.board_dig_in_sample_rate;
    channelType{iCh,1} = 'dig_in_data';
    
    save([pn savename], 'dig_in_data');
    disp(['Saved ' savename '.mat'])
    
end
T_dig_in = [table(orig_fileName), table(orig_fileType), ...
    table(proc_fileName), table(proc_fileType), table(n_samples), ...
    table(sampling_rate), table(channelType), ...
    struct2table(rhd.board_dig_in_channels)];


% save common digin channel timestamps
timestamps = rhd.t_dig;
savename = [fnsv '_DIGITAL-IN-timestamps'];
save([pn savename], 'timestamps');
disp(['Saved ' savename '.mat'])


% add in table row for digin timestamps
T_dig_tst = T_dig_in(1,:);
T_dig_tst.proc_fileName{1,1} = savename;
T_dig_tst.proc_fileType{1,1} = '.mat';
T_dig_tst.n_samples(1,1) = length(timestamps);
T_dig_tst.sampling_rate(1,1) = rhd.frequency_parameters.board_dig_in_sample_rate;
T_dig_tst.channelType{1,1} = 'dig_in_data_timestamps';
% Also deal with defaults for non-applicable fields
T_dig_tst{1,8:9} = {'<missing>'};
T_dig_tst{1,10:13} = NaN;
T_dig_tst{1,14:15} = {'<missing>'};
T_dig_tst{1,16:18} = NaN;

T_dig_in = [T_dig_in; T_dig_tst];




