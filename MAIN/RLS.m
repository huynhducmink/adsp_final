function [e, y] = RLS(d, x, delta, lamda, M)
Ns = length(d);
I = eye(M);
p = 1 / delta * I;
w1 = zeros(M,1);

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
end