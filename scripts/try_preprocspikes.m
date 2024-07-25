% test filtering of data

raw = data(34,:);
fs = 30000;
fc = 300;
[b,a] = butter(2,fc/(fs/2), 'high');
filtdata = filtfilt(b,a,raw);
figure; plot(raw); hold on; plot(filtdata);


raw = data';
fs = 30000;
fc = 300;
[b,a] = butter(2,fc/(fs/2), 'high');
filtdata = filtfilt(b,a,raw);


figure; plot(raw(:,1)); hold on; 
plot(raw(:,33));
plot(raw(:,65));
plot(raw(:,97));


figure; plot(filtdata(:,1)); hold on; 
plot(filtdata(:,33));
plot(filtdata(:,65));
plot(filtdata(:,97));


figure; plot(raw(:,2)); hold on; 
plot(raw(:,34));
plot(raw(:,66));
plot(raw(:,98));

figure; plot(filtdata(:,2)); hold on; 
plot(filtdata(:,34));
plot(filtdata(:,66));
plot(filtdata(:,98));



%% proto median-filter method for multi-channel data

tab = struct2table(rhd.amplifier_channels);
chip_channel = tab.chip_channel;
uchip = unique(chip_channel);
nchip = length(uchip);
cmr = zeros(size(filtdata,1), nchip);
cmrdata = filtdata;
for i = 1:nchip
    % find the channels that have the same chip_channel label
    label = uchip(i);
    
    % subselect the multichannel data accordingly
    idx = find(chip_channel == label);
%     chipdata = filtdata(:,idx);
    
    % perform common median referencing with just that selection
    cmr(:,i) = median(cmrdata(:,idx),2);
    cmrdata(:,idx) = cmrdata(:,idx) - cmr(:,i);
    
    % compare the results
    figure;
    num = 1;
    subplot(2,2,num);
    plot(filtdata(:,idx(num))); hold on;
    plot(cmrdata(:,idx(num)));
    
    num = 2;
    subplot(2,2,num);
    plot(filtdata(:,idx(num))); hold on;
    plot(cmrdata(:,idx(num)));
    
    num = 3;
    subplot(2,2,num);
    plot(filtdata(:,idx(num))); hold on;
    plot(cmrdata(:,idx(num)));
    
    num = 4;
    subplot(2,2,num);
    plot(filtdata(:,idx(num))); hold on;
    plot(cmrdata(:,idx(num)));
    
    
    
end


%% RMS check for all channels (pre DBS segement)

% idx for all channels with "bad" RMS



