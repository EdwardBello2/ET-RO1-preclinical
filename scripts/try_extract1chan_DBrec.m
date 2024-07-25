% function for reading all the data of one amplifier channel for a given
% recording, using the 1-min at a time mode of recording on intan..
% Author: Ed Bello

clear

% using user input, get a list of all .rhd files to run thru, and exclude
% the settings file for now

recordingPath = 'C:\DATAtemp\ET RO1 Preclinical\data-acquisition\20230414\CxTest04_230414_113714';

listing = dir(recordingPath);


%% refine the selection of elements in listing
% remove directories
isDir = [listing(:).isdir];
listing = listing(~isDir);

% keep only .rhd extension files 
nRows = length(listing);
ext = cell(nRows,1);
for iRow = 1:nRows
    [~,~,ext{iRow}] = fileparts(listing(iRow).name);
    
end
isRhd = strcmp(ext, '.rhd');
listing = listing(isRhd);



%%

ch = 64;
raw = [];
t = [];
nRows = length(listing);
tic
for iRow = 1:nRows
    pn = listing(iRow).folder;
    fn = listing(iRow).name;
    intan_data = read_Intan([pn '\' fn]);
    
    raw = [raw, intan_data.amplifier_data(ch,:)];
    t = [t, intan_data.t_amplifier];
    disp(['Concatenated data from file ', num2str(iRow),' of ', num2str(nRows)]);
    
end
toc

% keep adding to the channel of interest with each iteration, and its
% accompanying timestamp..

figure; plot(t,raw)

