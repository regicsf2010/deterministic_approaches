clear, clc, close
%% Load test function
[f, ~] = polysix(1);

%% Parameters
t = 1000;       % number of iterations
x = 2.7;         % initial guess
alpha = 1e-2;   % learning rate

%% Newton-Raphson method algorithm: one dimensional function example
% objective: find a critical point near the initial guess

hold on
h1 = plot(x, f(x), 'o', 'MarkerSize', 10, 'MarkerFaceColor', [1 0 0]);
for i = 1 : t
    dev1 = derivest(f, x, 'deriv', 1); % first order derivative
    dev2 = derivest(f, x, 'deriv', 2); % second order derivative
	
    x = x - alpha * dev1 / dev2;
    
    delete(h1)
    h1 = plot(x, f(x), 'o', 'MarkerSize', 10, 'MarkerFaceColor', [1 0 0]);
    drawnow
    title(['t: ' num2str(i) ' | f(' num2str(x) ') = ' num2str(f(x))]);
end