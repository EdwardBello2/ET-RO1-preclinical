% code for generating file stim in TDT Synapse for irregular DBS pulses
function [stim_OU] = genJitterStimtrain(totaltime, srate, avISIms, percStdms)
% calculates stim times in milliseconds
%
%
% INPUT
% total time: total time of stimtrain, seconds
% srate: sampling rate of system to deliver stim events, samples / second
% avISI: average interstimulus interval, milliseconds
% percStd: the percentage around avISIms for 1 standard deviation (0.1),
% 10% of a milliseconds
T = totaltime; % sec
dt = 1e3*(1/srate); % msec
Fs_DBS = 1/(avISIms/1e3); % Hz, pulses per sec

% All Milad's code below:
% T = 60; % sec
% dt = 0.1; % msec
% Fs_DBS = 100; % Hz
mu_ISI = 1e3*1/Fs_DBS; % (10 msec eq. = 100 Hz), msec
std_ISI = percStdms*mu_ISI; % msec
stim = zeros(floor(T/dt * 1e3),1);

threshold_min_ISI = 2;% msec the timing of two consecutive pulses cannot be less than 2 msec
num_pulse = T*Fs_DBS;
rand_ISI = randn(num_pulse,1);
ISI = mu_ISI + std_ISI*rand_ISI; % msec
ISI(ISI<=threshold_min_ISI) = threshold_min_ISI;
stim(floor(cumsum(ISI/dt))) = 1;
stim(floor(T/dt * 1e3):end) = 0; stim = stim(1:floor(T/dt * 1e3));

% figure; plot(dt:T*1e3/dt,max(ISI)*stim)
%hold on, plot((1:length(ISI))/dt/1e3,ISI,'b')

% figure; plot((1:length(ISI))/dt/1e3,ISI,'k')


%% USE OU Process
tau = 1; % msec
ISI_OU = ISI; 
inp_sig = zeros(size(ISI)); ETA = inp_sig;
N_tau = sqrt(2/tau);
k=1;
for t = dt:dt:T/dt
    inp_sig(k+1) = rand_ISI(k);
    Einf = tau*N_tau*inp_sig(k)/sqrt(dt);
    ETA(k + 1) = Einf + (ETA(k) - Einf)*exp(-dt/tau);
    k = k+1;
end
ISI_OU = mu_ISI + std_ISI*ETA;
ISI_OU(ISI_OU<=threshold_min_ISI) = threshold_min_ISI;

stim_OU = zeros(floor(T/dt * 1e3),1);
stim_OU(floor(cumsum(ISI_OU/dt))) = 1;
stim_OU(floor(T/dt * 1e3):end) = 0; stim_OU = stim_OU(1:floor(T/dt * 1e3));

% figure; plot(dt:T*1e3/dt,max(ISI_OU)*stim_OU)
%hold on, plot((1:length(ISI))/dt/1e3,ISI,'b')

% figure; plot((1:length(ISI_OU))/dt/1e3,ISI_OU,'k')


end