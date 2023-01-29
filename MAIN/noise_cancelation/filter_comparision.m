%% Performance comparision between different type of filter
close all;clear;clc;
%% Signal source
% filename = 'data/sample.mp3';
filename = 'data/f2bjrop1.0.wav';
[signal,Fsignal] = audioread(filename);
% signal = signal((3000:13000),1);
N = length(signal);

% N = 10000;
% signal = sin((1:N)*0.05*pi)';
%% Paramters
noise_power = -0; % Noise
M = 100; % Filter order
%% Filter parameter
%LMS filter
mu_LMS = 0.001;
%NLMS filter
mu_NLMS = 0.01;
theta_NLMS = 0.1;
%RLS filter
delta_RLS = 0.01;
lambda_RLS = 0.9999;
%LMS lattice filter
mu_LMS_latt = 0.01;
%% Filter input and filtering process (do 100 time and take average of se)
ase_LMS = zeros(N,1);
ase_NLMS = zeros(N,1);
ase_RLS = zeros(N,1);
loop_count = 100;
f = waitbar(0,'Initializing','Name','Comparing different filter type');
for loop = 1:loop_count
    waitbar(loop/loop_count,f,[num2str(loop),'/',num2str(loop_count)])
    % Artificial noise generation
    noise = wgn(1, N,noise_power)';
    % noise2 = noise/2 + delayseq(noise,0.5/Fs)*2;
    noise2 = noise/2 + delayseq(noise,60)*2 + delayseq(noise,80)*4;
    % Combine signal and noise to create input for filter
%     d = signal + noise2/10;
%     x = noise + signal/20;
    d = signal + sin(2*pi*1000/Fsignal*(1:N))';
    x = delayseq(d,30);
    %Filter params are in filter specific files
    [e_LMS, y_LMS, se_LMS] = LMS(d, x, M, signal, mu_LMS); 
    %output: error, filter output and square error between e and signal (as e
    %converge to signal)
    [e_NLMS, y_NLMS, se_NLMS] = NLMS(d, x, M, signal, mu_NLMS, theta_NLMS);
    [e_RLS, y_RLS, se_RLS] = RLS(d, x, M, signal, delta_RLS, lambda_RLS);
 
    ase_LMS = ase_LMS + se_LMS;
    ase_NLMS = ase_NLMS + se_NLMS;
    ase_RLS = ase_RLS + se_RLS;
end
close(f)
se_LMS = ase_LMS/loop_count;
se_NLMS = ase_NLMS/loop_count;
se_RLS = ase_RLS/loop_count;
%% Plotting
figure()
subplot(4,4,1)
plot((1:length(signal)),signal);
xlabel('sample');
title('Tin hieu goc');
subplot(4,4,2)
plot((1:length(d)),d);
xlabel('sample');
title('Tin hieu desired d(n)');
subplot(4,4,3)
plot((1:length(x)),x);
xlabel('sample');
title('Tin hieu reference x(n)');

subplot(4,4,5)
plot((1:length(y_LMS)),y_LMS);
xlabel('iteration');
title('LMS y(n)');
subplot(4,4,6)
plot((1:length(e_LMS)),e_LMS);
xlabel('iteration');
title('LMS e(n)');
subplot(4,4,7)
plot((1:length(e_LMS)),e_LMS-signal);
xlabel('iteration');
title('Sai so giua tin hieu goc va tin hieu qua bo loc LMS');
subplot(4,4,8)
plot((1:length(se_LMS)),se_LMS);
xlabel('iteration');
title('SE (Learning curve) cua bo loc LMS');

subplot(4,4,9)
plot((1:length(y_NLMS)),y_NLMS);
xlabel('iteration');
title('NLMS y(n)');
subplot(4,4,10)
plot((1:length(e_NLMS)),e_NLMS);
xlabel('iteration');
title('NLMS e(n)');
subplot(4,4,11)
plot((1:length(e_NLMS)),e_NLMS-signal);
xlabel('iteration');
title('Sai so giua tin hieu goc va tin hieu qua bo loc NLMS');
subplot(4,4,12)
plot((1:length(se_NLMS)),se_NLMS);
xlabel('iteration');
title('SE (Learning curve) cua bo loc NLMS');

subplot(4,4,13)
plot((1:length(y_RLS)),y_RLS);
xlabel('iteration');
title('RLS y(n)');
subplot(4,4,14)
plot((1:length(e_RLS)),e_RLS);
xlabel('iteration');
title('RLS e(n)');
subplot(4,4,15)
plot((1:length(e_RLS)),e_RLS-signal);
xlabel('iteration');
title('Sai so giua tin hieu goc va tin hieu qua bo loc RLS');
subplot(4,4,16)
plot((1:length(se_RLS)),se_RLS);
xlabel('iteration');
title('SE (Learning curve) cua bo loc RLS');

savefig('figure/filter_comparision.fig');
