function [e, y, se, test] = LMS_latt(d, x, M, signal)

% Trang 255 haykin
% Trang 380 beh
mu = 0.001;

Ns = length(d);
w = zeros(M,1); % Khoi tao bo loc
new_w = zeros(M,1);

y = zeros(Ns,1); % Output cua bo loc
e = zeros(Ns,1); % Sai so giua output cua bo loc va tin hieu mong muon
% Trong truong hop ung dung noise cancellation, y tien den gia tri cua
% nhieu can loc, e tien den gia tri cua tin hieu goc
se = zeros(Ns,1); % Square error value beween error and signal (learning curve)

f = zeros(M,1);
g = zeros(M,1); % Param cho lattice filter structure
g_delay = zeros(M,1);

for n = 1:Ns
    f(1) = x(n);
    g(1) = x(n);
    for lat = 2:M
       f(lat) = f(lat-1) - w(lat-1) * g_delay(lat-1);
       g(lat) = g_delay(lat-1) - w(lat-1) * f(lat-1);
       new_w(lat-1) = w(lat-1) + mu * e(max([1,n-1])) * g_delay(lat-1);
    end
    y(n) = f(M);
    e(n) = d(n) - y(n);
    se(n) = (signal(n)-e(n))^2;
    w = new_w;
    g_delay = g;
    test(:,n) = w;
end
se = mag2db(se);
end