% Code for testing the genJitterStimtrain function

dbsfreq = 100; % Hz

totaltime = 60; % sec
srate = 24414.0625; % samp / sec
avISIms = 1e3*1/(dbsfreq); % msec
percStdms = 0.1; 

test = genJitterStimtrain(totaltime, srate, avISIms, percStdms);

