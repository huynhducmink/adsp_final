% Adaptive filter for noise cancellation
% Calculate MSE for each M iterations
% test uncollerated noise in d/x
% structure of lattice filter
close all;clear;clc;

% filename = 'data/sample.mp3';
% [y,Fs] = audioread(filename);
% y = y((3000:103000),1);
% N = length(y);
N = 10000;
y = sin((1:N)*0.05*pi)';

SNR = -10;
noise = wgn(1, length(y),SNR)';
% noise2 = noise/2 + delayseq(noise,0.5/Fs)*2;
noise2 = noise/2 + delayseq(noise,0.01)*2;

d = y + noise2;
x = noise;

M = 10; % Filter order
%Filter params are in filter specific files

[e1, y1, se1] = LMS(d, x, M);
[e2, y2, se2] = NLMS(d, x, M);
[e3, y3, se3] = RLS(d, x, M);

figure()

subplot(4,4,1)
plot((1:length(y)),y);
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
plot((1:length(e1)),e1-y);
xlabel('iteration');
title('Sai so giua tin hieu goc va tin hieu qua bo loc LMS');
subplot(4,4,8)
semilogy((1:length(se1)),se1);
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
plot((1:length(e2)),e2-y);
xlabel('iteration');
title('Sai so giua tin hieu goc va tin hieu qua bo loc NLMS');
subplot(4,4,12)
semilogy((1:length(se2)),se2);
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
plot((1:length(e3)),e3-y);
xlabel('iteration');
title('Sai so giua tin hieu goc va tin hieu qua bo loc RLS');
subplot(4,4,16)
semilogy((1:length(se3)),se3);
xlabel('iteration');
title('SE (Learning curve) cua bo loc RLS');

savefig('figure/NoiseCancellation.fig');
