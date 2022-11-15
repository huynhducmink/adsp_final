function [e,y,mse] = NLMS(d, x, mu, M, theta, loops)
Ns = length(d);
mse = zeros(loops,1);
w1 = zeros( M,1);

for i = 1:loops
    xx = zeros( M,1);
    y = zeros(Ns,1);
    e = zeros(Ns,1);
for n = 1:Ns
    xx = [xx(2:M);x(n)];
    y(n) = w1' * xx;
    e(n) = d(n) - y(n);
    w1 = w1 + mu/(theta + xx'*xx) * e(n) * xx;
end
mse(i,1) = calMSE(y,d);
end
end