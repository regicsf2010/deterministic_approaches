function g = gradest2(x0, f)
%%  Gradient calculation
%   Developed by Reginaldo Santos

%   IMPUTS:
%       x0 - variable(s)
%       f  - function handle
%

    g = zeros(size(x0));    % gradient vector
    fx0 = f(x0);            % function value at x0
    step = 1e-5;            % very small step

    for i = 1 : length(x0)
        xli = x0;
        xli(i) = x0(i) + step;
        g(i) = ( f(xli) - fx0 ) / step;
    end

end