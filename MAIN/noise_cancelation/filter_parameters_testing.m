%% Finding optimal parameters for each filter
close all;clear;clc;
%% Signal source
% filename = 'data/sample.mp3';
% [signal,Fsignal] = audioread(filename);
% signal = signal((3000:13000),1);
% N = length(signal);

N = 10000;
signal = sin((1:N)*0.05*pi)';
%% Paramters
noise_power = -10; % Noise
M = 100; % Filter order
%% Test LMS filter
mu_LMS = [0.01 0.05 0.1];
%% Filter input and filtering process (do 100 time and take average of se)
ase_LMS = zeros(N,1,length(mu_LMS));
e_LMS = zeros(N,1,length(mu_LMS));
y_LMS = zeros(N,1,length(mu_LMS));
for param = 1:length(mu_LMS)
    loop_count = 100;
    for loop = 1:loop_count
        % Artificial noise generation
        noise = wgn(1, N,noise_power)';
        % noise2 = noise/2 + delayseq(noise,0.5/Fs)*2;
        noise2 = noise/2 + delayseq(noise,0.01)*2;
        % Combine signal and noise to create input for filter
        d = signal + noise2;
        x = noise;
        %Filter params are in filter specific files
        [e_LMS(:,:,param), y_LMS(:,:,param), se_LMS] = LMS(d, x, M, signal, mu_LMS(param)); 
        ase_LMS(:,:,param) = ase_LMS(:,:,param) + se_LMS;
    end
    ase_LMS(:,:,param) = ase_LMS(:,:,param)/loop_count;
end
%% Test NLMS filter
mu_NLMS = [0.01 0.05 0.1];
theta_NLMS = 0.1;
%% Filter input and filtering process (do 100 time and take average of se)
ase_NLMS = zeros(N,1,length(mu_NLMS));
e_NLMS = zeros(N,1,length(mu_NLMS));
y_NLMS = zeros(N,1,length(mu_NLMS));
for param = 1:length(mu_NLMS)
    loop_count = 100;
    for loop = 1:loop_count
        % Artificial noise generation
        noise = wgn(1, N,noise_power)';
        % noise2 = noise/2 + delayseq(noise,0.5/Fs)*2;
        noise2 = noise/2 + delayseq(noise,0.01)*2;
        % Combine signal and noise to create input for filter
        d = signal + noise2;
        x = noise;
        %Filter params are in filter specific files
        [e_NLMS(:,:,param), y_NLMS(:,:,param), se_NLMS] = NLMS(d, x, M, signal, mu_NLMS(param), theta_NLMS); 
        ase_NLMS(:,:,param) = ase_NLMS(:,:,param) + se_NLMS;
    end
    ase_NLMS(:,:,param) = ase_NLMS(:,:,param)/loop_count;
end
%% Plotting
figure()
subplot(3,4,1)
plot((1:length(signal)),signal);
xlabel('sample');
title('Tin hieu goc d(n)');
subplot(3,4,2)
plot((1:length(d)),d);
xlabel('sample');
title('Tin hieu co nhieu x(n)');

% LMS
subplot(3,4,5)
hold on
for i = 1:length(mu_LMS)
    plot((1:length(y_LMS(:,:,1))),y_LMS(:,:,i));
end
hold off
legendStrings = "mu LMS = " + string(mu_LMS);
legend(legendStrings)
xlabel('iteration');
title('LMS y(n)');

subplot(3,4,6)
hold on
for i = 1:length(mu_LMS)
    plot((1:length(e_LMS(:,:,1))),e_LMS(:,:,i));
end
hold off
legendStrings = "mu LMS = " + string(mu_LMS);
legend(legendStrings)
xlabel('iteration');
title('LMS e(n)');

subplot(3,4,7)
hold on
for i = 1:length(mu_LMS)
    plot((1:length(e_LMS(:,:,1))),e_LMS(:,:,i)-signal);
end
hold off
legendStrings = "mu LMS = " + string(mu_LMS);
legend(legendStrings)
xlabel('iteration');
title('Sai so giua tin hieu goc va tin hieu qua bo loc LMS');

subplot(3,4,8)
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
subplot(3,4,9)
hold on
for i = 1:length(mu_NLMS)
    plot((1:length(y_NLMS(:,:,1))),y_NLMS(:,:,i));
end
hold off
legendStrings = "mu NLMS = " + string(mu_NLMS);
legend(legendStrings)
xlabel('iteration');
title('NLMS y(n)');

subplot(3,4,10)
hold on
for i = 1:length(mu_NLMS)
    plot((1:length(e_NLMS(:,:,1))),e_NLMS(:,:,i));
end
hold off
legendStrings = "mu NLMS = " + string(mu_NLMS);
legend(legendStrings)
xlabel('iteration');
title('NLMS e(n)');

subplot(3,4,11)
hold on
for i = 1:length(mu_NLMS)
    plot((1:length(e_NLMS(:,:,1))),e_NLMS(:,:,i)-signal);
end
hold off
legendStrings = "mu NLMS = " + string(mu_NLMS);
legend(legendStrings)
xlabel('iteration');
title('Sai so giua tin hieu goc va tin hieu qua bo loc NLMS');

subplot(3,4,12)
hold on
for i = 1:length(mu_NLMS)
    plot((1:length(ase_NLMS(:,:,1))),ase_NLMS(:,:,i));
end
hold off
legendStrings = "mu NLMS = " + string(mu_NLMS);
legend(legendStrings)
xlabel('iteration');
title('SE (Learning curve) cua bo loc NLMS');

savefig('figure/filter_parameters.fig');
