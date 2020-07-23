clear, close, clc

load X.mat
load Y.mat

x = 0:.0001:1;
f = @(x)(obj_func(X, Y, x));

x0 = .2482;
n = 100;
figure, hold on, box on, grid on
plot(X, Y, '-r', 'LineWidth', 2)

for i = 1 : n
    dev1 = derivest(f, x0, 'deriv', 1);
    dev2 = derivest(f, x0, 'deriv', 2);
	
    x0 = x0 - dev1 / abs(dev2);

    h1 = plot(x0, f(x0), 'o', 'MarkerSize', 10, 'MarkerFaceColor', [1 0 0]);
    drawnow; 
    delete(h1);

    title({['ITER: ' num2str(i) ' | FIT: ' num2str(f(x0))],...
           ['X = [' num2str(x0(1)) ']']});
end