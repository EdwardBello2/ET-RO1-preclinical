% script for generating a table containing metadata for all parsed mat files of a given recording day


%% Read in metadata table around .rhd files, .csv spreadsheet

[file,path] = uigetfile('*.csv');

% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 3);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["filename", "experimentPhase", "TDTsynapseProgram"];
opts.VariableTypes = ["char", "categorical", "categorical"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "filename", "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["filename", "experimentPhase", "TDTsynapseProgram"], "EmptyFieldRule", "auto");

% Import the data
rhdtab = readtable([path file], opts);

% Clear temporary variables
clear opts



%%


% use the parsing code to retrieve mat header info for each rhd file
nFiles = height(rhdtab);
T = table;
fileNum = zeros(nFiles,1);
f = waitbar(0, ['0 of ' num2str(nFiles) ' files parsed'])
for iFile = 1:nFiles
    rhd = read_Intan([path file{iFile}]);
%     rhd_parse2headermat(rhd, 'writefiles', true);
    rhd = rhd_parse2headermat(rhd, 'writefiles', false);

%     fileNum = ones(height(T_iFile), 1) * iFile;
%     T_iFile = [table(fileNum), T_iFile];
%     T = [T; T_iFile];
    
    waitbar(iFile/nFiles, f, [num2str(iFile), ' of ', num2str(nFiles), ...
        ' files parsed'])
    
end



% construct the metadata table with a row for each individual timeseries
% file


% save the table in the same directory as all the parsed data