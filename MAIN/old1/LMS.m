function [e, y, mse] = LMS(SNR, mu, M, loops, file)
Ns = 100*M;
Nl = length(file);
mse = zeros(loops,1);
w1 = zeros(M,1);

for i = 1:loops
    xx = zeros(M,1);
    y = zeros(Ns,1);
    e = zeros(Ns,1);
    noise1 = wgn(1, Ns, SNR)';
    d = rand(Ns,1)/5 + noise1/2 + delayseq(noise1,0.5)*2;
    x = noise1;
for n = 1:Ns
    xx = [xx(2:M);x(n)];
    y(n) = w1' * xx;
    e(n) = d(n) - y(n);
    w1 = w1 + mu * e(n) * xx;
end
    mse(i,1) = calMSE(y,d);
end
    xx = zeros(M,1);
    y = zeros(Nl,1);
    e = zeros(Nl,1);
    noise2 = wgn(1, Nl, SNR)';
    filewithnoise = file + noise2/2 + delayseq(noise2,0.5)*2;
    d = filewithnoise;
    x = noise2;
for n = 1:Nl
    xx = [xx(2:M);x(n)];
    y(n) = w1' * xx;
    e(n) = d(n) - y(n);
end
end