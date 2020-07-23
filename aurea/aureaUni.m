function [ x, fx, itMax ] = aureaUni( xinf, xsup, delta, f )
    d = 0.618 * (xsup - xinf);
    a = xinf + d;
    b = xsup - d;
    fb = f(b);
    fa = f(a);
    itMax = 0;
    while(abs(xsup - xinf) > delta)
        if(fb < fa)
            xsup = a;
            a = b;
            fa = fb;
            b = xsup - 0.618 * (xsup - xinf);
            fb = f(b);
        else
            xinf = b;
            b = a;
            fb = fa;
            a = xinf + 0.618 * (xsup - xinf);
            fa = f(a);
        end
        itMax = itMax + 1;
    end
    
    x = (a + b) / 2;
    fx = f(x);

end

