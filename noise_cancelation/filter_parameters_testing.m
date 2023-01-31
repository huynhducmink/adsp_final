%% Finding optimal parameters for each filter
close all;clear;clc;
%% Signal source
% filename = 'data/sample.mp3';
% filename = 'data/f2bjrop1.0.wav';
% [signal,Fsignal] = audioread(filename);
% signal = signal((3000:13000),1);
% N = length(signal);
N = 5000;
signal = sin((1:N)*0.05*pi)';
%% Paramters
noise_power = 0; % Noise
M = 10; % Filter order
loop_count = 50;
%% Test LMS filter
mu_LMS = [0.01 0.05 0.1];
%% Filter input and filtering process (do 50 time and take average of se)
ase_LMS = zeros(N,1,length(mu_LMS));
e_LMS = zeros(N,1,length(mu_LMS));
y_LMS = zeros(N,1,length(mu_LMS));
for param = 1:length(mu_LMS)
    for loop = 1:loop_count
        % Artificial noise generation
        noise = wgn(1, N,noise_power)';
        % noise2 = noise/2 + delayseq(noise,0.5/Fs)*2;
        noise2 = noise/2 + delayseq(noise,5)*2;
        % Combine signal and noise to create input for filter
        d = signal + noise2;
        x = noise;
        %Filter params are in filter specific files
        [e_LMS(:,:,param), y_LMS(:,:,param), se_LMS] = LMS(d, x, M, signal, mu_LMS(param)); 
        ase_LMS(:,:,param) = ase_LMS(:,:,param) + se_LMS;
    end
    ase_LMS(:,:,param) = ase_LMS(:,:,param)/loop_count;
    ase_LMS(:,:,param) = mag2db(ase_LMS(:,:,param));
end
%% Test NLMS filter
mu_NLMS = [0.01 0.05 0.1];
theta_NLMS = 0.01;
%% Filter input and filtering process (do 100 time and take average of se)
ase_NLMS = zeros(N,1,length(mu_NLMS));
e_NLMS = zeros(N,1,length(mu_NLMS));
y_NLMS = zeros(N,1,length(mu_NLMS));
for param = 1:length(mu_NLMS)
    for loop = 1:loop_count
        % Artificial noise generation
        noise = wgn(1, N,noise_power)';
        % noise2 = noise/2 + delayseq(noise,0.5/Fs)*2;
        noise2 = noise/2 + delayseq(noise,5)*2;
        % Combine signal and noise to create input for filter
        d = signal + noise2;
        x = noise;
        %Filter params are in filter specific files
        [e_NLMS(:,:,param), y_NLMS(:,:,param), se_NLMS] = NLMS(d, x, M, signal, mu_NLMS(param), theta_NLMS); 
        ase_NLMS(:,:,param) = ase_NLMS(:,:,param) + se_NLMS;
    end
    ase_NLMS(:,:,param) = ase_NLMS(:,:,param)/loop_count;
    ase_NLMS(:,:,param) = mag2db(ase_NLMS(:,:,param));
end
%% Test RLS filter
delta_RLS = [0.001 0.01 0.05 0.1];
lambda_RLS = 0.9999;
%% Filter input and filtering process (do 100 time and take average of se)
ase_RLS = zeros(N,1,length(delta_RLS));
e_RLS = zeros(N,1,length(delta_RLS));
y_RLS = zeros(N,1,length(delta_RLS));
for param = 1:length(delta_RLS)
    for loop = 1:loop_count
        % Artificial noise generation
        noise = wgn(1, N,noise_power)';
        % noise2 = noise/2 + delayseq(noise,0.5/Fs)*2;
        noise2 = noise/2 + delayseq(noise,5)*2;
        % Combine signal and noise to create input for filter
        d = signal + noise2;
        x = noise;
        %Filter params are in filter specific files
        [e_RLS(:,:,param), y_RLS(:,:,param), se_RLS] = RLS(d, x, M, signal, delta_RLS(param), lambda_RLS); 
        ase_RLS(:,:,param) = ase_RLS(:,:,param) + se_RLS;
    end
    ase_RLS(:,:,param) = ase_RLS(:,:,param)/loop_count;
    ase_RLS(:,:,param) = mag2db(ase_RLS(:,:,param));
