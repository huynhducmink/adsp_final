% AD for noise cancellation
close all;clear;clc;

filename = 'data/sample.mp3';
[y,Fs] = audioread(filename);
y = y(:,1);
N = length(y);

SNR = 30;
noise = wgn(1, length(y),SNR)';
noise2 = noise/2 + delayseq(noise,0.5/Fs)*2;

d = y + noise2;
x = noise;

M = 50;
mu = 0.001; % LMS
mu2 = 0.001; % NLMS
theta = 0.01;
delta = 0.1; % RLS
lambda = 0.99;

[e1, y1] = LMS(d, x, mu, M);
[e2, y2] = NLMS(d, x, mu2, M, theta);
[e3, y3] = RLS(d, x, delta, lambda, M);

figure()

subplot(4,3,1)
plot((1:length(d)),d);
xlabel('time');
title('Tin hieu goc d(n)');
subplot(4,3,2)
plot((1:length(x)),x);
xlabel('time');
title('Tin hieu co nhieu x(n)');

subplot(4,3,4)
plot((1:length(y1)),y1);
xlabel('time');
title('LMS y(n)');
subplot(4,3,5)
plot((1:length(e1)),e1);
xlabel('time');
title('LMS e(n)');
subplot(4,3,6)
plot((1:length(e1)),e1-y);
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
plot((1:length(e2)),e2-y);
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
plot((1:length(e3)),e3-y);
xlabel('time');
title('Diff between input and outputs RLS');

