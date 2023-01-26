close all;clear;clc;
params = gyroparams;

% Generate N samples at a sampling rate of Fs with a sinusoidal frequency
% of Fc.
N = 10000;
Fs = 100;
Fc = 0.25;

t = (0:(1/Fs):((N-1)/Fs)).';
acc = zeros(N, 3);
angvel = zeros(N, 3);
angvel(:,1) = sin(2*pi*Fc*t);

rng('default')

imu = imuSensor('SampleRate', Fs, 'Gyroscope', params);
imu.Gyroscope.NoiseDensity = 1.25e-2; % (rad/s)/sqrt(Hz)
imu.Gyroscope.BiasInstability = 2.0e-2; % rad/s
imu.Gyroscope.RandomWalk = 1e-1; % (rad/s)*sqrt(Hz)

imu.Gyroscope

[~, gyroData] = imu(acc, angvel);

% figure
% plot(t, angvel(:,1), '--', t, gyroData(:,1), t, gyroData(:,2), t, gyroData(:,3))
% xlabel('Time (s)')
% ylabel('Angular Velocity (rad/s)')
% title('Ideal Gyroscope Data')
% legend('x (ground truth)', 'x (gyroscope)', 'y (gyroscope)', 'z (gyroscope)')

d = gyroData(:,1);
whitenoise = wgn(length(gyroData),1,-20);
brownianmotion = wfbm(0.7,length(gyroData))'./5000;
x = whitenoise + brownianmotion;
[e_LMS, y_LMS, se_LMS] = LMS(d, x, 50, angvel(:,1), 0.01); 

figure()

subplot(2,4,1)
plot((1:length(d)),d);
xlabel('sample');
title('d(n)');
subplot(2,4,2)
plot((1:length(x)),x);
xlabel('sample');
title('x(n)');

subplot(2,4,5)
plot((1:length(y_LMS)),y_LMS);
xlabel('iteration');
title('LMS y(n)');
subplot(2,4,6)
plot((1:length(e_LMS)),e_LMS);
xlabel('iteration');
title('LMS e(n)');
subplot(2,4,7)
plot((1:length(e_LMS)),e_LMS-angvel(:,1),(1:length(e_LMS)),d-angvel(:,1));
xlabel('iteration');
title('Sai so giua tin hieu goc va tin hieu qua bo loc LMS');
legend('e-goc','d-goc');
subplot(2,4,8)
plot((1:length(se_LMS)),se_LMS);
xlabel('iteration');
title('SE (Learning curve) cua bo loc LMS');
