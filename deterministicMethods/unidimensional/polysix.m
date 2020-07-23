function [f, x_range] = polysix(p)
%%  Six degree polynomial function with six real roots
%   input
%       p:
%           1 - plot the function
%           0 - do not plot the function

%   output
%       f - handle of the function
%       x_range - x range of the function


    f = @(x) x.^6 - 4 * x.^5 - 3 * x.^4 + 16 * x.^3 + 6 * x.^2 - 6 * x - 1;
    x_range = [-2, 3.6];

    if(p)
        x = x_range(1) : 0.01 : x_range(2);
        plot(x, f(x), 'Linewidth', 2)
        xlim(x_range)
        ylim([-30, 60])
        box on, grid on
    end
end