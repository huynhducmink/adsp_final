%% Adaptive filter for noise cancellation
%{ 
-   MSE calculate as (error-signal)^2, calculate multiple independent run
-   Try a lattice filter (DONE) (LMS_latt.m file)
-   Test convergence speed and error with different filter parameters
-   Test noise cancelation without noise source (apply delay to the desired
signal)
-   Calculate other parameter (MSE, SNR?) read Simulation_and_Performance_Analysis_of_Adaptive_Filter_in_Noise_Cancellation
-   Test with real life data (find sample data from research paper)
-   Test uncollerated noise in d/x
%}
close all;clear;clc;

%% Signal source

% filename = 'data/sample.mp3';
% [signal,Fsignal] = audioread(filename);
% signal = signal((3000:13000),1);
% N = length(signal);

N = 2000;
signal = sin((1:N)*0.05*pi)';

%% Paramters
SNR = -0; % Noise
M = 20; % Filter order

%% Filter input and filtering process (do 10 time and take average of se)
ase_LMS = zeros(N,1);
ase_NLMS = zeros(N,1);
ase_RLS = zeros(N,1);
loop_count = 200;
for loop = 1:loop_count
    disp(loop);
    % Artificial noise generation
    noise = wgn(1, N,SNR)';
    % noise2 = noise/2 + delayseq(noise,0.5/Fs)*2;
    noise2 = noise/2 + delayseq(noise,0.01)*2;
    % Combine signal and noise to create input for filter
    d = signal + noise2;
    x = noise;
    %Filter params are in filter specific files
    [e_LMS, y_LMS, se_LMS] = LMS(d, x, M, signal); 
    %output: error, filter output and square error between e and signal (as e
    %converge to signal)
    [e_NLMS, y_NLMS, se_NLMS] = NLMS(d, x, M, signal);
    [e_RLS, y_RLS, se_RLS] = RLS(d, x, M, signal);
 
    ase_LMS = ase_LMS + se_LMS;
    ase_NLMS = ase_NLMS + se_NLMS;
    ase_RLS = ase_RLS + se_RLS;
end
se_LMS = ase_LMS/loop_count;
se_NLMS = ase_NLMS/loop_count;
se_RLS = ase_RLS/loop_count;
%% Plotting
figure()
subplot(4,4,1)
plot((1:length(signal)),signal);
xlabel('sample');
title('Tin hieu goc d(n)');
subplot(4,4,2)
plot((1:length(d)),d);
xlabel('sample');
title('Tin hieu co nhieu x(n)');

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

savefig('figure/NoiseCancellation.fig');
