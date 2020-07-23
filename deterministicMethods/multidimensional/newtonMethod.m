clear, clc, close
%% Load test function
[f, ~] = himmelblau(1);

%% Parameters
t = 1000;       % number of iterations
x = [5 5];         % initial guess
alpha = 1e-2;   % learning rate

%% Newton-Raphson method algorithm: multidimensional function example
% objective: find a critical point (maximum or minimum) near the initial guess

hold on
h1 = plot3(x(1), x(2), f(x), 'o', 'MarkerSize', 10, 'MarkerFaceColor', [1 0 0]);
h2 = plot(x(1), x(2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', [1 0 0]);
for i = 1 : t
    grad = gradest(f, x);   % gradient vector
    hess = hessian(f, x);       % hessian matrix
	
    x = x - alpha * (hess \ grad')';
    
    delete(h1);
    delete(h2);
    h1 = plot3(x(1), x(2), f(x), 'o', 'MarkerSize', 10, 'MarkerFaceColor', [1 0 0]);
    h2 = plot(x(1), x(2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', [0 0 1]);
    drawnow;     
    title(['t: ' num2str(i) ' | f(' num2str(x(1)) ',' num2str(x(2)) ') = ' num2str(f(x))]);
end