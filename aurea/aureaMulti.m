function [aurea, hess] = aureaMulti(xinf, xsup, x0, grad, delta, f)
    hess = hessian(f, x0);
    hess(eye(length(x0)) ~= 0) = abs(diag(hess));
    g = (hess \ grad')';
    ff = @(x) f(x0 - x * g);
    
    
    d = 0.618 * (xsup - xinf);
    a = xinf + d;
    b = xsup - d;
    
    ffa = ff(a);
    ffb = ff(b);
    while (abs(xsup - xinf) > delta)
        if ffb < ffa
            xsup = a;
            a = b;
            ffa = ffb;
            b = xsup - 0.618 * (xsup - xinf);
            ffb = ff(b);
        else
            xinf = b;
            b = a;
            ffb = ffa;
            a = xinf + 0.618 * (xsup - xinf);
            ffa = ff(a);
        end
    end
    aurea = (a + b) / 2;    
end