end
%% Test LMS lattice filter
mu_LMS_latt = [0.001 0.005 0.01];
%% Filter input and filtering process (do 100 time and take average of se)
ase_LMS_latt = zeros(N,1,length(mu_LMS_latt));
e_LMS_latt = zeros(N,1,length(mu_LMS_latt));
y_LMS_latt = zeros(N,1,length(mu_LMS_latt));
for param = 1:length(mu_LMS_latt)
    for loop = 1:loop_count
        % Artificial noise generation
        noise = wgn(1, N,noise_power)';
        % noise2 = noise/2 + delayseq(noise,0.5/Fs)*2;
        noise2 = noise/2 + delayseq(noise,5)*2;
        % Combine signal and noise to create input for filter
        d = signal + noise2;
        x = noise;
        %Filter params are in filter specific files
        [e_LMS_latt(:,:,param), y_LMS_latt(:,:,param), se_LMS_latt] = LMS_latt(d, x, M, signal, mu_LMS_latt(param)); 
        ase_LMS_latt(:,:,param) = ase_LMS_latt(:,:,param) + se_LMS_latt;
    end
    ase_LMS_latt(:,:,param) = ase_LMS_latt(:,:,param)/loop_count;
    ase_LMS_latt(:,:,param) = mag2db(ase_LMS_latt(:,:,param));
end
%% Plotting
figure()
set(gcf,'WindowState','maximized');
subplot(5,4,1)
plot((1:length(signal)),signal);
xlabel('sample');
title('Tin hieu goc d(n)');
subplot(5,4,2)
plot((1:length(d)),d);
xlabel('sample');
title('Tin hieu co nhieu x(n)');

% LMS
subplot(5,4,5)
hold on
for i = 1:length(mu_LMS)
    plot((1:length(y_LMS(:,:,1))),y_LMS(:,:,i));
end
hold off
legendStrings = "mu LMS = " + string(mu_LMS);
legend(legendStrings)
xlabel('iteration');
title('LMS y(n)');

subplot(5,4,6)
hold on
for i = 1:length(mu_LMS)
    plot((1:length(e_LMS(:,:,1))),e_LMS(:,:,i));
end
hold off
legendStrings = "mu LMS = " + string(mu_LMS);
legend(legendStrings)
xlabel('iteration');
title('LMS e(n)');

subplot(5,4,7)
hold on
for i = 1:length(mu_LMS)
    plot((1:length(e_LMS(:,:,1))),e_LMS(:,:,i)-signal);
end
hold off
legendStrings = "mu LMS = " + string(mu_LMS);
legend(legendStrings)
xlabel('iteration');
title('Sai so giua tin hieu goc va tin hieu qua bo loc LMS');

subplot(5,4,8)
hold on
for i = 1:length(mu_LMS)
    plot((1:length(ase_LMS(:,:,1))),ase_LMS(:,:,i));
end
hold off
legendStrings = "mu LMS = " + string(mu_LMS);
legend(legendStrings)
xlabel('iteration');
title('SE (Learning curve) cua bo loc LMS');

%NLMS
subplot(5,4,9)
hold on
for i = 1:length(mu_NLMS)
    plot((1:length(y_NLMS(:,:,1))),y_NLMS(:,:,i));
end
hold off
legendStrings = "mu NLMS = " + string(mu_NLMS);
legend(legendStrings)
xlabel('iteration');
title('NLMS y(n)');

subplot(5,4,10)
hold on
for i = 1:length(mu_NLMS)
    plot((1:length(e_NLMS(:,:,1))),e_NLMS(:,:,i));
end
hold off
legendStrings = "mu NLMS = " + string(mu_NLMS);
legend(legendStrings)
xlabel('iteration');
title('NLMS e(n)');

