function [ aurea ] = aureaPSO( cinf, csup, x, diff, f )
    ff = @(c) f(x + c * diff);
    
    d = 0.618 * (csup - cinf);
    a = cinf + d;
    b = csup - d;
    
    ffa = ff(a);
    ffb = ff(b);
    
    while (abs(csup - cinf) > 1e-5)
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

