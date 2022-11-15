close all;clear;clc;

fs = 80;
t = 0:1/fs:25;
noise = wgn(1, length(t),-10)';
d = cos(2*pi*t*2.625)';
x = noise + d;

mu = 0.001;
mu2 = 0.001;
a = 0.1;
lamda = 0.999;
M = 40;

tic
[e1, y1, w1] = LMS(d, x, mu, M);
toc
tic
[e3, y3, w3] = RLS(d, x,lamda,M);
toc


figure()
subplot(3,2,1)
plot([1:length(d)]/fs,d);
xlabel('time');
title('Tin hieu goc d(n)');
subplot(3,2,2)
plot([1:length(x)]/fs,x);
xlabel('time');
title('Tin hieu co nhieu x(n)');
subplot(3,2,3)
plot([1:length(y1)]/fs,y1);
xlabel('time');
title('LMS y(n)');
subplot(3,2,4)
plot([1:length(e1)]/fs,e1);
xlabel('time');
title('LMS e(n)');
subplot(3,2,5)
plot([1:length(y3)]/fs,y3);
xlabel('time');
title('RLS y(n)');
subplot(3,2,6)
plot([1:length(e3)]/fs,e3);
xlabel('time');
title('RLS e(n)');

% savefig ('./figures/Result.fig')