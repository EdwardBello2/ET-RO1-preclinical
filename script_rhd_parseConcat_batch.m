% script for generating: A) all parsed .mat files for each .rhd file; B)
% the single concatenated channel versions of teh same files


%% Based on "script_rhd_parse2matheader_batch.m"

% Input defined by rhd metadata table
% tic
clear; 
addpath(genpath('C:\Users\bello043\Documents\GitHub\ET-RO1-preclinical'));

concatbasename = 'ThalDbsCxRec01_230609';
acquispath = 'C:\Users\bello043\datatemp\data-acquisition\20230609\';
procpath = 'C:\Users\bello043\datatemp\data-processing\20230609\';
labelpath = [procpath 'singleChannelLabels.mat'];

% selpath = uigetdir();

% cd 'C:\Users\bello043\datatemp\ThalDbsCxRec01_230526_110422'
cd(acquispath); % have matlab looking at acquisition data location

parseMatDir = [procpath '\parsedMatfiles\'];

% load spreadsheet of rhd files "rhdFileMetadata"
% [file, path, idx] = uigetfile();
inputTab = readtable('rhdFileMetadata.xlsx');



% tic
% Run thru each file, parse it into mat files, collected parsed file
% metadata
sessTab = table();
tic
disp('Parsing .rhd files into smaller individual .mat files')
nFiles = height(inputTab);
f = waitbar(0, ['0 of ' num2str(nFiles) ' files parsed'])

for iFile = 1:nFiles
    % Create updated matlab header as "rhd", also write parsed mat files
    rhdname = strrep(inputTab.filename{iFile}, '''', '');
    rhd = read_Intan([rhdname]);
%     rhd_parse2headermat(rhd, 'writefiles', true);
    %tic
    rhd = rhd_parse2headermat(rhd, 'writefiles', true, ...
        'parsedDir', parseMatDir, ...
        'singleChannelFiles', true);
    % toc
    
    % Specify table object from parsedDataPointer field
    itab = struct2table(rhd.parsedDataPointer);
    nRows = height(itab);
    itab.filename(1:nRows) = inputTab.filename(iFile);
    
    % Update overall table from session of .rhd files
    sessTab = [sessTab; itab];
    
    waitbar(iFile/nFiles, f, [num2str(iFile), ' of ', num2str(nFiles), ...
        ' files parsed'])
    
end

% join the input table and session parsed table for full info on each
% parsed file, then save in same parsed mat file directory!
parsedMatfilesMetadata = join(sessTab, inputTab);
writetable(parsedMatfilesMetadata, [parseMatDir, 'parsedMatfilesMetadata.xlsx']);
% toc
disp('Finished parsing all .rhd file data into small .mat files')
toc


%% Based on "script_genConcatTimeseries_batch.m"

% labels = {};
tic
% dataType = 'amplifier_data'; % char array, amplifier_data | aux_input_data | board_dig_in_data | t_amplifier | t_aux_input | t_dig | header
% chanLabel = 'A-003'; % char array, variety of inputs A-<XXX> | DIGITAL-IN-0<X> | A-AUX<X>
TDTsynapseProgramLabels = {'ETRO1_pA', 'ETRO1_pB'}; % char array, ETRO1_pA | ETRO1_pB

%
%tic
% Specify location of parsed data and spreadsheet, this is also where the
% concatenated files will be saved to

for i = 1:2
    
TDTsynapseProgram = TDTsynapseProgramLabels{i};

    tabpn = parseMatDir;
    cd(parseMatDir);
    tabname = 'parsedMatfilesMetadata.xlsx';
    sessTab = readtable([tabpn tabname]);
    % concatbasename = 'ThalDbsCxRec01_230607';

    load(labelpath); % variable name is "labels"
    isWrite = logical(cell2mat(labels(:,3)));
    labelsWr = labels(isWrite,:);
    nLabels = size(labelsWr,1);

    f = waitbar(0, ['0 of ' num2str(nLabels) ' channels concatenated']);
    chCnt = 0;
    for iLabel = 1:nLabels
        chCnt = chCnt+1;
        dataType = labelsWr{iLabel,2}; % char array, amplifier_data | aux_input_data | board_dig_in_data | t_amplifier | t_aux_input | t_dig | header
        chanLabel = labelsWr{iLabel,1}; % char array, variety of inputs A-<XXX> | DIGITAL-IN-0<X> | A-AUX<X>


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
        % figure; plot(concatdata)

        %% save the data

        % basename = 'ThalDbsCxRec01_230519';
        savename = [concatbasename '_' TDTsynapseProgram '_' dataType chanLabel];
        save([procpath savename], 'concatdata');

        waitbar(chCnt/nLabels, f, ['Concatenating channel ', num2str(chCnt), ...
            ' of ', num2str(nLabels)])

    end
        % toc

    toc
        disp('DONE with all files!')
        
end

