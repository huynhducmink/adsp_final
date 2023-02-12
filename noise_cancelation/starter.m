%% Default LMS filter structure (demo signal, demo noise, filter order, convergence speed, learning curve demo, evaluation parameter demo)
close all;clear;clc;
%% Signal source
N = 2000;
signal = sin((1:N)*0.05*pi)';
%% Paramters
noise_power = 0; % Noise
M = 5; % Filter order
%% Filter parameter
%LMS filter
mu_LMS = 0.003;
%% Filter input and filtering process
ase_LMS = zeros(N,1);
loop_count = 100;
f = waitbar(0,'Initializing','Name','Starter demo');
tic
for loop = 1:loop_count
    waitbar(loop/loop_count,f,[num2str(loop),'/',num2str(loop_count)])
    % Artificial noise generation
    noise = wgn(N, 1,noise_power);
    noise2 = delayseq(noise,0);
    % Combine signal and noise to create input for filter
    d = signal + noise;
    x = noise2;
    %Filter params are in filter specific files
    [e_LMS, y_LMS, se_LMS] = LMS(d, x, M, signal, mu_LMS); 
    %output: error, filter output and square error between e and signal (as e
    %converge to signal)
    ase_LMS = ase_LMS + se_LMS;
end
toc
close(f)
ase_LMS = ase_LMS/loop_count;
ase_LMS = mag2db(ase_LMS);
%% Plotting
figure()
set(gcf,'WindowState','maximized');
subplot(2,4,1)
plot((1:length(signal)),signal);
xlabel('sample');
title('Tin hieu goc');
subplot(2,4,2)
plot((1:length(d)),d);
xlabel('sample');
title('Tin hieu desired d(n)');
subplot(2,4,3)
plot((1:length(x)),x);
xlabel('sample');
title('Tin hieu reference x(n)');

subplot(2,4,5)
plot((1:length(y_LMS)),y_LMS);
xlabel('iteration');
title('LMS y(n)');
subplot(2,4,6)
plot((1:length(e_LMS)),e_LMS);
xlabel('iteration');
title('LMS e(n)');
subplot(2,4,7)
plot((1:length(e_LMS)),e_LMS-signal);
xlabel('iteration');
title('Sai so giua tin hieu goc va tin hieu qua bo loc LMS');
subplot(2,4,8)
plot((1:length(ase_LMS)),ase_LMS);
xlabel('iteration');
title('SE (Learning curve) cua bo loc LMS (trung binh 100 lan)');

sgtitle('Starter demo');
saveas(gcf,'figure/starter.png');
savefig('figure/starter.fig');

mse1 = mag2db(calMSE(d,signal)); %mse(db) = 20*10^mse(times)
fprintf('Starter script');
fprintf('\nMSE value of signal with noise: %f',mse1);
mse2 = mag2db(calMSE(e_LMS,signal));
fprintf('\nMSE value of adaptive filter output: %f',mse2);
mse3 = mag2db(calMSE(e_LMS(1000:end),signal(1000:end)));
fprintf('\nMSE value of AF output after converge (1000 sample): %f',mse3);
fprintf('\n========================================\n');