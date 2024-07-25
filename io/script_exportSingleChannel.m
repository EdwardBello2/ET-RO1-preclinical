% script for partially loading single channels from the large
% amplifier_data file, and saving them singly for later artifact viewing

clear

% Create mat file object for interacting with large data
[file, path] = uigetfile();
cd(path);
matObj = matfile(file);
tic

% iterate thru all channels
[len, nChans] = size(matObj, 'data');

chans = [17,31,32,33,34,38,39,46,48,53,58,62,66,67,73,74,77,83,84,87,88,89,96,97,98,99,101]-1;
chCnt = 0;
f = waitbar(0, ['Exporting 0 of ' num2str(numel(chans)) ' channels...'])
for iChan = chans
    clear matObj
    matObj = matfile(file);

    % Specify channel and label
    ch = iChan+1;
    label = ['A-' num2str(iChan, '%03d')];
    data(len,1) = 0;
   
    data = matObj.data(1:len,ch);

%     figure; plot(data)
    % save mat file
    save([file '_' label '.mat'], 'data', '-v7.3');
    
    chCnt = chCnt+1;
     waitbar(chCnt/numel(chans), f, ['Exporting channel ', num2str(chCnt), ...
        ' of ', num2str(numel(chans)), ' files'])
    
end
disp('Done exporting all channels!')

toc
% 
% nout = 0;
% while(nout < size)
%     fprintf('Writing %d of %d\n',nout,size);
%     chunkSize = min(chunk,size-nout);
%     data = mean + std * randn(1,chunkSize);
%     matObj.data(1,(nout+1):(nout+chunkSize)) = data;
%     nout = nout + chunkSize;
% end