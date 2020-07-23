clear, clc, close
%% Load test function
[f, ~] = himmelblau(1);

%% Parameters
t = 1000;        % number of iterations
x = [.3 5];      % initial guess
alpha = 1e-3;    % learning rate

%% Gradient descent algorithm: multidimensional function example
% objective: find a minimum near the initial guess
% obs.: To find a maximum, change the signal to '+'

hold on
h1 = plot3(x(1), x(2), f(x), 'o', 'MarkerSize', 10, 'MarkerFaceColor', [1 0 0]);
h2 = plot(x(1), x(2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', [1 0 0]);
for i = 1 : t
    x = x - alpha * gradest(f, x);
        
    delete(h1);
    delete(h2);
    h1 = plot3(x(1), x(2), f(x), 'o', 'MarkerSize', 10, 'MarkerFaceColor', [1 0 0]);
    h2 = plot(x(1), x(2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', [0 0 1]);
    drawnow;     
    title(['t: ' num2str(i) ' | f(' num2str(x(1)) ',' num2str(x(2)) ') = ' num2str(f(x))]);
end