subplot(5,4,11)
hold on
for i = 1:length(mu_NLMS)
    plot((1:length(e_NLMS(:,:,1))),e_NLMS(:,:,i)-signal);
end
hold off
legendStrings = "mu NLMS = " + string(mu_NLMS);
legend(legendStrings)
xlabel('iteration');
title('Sai so giua tin hieu goc va tin hieu qua bo loc NLMS');

subplot(5,4,12)
hold on
for i = 1:length(mu_NLMS)
    plot((1:length(ase_NLMS(:,:,1))),ase_NLMS(:,:,i));
end
hold off
legendStrings = "mu NLMS = " + string(mu_NLMS);
legend(legendStrings)
xlabel('iteration');
title('SE (Learning curve) cua bo loc NLMS');

% RLS
subplot(5,4,13)
hold on
for i = 1:length(delta_RLS)
    plot((1:length(y_RLS(:,:,1))),y_RLS(:,:,i));
end
hold off
legendStrings = "delta RLS = " + string(delta_RLS);
legend(legendStrings)
xlabel('iteration');
title('RLS y(n)');

subplot(5,4,14)
hold on
for i = 1:length(delta_RLS)
    plot((1:length(e_RLS(:,:,1))),e_RLS(:,:,i));
end
hold off
legendStrings = "delta RLS = " + string(delta_RLS);
legend(legendStrings)
xlabel('iteration');
title('RLS e(n)');

subplot(5,4,15)
hold on
for i = 1:length(delta_RLS)
    plot((1:length(e_RLS(:,:,1))),e_RLS(:,:,i)-signal);
end
hold off
legendStrings = "delta RLS = " + string(delta_RLS);
legend(legendStrings)
xlabel('iteration');
title('Sai so giua tin hieu goc va tin hieu qua bo loc RLS');

subplot(5,4,16)
hold on
for i = 1:length(delta_RLS)
    plot((1:length(ase_RLS(:,:,1))),ase_RLS(:,:,i));
end
hold off
legendStrings = "delta RLS = " + string(delta_RLS);
legend(legendStrings)
xlabel('iteration');
title('SE (Learning curve) cua bo loc RLS');

% LMS lattice
subplot(5,4,17)
hold on
for i = 1:length(mu_LMS_latt)
    plot((1:length(y_LMS_latt(:,:,1))),y_LMS_latt(:,:,i));
end
hold off
legendStrings = "mu LMS lattice = " + string(mu_LMS_latt);
legend(legendStrings)
xlabel('iteration');
title('LMS_lattice y(n)');

subplot(5,4,18)
hold on
for i = 1:length(mu_LMS_latt)
    plot((1:length(e_LMS_latt(:,:,1))),e_LMS_latt(:,:,i));
end
hold off
legendStrings = "mu LMS lattice = " + string(mu_LMS_latt);
legend(legendStrings)
xlabel('iteration');
title('LMS_lattice e(n)');

subplot(5,4,19)
hold on
for i = 1:length(mu_LMS_latt)
    plot((1:length(e_LMS_latt(:,:,1))),e_LMS_latt(:,:,i)-signal);
end
hold off
legendStrings = "mu LMS lattice = " + string(mu_LMS_latt);
legend(legendStrings)
xlabel('iteration');
title('Sai so giua tin hieu goc va tin hieu qua bo loc LMS lattice');

subplot(5,4,20)
hold on
for i = 1:length(mu_LMS_latt)
    plot((1:length(ase_LMS_latt(:,:,1))),ase_LMS_latt(:,:,i));
end
hold off
legendStrings = "mu LMS lattice = " + string(mu_LMS_latt);
legend(legendStrings)
xlabel('iteration');
title('SE (Learning curve) cua bo loc LMS lattice');

sgtitle('Testing optimal parameters for different types of filter')
saveas(gcf,'figure/filter_parameters.png');
savefig('figure/filter_parameters.fig');
