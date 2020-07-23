clear, clc, close

mu = 3.083;
f = @(x) x.^6 - 4 * x.^5 - 3 * x.^4 + 16 * x.^3 + 6 * x.^2 - 6 * x - 1;

err = inf;
sigma2 = 0;
sig = 0;
for sig = 0.1 : .1 : 10
    rand_x = normrnd(0, 1, [1, 10]);
    
    x = mu + sig * rand_x;

    y1 = f(x);
    y2 = -normpdf(x, mu, sig);
    err_est = sum(abs(y1 - y2));

    if(err_est < err)
        err = err_est;
        sigma2 = sig;
    end
end

x = -2:.001:3.6;
y = -normpdf(x, mu, sigma2);
y_real = f(x);

figure, hold on
plot(x, y_real, '-r')
plot(x, y, '-b')
grid on, box on

