function [e, y] = LMS(d, x, mu, M)
Ns = length(d);
w1 = zeros(M,1);

xx = zeros( M,1);
y = zeros(Ns,1);
e = zeros(Ns,1);
for n = 1:Ns
    xx = [xx(2:M);x(n)];
    y(n) = w1' * xx;
    e(n) = d(n) - y(n);
    w1 = w1 + mu * e(n) * xx;
end
end