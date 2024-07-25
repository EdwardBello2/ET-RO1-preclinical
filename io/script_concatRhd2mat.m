% script for reading in a sequence of "traditional-type" .rhd files from a
% single session, and creating concatenated versions for each type of time
% series data, both single and multichannel



% user selects multiple .rhd files


%% each gets loaded in turn, and number of samples leng for each variable of
% interest in each file is tracked

clear; 
addpath(genpath('C:\Users\bello043\Documents\GitHub\ET-RO1-preclinical'));

% specify the time series fields to save from all .rhd files
dataTypeFields = {'aux_input_data', 'board_dig_in_data', 't_amplifier', ...
    't_aux_input', 't_dig', 'amplifier_data'}; %'amplifier_data', 

% manualy specify the files to concatenate data from
[file, path] = uigetfile('.rhd', 'Multiselect','on');
cd(path); 
tic
% gather size metadata for all fields from each file
nFiles = length(file);
f = waitbar(0, ['Reading metadata for 0 of ' num2str(nFiles) ' files...'])
for iFile = 1:nFiles
    % Create updated matlab header as "rhd", also write parsed mat files
%     rhdname = strrep(inputTab.filename{iFile}, '''', '');
    rhd = read_Intan([path file{iFile}]);
%     rhd_parse2headermat(rhd, 'writefiles', true);
    nTypes = length(dataTypeFields);
    for iType = 1:nTypes
        dataType = dataTypeFields{iType};
        len(iFile).(dataType) = size(rhd.(dataType),2);
        chans(iFile).(dataType) = size(rhd.(dataType),1);
        
    end
    
%     len(iFile).amplifier_data = size(rhd.amplifier_data,2);
%     len(iFile).t_amplifier = size(rhd.t_amplifier,2);
%     len(iFile).aux_input_data = size(rhd.aux_input_data,2);
%     len(iFile).t_aux_input = size(rhd.t_aux_input,2);
%     len(iFile).board_dig_in_data = size(rhd.board_dig_in_data,2);
%     len(iFile).t_dig = size(rhd.t_dig,2);
%     
%     chans(iFile).amplifier_data = size(rhd.amplifier_data,1);
%     chans(iFile).t_amplifier = size(rhd.t_amplifier,1);
%     chans(iFile).aux_input_data = size(rhd.aux_input_data,1);
%     chans(iFile).t_aux_input = size(rhd.t_aux_input,1);
%     chans(iFile).board_dig_in_data = size(rhd.board_dig_in_data,1);
%     chans(iFile).t_dig = size(rhd.t_dig,1);
    
    waitbar(iFile/nFiles, f, ['Reading metadata for ', num2str(iFile), ...
        ' of ', num2str(nFiles), ' files'])
    
end
disp('Done reading metadata for all files!')


% Initialize matfile objects for each data field of interest
nTypes = length(dataTypeFields);
for iType = 1:nTypes
    
    % create the matfile for the data field
    dataType = dataTypeFields{iType};
    fileName = [dataType '.mat'];
    matObj{iType} = matfile(fileName);
    matObj{iType}.Properties.Writable = true;
    
    % pre-allocate the size of the data for each matfile
    for iFile = 1:nFiles
        datalen(iFile) = len(iFile).(dataType);
    
    end
    totLen = sum(datalen);
    nch = chans(1).(dataType);
    matObj{iType}.data(totLen,1:nch) = 0;

    
end


% Iteratively add to each matfile object as each rhd file is loaded
nout(1:nTypes) = 0; % initialize a sample counter for each data type
nFiles = length(file);
f = waitbar(0, ['Concatenating data for 0 of ' num2str(nFiles) ' files...'])
for iFile = 1:nFiles
    rhd = read_Intan([path file{iFile}]);
    
    for iType = 1:nTypes
        dataType = dataTypeFields{iType};
        data = rhd.(dataType)';
        nch = chans(1).(dataType);

        chunkSz = len(iFile).(dataType);
        matObj{iType}.data((nout(iType)+1):(nout(iType)+chunkSz),1:nch) = data;
        nout(iType) = nout(iType) + chunkSz;
    
    end
    
     
    
    waitbar(iFile/nFiles, f, ['Concatenating data for ', num2str(iFile), ...
        ' of ', num2str(nFiles), ' files'])
    
end
disp('Done concatenating data for all files!')



toc


