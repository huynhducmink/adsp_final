function [e, y, se] = LMS_latt(d, x, M, signal, mu)
% Adaptive joint process estimator
% Trang 255 haykin
% Trang 380 beh

N = length(d);
k = zeros(M,1); % Khoi tao bo loc
new_k = zeros(M,1);
w = zeros(M,1);

y = zeros(N,1); % Output cua bo loc
e = zeros(N,1); % Sai so giua output cua bo loc va tin hieu mong muon
% Trong truong hop ung dung noise cancellation, y tien den gia tri cua
% nhieu can loc, e tien den gia tri cua tin hieu goc
se = zeros(N,1); % Square error value beween error and signal (learning curve)
e_stage = zeros(M,1); % Error at each stage of the linear combiner ( page 189 http://www.signal.uu.se/Staff/pd/DSP/Doc/applicat/chap6.pdf )

f = zeros(M,1);
g = zeros(M,1); % Param cho lattice filter structure
g_delay = zeros(M,1);

for n = 1:N
    %Lattice predictor
    f(1) = x(n);
    g(1) = x(n);
    for lat = 2:M
       f(lat) = f(lat-1) - k(lat-1) * g_delay(lat-1);
       g(lat) = g_delay(lat-1) - k(lat-1) * f(lat-1);
       new_k(lat-1) = k(lat-1) + mu * (f(lat-1) * g(lat) + f(lat) * g_delay(lat-1)) ;
    end
    %Linear combiner (LMS)
    y(n) = w' * g;
    e(n) = d(n) - y(n);
    se(n) = (signal(n)-e(n)).^2;
    e_stage(1) = d(n) - g(1) * w(1);
    for stage = 2:M
        e_stage(stage) = e_stage(stage-1) - g(stage) * w(stage);
    end
    k = new_k;
    g_delay = g;
    w = w + mu * e_stage(M) * g;
end
end