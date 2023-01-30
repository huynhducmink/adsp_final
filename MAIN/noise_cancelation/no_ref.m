%% Adaptive noise cancellation without refference signal (only appliable for periodic noise)
close all;clear;clc;
%% Signal source
filename = 'data/f2bjrop1.0.wav';
[signal,Fsignal] = audioread(filename);
% signal = signal((3000:13000),1);
N = length(signal);

% N = 10000;
% signal = sin((1:N)*0.05*pi)';
%% Paramters
M = 30; % Filter order
loop_count = 10;
%% Filter parameter
%LMS filter
mu_LMS = 0.01;
%NLMS filter
mu_NLMS = 0.05;
theta_NLMS = 0.01;
%RLS filter
delta_RLS = 0.1;
lambda_RLS = 0.9999;
%LMS lattice filter
mu_LMS_latt = 0.001;
%% Filter input and filtering process (do 50 time and take average of se)
ase_LMS = zeros(N,1);
ase_NLMS = zeros(N,1);
ase_RLS = zeros(N,1);
ase_LMS_latt = zeros(N,1);
f = waitbar(0,'Initializing','Name','No reference noise cancelation');
for loop = 1:loop_count
    waitbar(loop/loop_count,f,[num2str(loop),'/',num2str(loop_count)])
    % Artificial noise generation
    d = signal + sin(2*pi*1000/Fsignal*(1:N))';
    x = delayseq(d,2);
    %Filter params are in filter specific files
    [e_LMS, y_LMS, se_LMS] = LMS(d, x, M, signal, mu_LMS); 
    %output: error, filter output and square error between e and signal (as e
    %converge to signal)
    [e_NLMS, y_NLMS, se_NLMS] = NLMS(d, x, M, signal, mu_NLMS, theta_NLMS);
    [e_RLS, y_RLS, se_RLS] = RLS(d, x, M, signal, delta_RLS, lambda_RLS);
    [e_LMS_latt, y_LMS_latt, se_LMS_latt] = LMS_latt(d, x, M, signal, mu_LMS_latt); 
 
    ase_LMS = ase_LMS + se_LMS;
    ase_NLMS = ase_NLMS + se_NLMS;
    ase_RLS = ase_RLS + se_RLS;
    ase_LMS_latt = ase_LMS_latt + se_LMS_latt;
end
close(f)
se_LMS = mag2db(ase_LMS/loop_count);
se_NLMS = mag2db(ase_NLMS/loop_count);
se_RLS = mag2db(ase_RLS/loop_count);
se_LMS_latt = mag2db(ase_LMS_latt/loop_count);
%% Plotting
figure()
subplot(5,4,1)
plot((1:length(signal)),signal);
xlabel('sample');
title('Tin hieu goc');
subplot(5,4,2)
plot((1:length(d)),d);
xlabel('sample');
title('Tin hieu desired d(n)');
subplot(5,4,3)
plot((1:length(x)),x);
xlabel('sample');
title('Tin hieu reference x(n)');

subplot(5,4,5)
plot((1:length(y_LMS)),y_LMS);
xlabel('iteration');
title('LMS y(n)');
subplot(5,4,6)
plot((1:length(e_LMS)),e_LMS);
xlabel('iteration');
title('LMS e(n)');
subplot(5,4,7)
plot((1:length(e_LMS)),e_LMS-signal);
xlabel('iteration');
title('Sai so giua tin hieu goc va tin hieu qua bo loc LMS');
subplot(5,4,8)
plot((1:length(se_LMS)),se_LMS);
xlabel('iteration');
title('SE (Learning curve) cua bo loc LMS');

subplot(5,4,9)
plot((1:length(y_NLMS)),y_NLMS);
xlabel('iteration');
title('NLMS y(n)');
subplot(5,4,10)
plot((1:length(e_NLMS)),e_NLMS);
xlabel('iteration');
title('NLMS e(n)');
subplot(5,4,11)
plot((1:length(e_NLMS)),e_NLMS-signal);
xlabel('iteration');
title('Sai so giua tin hieu goc va tin hieu qua bo loc NLMS');
subplot(5,4,12)
plot((1:length(se_NLMS)),se_NLMS);
xlabel('iteration');
title('SE (Learning curve) cua bo loc NLMS');

subplot(5,4,13)
plot((1:length(y_RLS)),y_RLS);
xlabel('iteration');
title('RLS y(n)');
subplot(5,4,14)
plot((1:length(e_RLS)),e_RLS);
xlabel('iteration');
title('RLS e(n)');
subplot(5,4,15)
plot((1:length(e_RLS)),e_RLS-signal);
xlabel('iteration');
title('Sai so giua tin hieu goc va tin hieu qua bo loc RLS');
subplot(5,4,16)
plot((1:length(se_RLS)),se_RLS);
xlabel('iteration');
title('SE (Learning curve) cua bo loc RLS');

subplot(5,4,17)
plot((1:length(y_LMS_latt)),y_LMS_latt);
xlabel('iteration');
title('LMS lattice y(n)');
subplot(5,4,18)
plot((1:length(e_LMS_latt)),e_LMS_latt);
xlabel('iteration');
title('LMS lattice e(n)');
subplot(5,4,19)
plot((1:length(e_LMS_latt)),e_LMS_latt-signal);
xlabel('iteration');
title('Sai so giua tin hieu goc va tin hieu qua bo loc LMS lattice');
subplot(5,4,20)
plot((1:length(se_LMS_latt)),se_LMS_latt);
xlabel('iteration');
title('SE (Learning curve) cua bo loc LMS lattice');

savefig('figure/no_ref2.fig');

mse1 = mag2db(calMSE(d,signal));
fprintf('Starter script');
fprintf('\nMSE value of signal with noise: %f',mse1);
mse2 = mag2db(calMSE(e_LMS,signal));
fprintf('\nMSE value of adaptive filter output: %f',mse2);