clear, clc, close
% implementation based on: 
%   https://en.wikipedia.org/wiki/Broyden-Fletcher-Goldfarb-Shanno_algorithm

%% Load test function
[f, ~] = himmelblau(1);

%% Parameters
t = 1000;           % number of iterations
x0 = [2 5];         % initial guess
alpha = 1e-2;       % learning rate

%% Quasi-Newton method algorithm: multidimensional function example
% objective: find a critical point (maximum or minimum) near the initial guess
grad0 = gradest(f, x0);
B = eye(length(x0));
x1 = x0 - 1e-3 * (B \ grad0')';


hold on
h1 = plot3(x1(1), x1(2), f(x1), 'o', 'MarkerSize', 10, 'MarkerFaceColor', [1 0 0]);
h2 = plot(x1(1), x1(2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', [1 0 0]);
for i = 1 : t
    grad1 = gradest(f, x1);
    y = (grad1 - grad0)';
    s = (x1 - x0)';
    B = B + (y * y') ./ (y' * s) - B * s * (B * s)' ./ (s' * B * s);
    
    x0 = x1;
    grad0 = grad1;
    
    x1 = x1 - alpha * (B \ grad1')';
    
    delete(h1);
    delete(h2);
    h1 = plot3(x1(1), x1(2), f(x1), 'o', 'MarkerSize', 10, 'MarkerFaceColor', [1 0 0]);
    h2 = plot(x1(1), x1(2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', [0 0 1]);
    drawnow;     
    title(['t: ' num2str(i) ' | f(' num2str(x1(1)) ',' num2str(x1(2)) ') = ' num2str(f(x1))]);
end