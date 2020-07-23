function [ yq ] = obj_func( x, y, xq )
    yq = interp1(x, y, xq, 'spline');
end

