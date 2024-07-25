% script for converting rhd files into one mat file per channel for just
% one example file


%% read in table of info on all rhd files

clear

% using user input, get a list of all .rhd files to run thru, and exclude
% the settings file for now

pn = 'C:\DATAtemp\ET RO1 Preclinical\data-acquisition\20230505\';

recordingPath = [pn 'ThalDbsCxRec01_230505_112316'];

listing = dir(recordingPath);


% refine the selection of elements in listing
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


nChans = 128;
for iCh = 1:nChans
    
    ch = iCh;
    raw = [];
    % t = [];
    % dig = [];
    % tdig = [];

    nRows = length(listing);
    tic
    for iRow = 1:nRows
        pn = listing(iRow).folder;
        fn = listing(iRow).name;
        intan_data = read_Intan([pn '\' fn]);

        raw = [raw, intan_data.amplifier_data(ch,:)];
    %     t = [t, intan_data.t_amplifier];
    %     dig = [dig, intan_data.board_dig_in_data];
    %     tdig = [tdig, intan_data.t_dig];
        disp(['Concatenated data from file ', num2str(iRow),' of ', num2str(nRows)]);

    end
    toc

    % keep adding to the channel of interest with each iteration, and its
    % accompanying timestamp..

    % figure; plot(t,raw)

    save([pn 'amplifier_data_ch' num2str(ch)], 'raw');
    % save([pn 'amplifier_data_timestamps'], 't');
    % save([pn 'dig_in_data'], 'dig');
    % save([pn 'dig_in_timstamps'], 'tdig');

end

%%
% read in data and iteratively append data to single channel of data when
% saving



