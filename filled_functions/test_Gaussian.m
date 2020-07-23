clear, clc, close

mu = 5;
sigma = 1.5;

err = inf;
sigma2 = 0;
sig = 0;
for sig = 0.1 : .1 : 10
    rand_x = normrnd(0, 1, [1, 10]);
    
    x = mu + sig * rand_x;

    y1 = normpdf(x, mu, sigma);    
    y2 = normpdf(x, mu, sig);
    err_est = sum(abs(y1 - y2));

    if(err_est < err)
        err = err_est;
        sigma2 = sig;
    end
end

x = 0:.1:10;
y = normpdf(x, mu, sigma2);
y_real = normpdf(x, mu, sigma);

figure, hold on
plot(x, y_real, '-r')
plot(x, y, '-b')
grid on, box on

