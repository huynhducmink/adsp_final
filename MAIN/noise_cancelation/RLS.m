function [e, y, se] = RLS(d, x, M, signal)

delta = 0.00001;
lambda = 0.9999;

Ns = length(d);
I = eye(M);
p = 1 / delta * I;
w1 = zeros(M,1); % Khoi tao bo loc

xx = zeros( M,1); % Tin hieu dua vao bo loc co do dai M
y = zeros(Ns,1); % Output cua bo loc
e = zeros(Ns,1); % Sai so giua output cua bo loc va tin hieu mong muon
% Trong truong hop ung dung noise cancellation, y tien den gia tri cua
% nhieu can loc, e tien den gia tri cua tin hieu goc
se = zeros(Ns,1); % Square error value beween error and signal (learning curve)

for n = 1:Ns
    xx = [xx(2:M);x(n)];
    k = (p * xx) ./ (lambda + xx' * p * xx);
    y(n) = xx'*w1;
    e(n) = d(n) - y(n);
    w1 = w1 + k * e(n);
    se(n) = (signal(n)-e(n))^2;
    p = (p - k * xx' * p) ./ lambda;
end
se = mag2db(se);
end