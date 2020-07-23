clear, close, clc

%% Load
load X.mat
load Y.mat

%% Function
x = 0:.0001:1;
xmin = .37447;
f = @(x)(obj_func(X, Y, x));

%% Ge filled function
% Parameter
a = .5; % extensão
r = 0;
p = .09; % punição da exponencial
ff = @(x, r, p)(f(x) + a ./ (r + f(x)) .* exp(- (x - xmin).^2 / p^2));

%% Parsopoulos filled function
c1 = .9; % upward stretching
c2 = 1e-6; % range of the effect
mi = 1e-1; % magnitude of the elevation
G = @(x)(f(x) + c1 * abs(x - xmin) .* (sign(f(x) - f(xmin)) + 1));
H = @(x)(G(x) + c2 * (sign(f(x) - f(xmin)) + 1) ./ (tanh(mi * (G(x) - G(xmin)))));

%% Plot
figure, hold on, box on, grid on
h1 = plot(x, f(x), '-r', 'LineWidth', 2);
h2 = plot(x, ff(x, r, p), '-g', 'LineWidth', 2);
h2 = plot(x, G(x), '-g', 'LineWidth', 2);
h3 = plot(x, H(x), '-b', 'LineWidth', 2);
h4 = plot(xmin, f(xmin), 'ok', 'LineWidth', 2);
plot([0 1], [f(xmin) f(xmin)] , '-')
legend([h1, h2, h3, h4], 'Original', 'G(x)', 'H(x)', 'Local min', 'Location', 'Northwest')


