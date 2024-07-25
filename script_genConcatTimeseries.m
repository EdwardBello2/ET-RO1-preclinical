% script for generating concatenated (or "stiched-together") files for one
% whole timeseries of data across all .rhd files


%% TABLE SELECT
clear
dataType = 'board_dig_in_data'; % char array, amplifier data | aux_input_data | board_dig_in_data | t_amplifier | t_aux_input | t_dig | header
chanLabel = 'DIGITAL-IN-02'; % char array, variety of inputs A-<XXX> | DIGITAL-IN-0<X> | A-AUX<X>
TDTsynapseProgram = 'ETRO1_pA'; % char array, ETRO1_pA | ETRO1_pB

%%

% Specify location of parsed data and spreadsheet, this is also where the
% concatenated files will be saved to
tabpn = 'C:\Users\bello043\datatemp\ThalDbsCxRec01_230519\parsedMatfiles\';
tabname = 'parsedMatfilesMetadata.xlsx';
sessTab = readtable([tabpn tabname]);
basename = 'ThalDbsCxRec01_230519';

cd C:\Users\bello043\datatemp\ThalDbsCxRec01_230519\parsedMatfiles


% sub-selected files 
isChLab = strcmp(sessTab.chanLabel, chanLabel);
isTDT = strcmp(sessTab.TDTsynapseProgram, TDTsynapseProgram);

isSelect = isChLab & isTDT;

conTab = sessTab(isSelect,:);
conTab = sortrows(conTab, 'fileOrder', 'ascend');

% pre-allocate space for the file
totSamps = sum(conTab.nsamples);
concatdata = [];

% concatenate the data
nFiles = height(conTab);
for iFile = 1:nFiles
    load(conTab.parsedFilename{iFile}); % data
    
    concatdata = [concatdata, data];
    
    
end
figure; plot(concatdata)

%% save the data

% basename = 'ThalDbsCxRec01_230519';
savename = [basename '_' dataType chanLabel];
save(savename, 'concatdata');

