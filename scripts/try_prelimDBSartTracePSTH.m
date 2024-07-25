% script to try reading in all channel data and displaying artifact
% entrainment

clear


%% quick put together a table of relevant filenames

% using user input, get a list of all .rhd files to run thru, and exclude
% the settings file for now

recordingPath = 'C:\Users\bello043\datatemp';

listing = dir(recordingPath);

% keep only the .rhd files, listed in order
nRows = size(listing,1);
isRHD = false(nRows,1);
for iRow = 1:nRows
    filename = listing(iRow).name;
    [~,fn,ext] = fileparts(filename);
    isRHD(iRow) = strcmp(ext, '.rhd');
    
end

rhdListing = struct2table(listing(isRHD));
rhdListing = sortrows(rhdListing, 'name');



%% Main code

parseMatDirPath = 'C:\Users\bello043\datatemp\ThalDbsCxRec01_230519_111757_SessionMatfiles\';

% read in all files for a given channel
nFiles = height(rhdListing);
ch = 1;

for iFile = 1:nFiles
    [~,name,~] = fileparts(rhdListing.name{iFile});
    headername = [name '_header.mat'];

    load([parseMatDirPath headername]); % load the struct "rhd"
    nSamp(iFile,1) = rhd.dataPointer.amplifier_data(ch).nsamples;
    ampFilename{iFile,1} = rhd.dataPointer.amplifier_data(ch).filename;
    
end

totSamp = sum(nSamp);
cumsamp = cumsum(nSamp);
idxbeg = [1 ; cumsamp+1];
idxbeg(end) = [];
idxend = cumsamp;
% idx = [idxbeg, idxend];

ampChData = zeros(1,totSamp);





for iFile = 1:nFiles
    load([parseMatDirPath ampFilename{iFile,1}]); % load the double "data"
    ampChData(1, idxbeg(iFile):idxend(iFile)) = data;
    
end
fs = 30000; % samples / sec
pp = 7.7 / 1000; % seconds
sampWin = round(pp * fs);
% idx = round(pulseTimes * fs);

fc = 300;
[b, a] = butter(2, fc/(fs/2), 'high');
filtdata = filtfilt(b, a, ampChData);
    
% art = zeros(nPulses, sampWin);
tart = (0:sampWin-1) * (1/fs);



% create histogram of peak heights to see how big the artifacts are
% relative to spike heights
[pkspos,~] = findpeaks(filtdata(filtdata>0));
[pksneg,~] = findpeaks(-filtdata(filtdata<0));
pks = [pkspos, -pksneg];
figure; histogram(pks);

% decide on threshold for dbs artifact detection
thresh = -1000;

% detect artifact threshold crossings in data
idxArt = detectArt(filtdata, thresh, 'threshCrossEdge', 'falling');


% gather segments & display
sampArt = find(idxArt);
fs = 30000; % samples / sec
pp = 7.7 / 1000; % seconds
sampWin = round(pp * fs);
[segs,segIndices] = segments(filtdata, sampArt, sampWin-1);

figure; histogram(diff(sampArt));

figure; plot(
