close all;clear;clc;

filename = 'sample.mp3';
fid = fopen(filename, 'r');
file_read = fread(fid, [1 inf]);
fclose(fid);
N = numel(file_read);
data = reshape(file_read,N,1);
bin=de2bi(data,'left-msb');
input=reshape(bin',numel(bin),1);

M = 256;
k = log2(M);
% input = randi([0 1],1000*k,1);
% N = length(input);

z=N;
while(rem(z,k))
    z=z+1;
    input(z,1)=0;
end

% stem(input(1:1000),'filled');

txSig = qammod(input,M,'InputType','bit','UnitAveragePower',true);
rxSig = awgn(txSig,25);
cd = comm.ConstellationDiagram('ShowReferenceConstellation',false);
cd(rxSig)

output = qamdemod(rxSig,M,'OutputType','bit','UnitAveragePower',true);
% s = isequal(input,output);
[numErrors,ber] = biterr(input,output);

% mu = 0.001;
% [e, y, w] = LMS(txSig, rxSig, mu, 20);
% output2 = qamdemod(y,M,'OutputType','bit','UnitAveragePower',true);
% [numErrors2,ber2] = biterr(input,output2);
output_base10 = reshape(input',[],8);
base10 = bi2de(output_base10,'left-msb');
data2 = reshape(base10,1,[]);
filenameout = 'output.mp3';
fid2 = fopen(filenameout,'w');
fwrite(fid2,[1 inf]);
fclose(fid2);