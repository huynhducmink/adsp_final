%% Adaptive filter for noise cancellation
%{ 
-   MSE calculate as (error-signal)^2, calculate multiple independent run
-   Each algorithm is used with a traversal FIR filter and a lattice FIR filter
-   Test noise cancelation without noise source (apply delay to the desired
signal)
-   Calculate other parameter (MSE, SNR?) read Simulation_and_Performance_Analysis_of_Adaptive_Filter_in_Noise_Cancellation
-   Test with real life data (find sample data from research paper)
-   Test uncollerated noise in d/x
%}
close all;clear;clc;

%% Signal source
filename = 'data/sample.mp3';
[signal,Fsignal] = audioread(filename);
signal = signal((3000:13000),1);
N = length(signal);
% N = 10000;
% y = sin((1:N)*0.05*pi)';

%% Noise source
SNR = -10;
noise = wgn(1, length(signal),SNR)';
% noise2 = noise/2 + delayseq(noise,0.5/Fs)*2;
noise2 = noise/2 + delayseq(noise,0.01)*2;

%% Filter input and filtering process
d = signal + noise2;
x = noise;
M = 10; % Filter order
%Filter params are in filter specific files
[e1, y1, se1] = LMS(d, x, M, signal); 
%output: error, filter output and square error between e and signal
[e2, y2, se2] = NLMS(d, x, M, signal);
[e3, y3, se3] = RLS(d, x, M, signal);

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
plot((1:length(y1)),y1);
xlabel('iteration');
title('LMS y(n)');
subplot(4,4,6)
plot((1:length(e1)),e1);
xlabel('iteration');
title('LMS e(n)');
subplot(4,4,7)
plot((1:length(e1)),e1-signal);
xlabel('iteration');
title('Sai so giua tin hieu goc va tin hieu qua bo loc LMS');
subplot(4,4,8)
plot((1:length(se1)),se1);
xlabel('iteration');
title('SE (Learning curve) cua bo loc LMS');

subplot(4,4,9)
plot((1:length(y2)),y2);
xlabel('iteration');
title('NLMS y(n)');
subplot(4,4,10)
plot((1:length(e2)),e2);
xlabel('iteration');
title('NLMS e(n)');
subplot(4,4,11)
plot((1:length(e2)),e2-signal);
xlabel('iteration');
title('Sai so giua tin hieu goc va tin hieu qua bo loc NLMS');
subplot(4,4,12)
plot((1:length(se2)),se2);
xlabel('iteration');
title('SE (Learning curve) cua bo loc NLMS');

subplot(4,4,13)
plot((1:length(y3)),y3);
xlabel('iteration');
title('RLS y(n)');
subplot(4,4,14)
plot((1:length(e3)),e3);
xlabel('iteration');
title('RLS e(n)');
subplot(4,4,15)
plot((1:length(e3)),e3-signal);
xlabel('iteration');
title('Sai so giua tin hieu goc va tin hieu qua bo loc RLS');
subplot(4,4,16)
plot((1:length(se3)),se3);
xlabel('iteration');
title('SE (Learning curve) cua bo loc RLS');

savefig('figure/NoiseCancellation.fig');
