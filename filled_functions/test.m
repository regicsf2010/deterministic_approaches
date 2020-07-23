clear, clc, close;

%% parameters
alpha = 170;
r = 0;
p = 1;

x = -1:.01:6;
xx = -20:.01:10;

%% filled functions
f = @(x)(x.^4 - 12 * x.^3 + 47 * x.^2 - 60 .* x + 25);
ff = @(x,r,p)(f(x) + alpha ./ (r + f(x)) .* exp(- (x - 4.60095589).^2 / p^2));
% fg = @(x)(x.^8 + 46*x.^7 + 707*x.^6 + 2998*x.^5 - 20176*x.^4 - 143711*x.^3 + 451048*x.^2 + 3653787*x + 2120580);



%% plots
figure, hold on, box on
h1 = plot(x, f(x), 'linewidth', 2);
h2 = plot(x, ff(x, r, p), '--r', 'linewidth', 2);
h3 = plot(x, ff(x, r, p)-f(x), '-k', 'linewidth', 2);
% h4 = plot(xx, fg(xx));
% h5 = plot(xx, zeros(1, length(xx)));
legend([h1 h2 h3], 'Original function', 'F(x) + P(x,r,p)', 'Filled function ')
