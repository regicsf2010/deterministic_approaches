clear, clc, close
%% Load test function
[f, ~] = polysix(1);

%% Parameters
t = 1000;        % number of iterations
x = 1.5; %1.5    % initial guess
alpha = 1e-4;    % learning rate

%% Gradient descent algorithm: one dimensional function example
% objective: find a minimum near the initial guess
% obs.: To find a maximum, change the signal to '+'

hold on
h1 = plot(x, f(x), 'o', 'MarkerSize', 10, 'MarkerFaceColor', [1 0 0]);
for i = 1 : t
    x = x - alpha * derivest(f, x, 'deriv', 1);
    
    delete(h1)
    h1 = plot(x, f(x), 'o', 'MarkerSize', 10, 'MarkerFaceColor', [1 0 0]);
    drawnow
    title(['t: ' num2str(i) ' | f(' num2str(x) ') = ' num2str(f(x))]);
end