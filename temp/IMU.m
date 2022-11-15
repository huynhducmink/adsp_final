close all;clear;clc;

bag = rosbag('2022-06-17-13-44-21.bag');
bt = select(bag,'Topic','/hummingbird/imu');
msgs = readMessages(bt,'DataFormat','struct');
x_bag = cellfun(@(m) double(m.Orientation.X),msgs);
Fs = 100;
d = x_bag(1:1000);

noise = wgn(1, length(d),-370)';
x = noise + d;
noise2 = wgn(1, length(d),-400)' + [0;d(2:end)];

mu = 0.01;
M = 40;

% [e1, y1, w1] = LMS(d, x, mu, M);
[e1, y1] = LMS_mod(d, noise+noise2, mu, M);

figure()
subplot(2,2,1)
plot([1:length(d)],d);
xlabel('time');
title('Tin hieu goc d(n)');
subplot(2,2,2)
plot([1:length(noise)],noise);
xlabel('time');
title('Tin hieu co nhieu x(n)');
subplot(2,2,3)
plot([1:length(y1)],y1);
xlabel('time');
title('LMS y(n)');
subplot(2,2,4)
plot([1:length(e1)],e1);
xlabel('time');
title('LMS e(n)');

% 
% data = reshape(file_read,N,1);
% bin=de2bi(data,'left-msb');
% input=reshape(bin',numel(bin),1);
% 
% M = 256;
% k = log2(M);
% 
% z=N;
% while(rem(z,k))
%     z=z+1;
%     input(z,1)=0;
% end
% 
% txSig = qammod(input,M,'InputType','bit','UnitAveragePower',true);
% rxSig = awgn(txSig,20);
% % cd = comm.ConstellationDiagram('ShowReferenceConstellation',false);
% % cd(rxSig)
% 
% output = qamdemod(rxSig,M,'OutputType','bit','UnitAveragePower',true);
% [numErrors,ber] = biterr(input,output);
% 
% output_base10 = reshape(output,8,[])';
% base10 = bi2de(output_base10,'left-msb');
% data2 = reshape(base10,1,[]);
% filenameout = 'output.mp4';
% fid2 = fopen(filenameout,'w');
% fwrite(fid2,data2);
% fclose(fid2);
% 
% mu = 0.001;
% M = 40;
% [e1, y1, w1] = LMS(d, x, mu, M);
% 
% figure()
% subplot(2,2,1)
% plot([1:length(txSig)],txSig);
% xlabel('time');
% title('Tin hieu goc txSig');
% subplot(2,2,2)
% plot([1:length(rxSig)],rxSig);
% xlabel('time');
% title('Tin hieu co nhieu x(n)');
% subplot(2,2,3)
% plot([1:length(y1)]/fs,y1);
% xlabel('time');
% title('LMS y(n)');
% subplot(2,2,4)
% plot([1:length(e1)]/fs,e1);
% xlabel('time');
% title('LMS e(n)');
