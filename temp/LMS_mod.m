function [e, y] = LMS_mod(d, x, mu, M)
Ns = length(d);

xx = zeros(M,1);
w1 = zeros(M,1);
y = zeros(Ns,1);
e = zeros(Ns,1);

for n = 1:round(Ns/2)
    xx = [xx(2:M);x(n)]; %filter nodes
    y(n) = w1' * xx;
    e(n) = d(n) - y(n);
    w1 = w1 + mu * e(n) * xx;
end

for n = (round(Ns/2)+1):Ns
    xx = [xx(2:M);x(n)]; %filter nodes
    y(n) = w1' * xx;
    e(n) = d(n) - y(n);
%     w1 = w1 + mu * e(n) * xx;
end

end