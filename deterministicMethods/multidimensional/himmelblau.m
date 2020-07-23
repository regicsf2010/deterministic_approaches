function [f, x_range] = himmelblau(p)
%%  Himmelblau test function
%   input
%       p:
%           1 - plot the function
%           0 - do not plot the function

%   output
%       f - handle of the function
%       x_range - x range of the function


    f = @(x) (x(1)^2 + x(2) - 11)^2 + (x(1) + x(2)^2 - 7)^2;
    x_range = [-5, 5];

    if(p)
        x = x_range(1) : 0.1 : x_range(2);
        [X, Y] = meshgrid(x, x);
        fxy = (X.^2 + Y - 11).^2 + (X + Y.^2 - 7).^2;
        
%         mesh(X, Y, fxy);
        surfc(X, Y, fxy);
        view(-40, 36)
        xlim(x_range)
        ylim(x_range)
        zlim([min(min(fxy)) - 0.5, max(max(fxy)) + 0.5])       
    end
end