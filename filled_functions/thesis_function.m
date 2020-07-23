clear, clc, close

x = -2:.001:3.6;
f = @(x) x.^6 - 4 * x.^5 - 3 * x.^4 + 16 * x.^3 + 6 * x.^2 - 6 * x - 1;
d = [2.3 3.45];

r = [-1.363 0.258 3.083];

figure, hold on
h1 = plot(x, f(x), '-b', 'linewidth', 2);
h2 = plot(r(1:2), f(r(1:2)), 'or', 'linewidth', 2, 'MarkerSize', 8, 'MarkerFaceColor',[1,0,0]);
h3 = plot(r(3), f(r(3)), 'sk', 'linewidth', 2, 'MarkerSize', 8, 'MarkerFaceColor',[0,0,0]);

vline(-1.8, 'k', 'x_{1}')
vline(-0.9, 'k', 'x_{2}')
vline(1.8530, 'k', 'x_{3}')
vline(3.6, 'k', 'x_{4}')
h4 = line([-1.7 -1], [f(-1.7) f(-1)], 'Color', 'black', 'LineStyle', '-', 'linewidth', 1.5);

xlim([min(x) max(x)+.1])


legend([h1 h2 h3 h4], 'f(x)=x^6-4x^5-3x^4+16x^3+6x^2-6x-1', 'Local minima', 'Global minimum', 'Arbitrary test of convexity')
xlabel('Search space (R)')
ylabel('f(x)')

set(gca,'FontSize', 12)
box on, grid on
% print('img', '-depsc')