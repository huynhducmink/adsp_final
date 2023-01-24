function [e, y, se] = NLMS(d, x, M, signal, mu, theta)

N = length(d);
w = zeros(M,1); % Khoi tao bo loc

xx = zeros( M,1); % Tin hieu dua vao bo loc co do dai M
y = zeros(N,1); % Output cua bo loc
e = zeros(N,1); % Sai so giua output cua bo loc va tin hieu mong muon
% Trong truong hop ung dung noise cancellation, y tien den gia tri cua
% nhieu can loc, e tien den gia tri cua tin hieu goc
se = zeros(N,1); % Square error value beween error and signal (learning curve)

for n = 1:N
    xx = [xx(2:M);x(n)];
    y(n) = w' * xx;
    e(n) = d(n) - y(n);
    se(n) = (signal(n)-e(n))^2;
    w = w + mu/(theta + xx'*xx) * e(n) * xx;
end
se = mag2db(se);
end