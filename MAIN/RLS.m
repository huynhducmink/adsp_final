function [e, y, mse] = RLS(d, x, delta, lamda, M, loops)
Ns = length(d);
I = eye(M);
p = 1 / delta * I;
mse = zeros(loops,1);
w1 = zeros(M,1);

for i = 1:loops
    xx = zeros(M,1);
    y = zeros(Ns, 1);
    e = zeros(Ns, 1);
for n = 1:Ns
    xx = [xx(2:M);x(n)];
    k = (p * xx) ./ (lamda + xx' * p * xx);
    y(n) = xx'*w1;
    e(n) = d(n) - y(n);
    w1 = w1 + k * e(n);
    p = (p - k * xx' * p) ./ lamda;
end
mse(i,1) = calMSE(y,d);
end
end