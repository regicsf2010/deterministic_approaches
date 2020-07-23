clear, clc, close
 
f = @(x) (x - 10).^2;
xx = -50 : .1 : 100;
yy = f(xx);

[x, fx, itMax] = aureaUni(xx(1), xx(end), 1e-5, f);


figure, hold on, box on
plot(xx, yy, '-b', 'LineWidth', 2)
plot(x, fx, 'or', 'LineWidth', 2)
title(['f(' num2str(x) ') = ' num2str(f(x)) ' | itMax = ' num2str(itMax)])