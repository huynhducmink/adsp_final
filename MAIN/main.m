close all;clear;clc;

filename = 'sample.mp3';
[y,Fs] = audioread(filename,[1,3000]);
y = y((2000:3000),:);
N = length(y);
d = y(:,1);
SNR = 30;

noise = wgn(1, length(y),SNR)';
% LMS diverge at SNR = -5dB
x = noise + d;
noise2 = noise/2 + delayseq(noise,0.5/Fs)*2;

mu = 0.01;
theta = 0.01;
M = 50;
loops = 100;
delta = 1;
lambda = 0.99;

[e1, y1, mse1] = LMS(x, noise2, mu, M, loops);
[e2, y2, mse2] = NLMS(x, noise2, mu, M, theta, loops);
[e3, y3, mse3] = RLS(x, noise2, delta, lambda, M, loops);

figure()

subplot(4,3,1)
plot([1:length(d)],d);
xlabel('time');
title('Tin hieu goc d(n)');
subplot(4,3,2)
plot([1:length(x)],x);
xlabel('time');
title('Tin hieu co nhieu x(n)');

subplot(4,3,4)
plot([1:length(y1)],y1);
xlabel('time');
title('LMS y(n)');
subplot(4,3,5)
plot([1:length(e1)],e1);
xlabel('time');
title('LMS e(n)');
subplot(4,3,6)
plot([1:length(e1)],e1-d);
xlabel('time');
title('Diff between input and outputs LMS');

subplot(4,3,7)
plot([1:length(y2)],y2);
xlabel('time');
title('NLMS y(n)');
subplot(4,3,8)
plot([1:length(e2)],e2);
xlabel('time');
title('NLMS e(n)');
subplot(4,3,9)
plot([1:length(e2)],e2-d);
xlabel('time');
title('Diff between input and outputs NLMS');

subplot(4,3,10)
plot([1:length(y3)],y3);
xlabel('time');
title('RLS y(n)');
subplot(4,3,11)
plot([1:length(e3)],e3);
xlabel('time');
title('RLS e(n)');
subplot(4,3,12)
plot([1:length(e3)],e3-d);
xlabel('time');
title('Diff between input and outputs RLS');

subplot(4,3,3)
loglog([1:loops],mse1);
hold on;
loglog([1:loops],mse2);
hold on;
loglog([1:loops],mse3);
hold off;
legend('LMS mse','NLMS mse','RLS mse');
xlabel('iteration');
title('MSE');
