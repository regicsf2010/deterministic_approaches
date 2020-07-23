clear, close, clc

X = linspace(0, 1, 1000); 
Y = ones(size(X));

n = 1;
[Y, extremePoint, width, method, haxes] = new_y2(X, Y, 'spline');

while ~waitforbuttonpress
    n = n + 1;
    [Y, extremePoint(n, :), width(n), method] = new_y2(haxes, method);
end
save X.mat X
save Y.mat Y