close all;clear;clc;

filename = 'sample/sample.mp3';
fid = fopen(filename, 'r');
file_read = fread(fid, [1 inf], 'uint8');
fclose(fid);
N = numel(file_read);
data = reshape(file_read,N,1);
bin=de2bi(data,'left-msb');
input=reshape(bin',numel(bin),1);

M = 256;
k = log2(M);

z=N;
while(rem(z,k))
    z=z+1;
    input(z,1)=0;
end

txSig = qammod(input,M,'InputType','bit','UnitAveragePower',true);
rxSig = awgn(txSig,20);
% cd = comm.ConstellationDiagram('ShowReferenceConstellation',false);
% cd(rxSig)

output = qamdemod(rxSig,M,'OutputType','bit','UnitAveragePower',true);
[numErrors,ber] = biterr(input,output);

% output_base10 = reshape(output,8,[])';
% base10 = bi2de(output_base10,'left-msb');
% data2 = reshape(base10,1,[]);
% filenameout = 'output.mp4';
% fid2 = fopen(filenameout,'w');
% fwrite(fid2,data2);
% fclose(fid2);

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
