function [e, y] = RLS_mod(d, x,lamda,M)

Ns = length(d);

I = eye(M);
a = 0.01;
p = a * I;

w1 = zeros(M,1);
y = zeros(Ns, 1);
e = zeros(Ns, 1);
xx = zeros(M,1);

for n = 1:Ns
    xx = [x(n); xx(1:M-1)];
    k = (p * xx) ./ (lamda + xx' * p * xx);
    y(n) = xx'*w1;
    e(n) = d(n) - y(n);
    w1 = w1 + k * e(n);
    p = (p - k * xx' * p) ./ lamda;
end

end