close all;clear;clc;

filename = 'data/sample.mp3';
[file,Fs] = audioread(filename);
file = file(:,1);
filelength = length(file);

SNR = -20;
% noise = wgn(1, filelength,SNR)';
% noise2 = noise/2 + delayseq(noise,0.5/Fs)*2;

M = 50; % filter stage
loops = 500; % training loop

mu = 0.001; % LMS param
mu2 = 0.001; % NLMS param
theta = 0.01;
delta = 1; % RLS param
lambda = 0.99;

[e1, y1, mse1] = LMS(SNR, mu, M, loops, file);
[e2, y2, mse2] = NLMS(SNR, mu2, M, theta, loops, file);
[e3, y3, mse3] = RLS(SNR, delta, lambda, M, loops, file);

figure()

subplot(4,3,1)
plot((1:length(file)),file);
xlabel('time');
title('Tin hieu goc d(n)');
% subplot(4,3,2)
% plot((1:length(noise2)),noise2);
% xlabel('time');
% title('Tin hieu co nhieu x(n)');

subplot(4,3,4)
plot((1:length(y1)),y1);
xlabel('time');
title('LMS y(n)');
subplot(4,3,5)
plot((1:length(e1)),e1);
xlabel('time');
title('LMS e(n)');
subplot(4,3,6)
plot((1:length(e1)),e1-file);
xlabel('time');
title('Diff between input and outputs LMS');

subplot(4,3,7)
plot((1:length(y2)),y2);
xlabel('time');
title('NLMS y(n)');
subplot(4,3,8)
plot((1:length(e2)),e2);
xlabel('time');
title('NLMS e(n)');
subplot(4,3,9)
plot((1:length(e2)),e2-file);
xlabel('time');
title('Diff between input and outputs NLMS');

subplot(4,3,10)
plot((1:length(y3)),y3);
xlabel('time');
title('RLS y(n)');
subplot(4,3,11)
plot((1:length(e3)),e3);
xlabel('time');
title('RLS e(n)');
subplot(4,3,12)
plot((1:length(e3)),e3-file);
xlabel('time');
title('Diff between input and outputs RLS');

subplot(4,3,3)
loglog((1:loops),mse1);
hold on;
loglog((1:loops),mse2);
hold on;
loglog((1:loops),mse3);
hold off;
legend('LMS mse','NLMS mse','RLS mse');
xlabel('iteration');
title('MSE');
