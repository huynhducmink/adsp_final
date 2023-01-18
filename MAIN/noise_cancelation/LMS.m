function [e, y, se] = LMS(d, x, M, signal)

mu = 0.01;

Ns = length(d);
w1 = zeros(M,1); % Khoi tao bo loc

xx = zeros(M,1); % Tin hieu dua vao bo loc co do dai M
y = zeros(Ns,1); % Output cua bo loc
e = zeros(Ns,1); % Sai so giua output cua bo loc va tin hieu mong muon
% Trong truong hop ung dung noise cancellation, y tien den gia tri cua
% nhieu can loc, e tien den gia tri cua tin hieu goc
se = zeros(Ns,1); % Square error value beween error and signal (learning curve)
% se = [];

for n = 1:Ns
    xx = [xx(2:M);x(n)];
    y(n) = w1' * xx;
    e(n) = d(n) - y(n);
    se(n) = (signal(n)-e(n))^2;
%     se(n) = sum(e(max([1 n-M]):n).^2)/length(e(max([1 n-M]):n));
%     if mod(n,M) == 0
%         se(end+1)=sum(e(max([1 n-M]):n).^2)/length(e(max([1 n-M]):n));
%     end
    w1 = w1 + mu * e(n) * xx;
end
se = mag2db(se);
end