% GoldsteinStryer.m
% This script contains the manual implementation for solving the 
% single-pathway Goldstein-Stryer model for kinetic BiPy-1 models. 

function x = GoldsteinStryer(ctot, KeP, s, n)

options2=optimset('Display', 'off', 'TolFun', 1e-18);
    
xtot=KeP*ctot;


y=-1;
z=1;
    
a0=0;
    if xtot < 1

            y=0.99*xtot; 
            f=xtot-(1/s)*(((s*y)^(n+1)*(n*s*y-n-1))/((s*y-1)^2)+(s*y)/((s*y-1)^2))+s^(n-1)*(y^(n+1)*(y*n-n-1))/((y-1)^2);
            xrange=[0;y];   
            while f<-1e15
                y=0.99*y;
                f=xtot-(1/s)*(((s*y)^(n+1)*(n*s*y-n-1))/((s*y-1)^2)+(s*y)/((s*y-1)^2))+s^(n-1)*(y^(n+1)*(y*n-n-1))/((y-1)^2);
                xrange=[a0;y];
            end
            
            z=y/0.99;
            while (f>0 && (z-y)>1e-15)
                y=(y+z)/2;
                f=xtot-(1/s)*(((s*y)^(n+1)*(n*s*y-n-1))/((s*y-1)^2)+(s*y)/((s*y-1)^2))+s^(n-1)*(y^(n+1)*(y*n-n-1))/((y-1)^2);
                xrange=[a0;y];
            end

            if (z-y)<1e-15
                x=z;
            end

            if f<-1e15
                x=y;
            end

        if ((z-y)>1e-15 && f<0 && f>-1e15)
            x = fzero(@(x1) GoldsteinStryer_func(x1, xtot, n, s),...
                xrange, options2);
        end
    end

    if xtot > 1

        y=0.99*1; 
        f=xtot-(1/s)*(((s*y)^(n+1)*(n*s*y-n-1))/((s*y-1)^2)+(s*y)/((s*y-1)^2))+s^(n-1)*(y^(n+1)*(y*n-n-1))/((y-1)^2);
        xrange=[a0;y];   
        while f<-1e15
            y=0.99*y;
            f=xtot-(1/s)*(((s*y)^(n+1)*(n*s*y-n-1))/((s*y-1)^2)+(s*y)/((s*y-1)^2))+s^(n-1)*(y^(n+1)*(y*n-n-1))/((y-1)^2);
            xrange=[a0;y];
        end

        z=y/0.99;
        while (f>0 && (z-y)>1e-15)
            y=(y+z)/2;
            f=xtot-(1/s)*(((s*y)^(n+1)*(n*s*y-n-1))/((s*y-1)^2)+(s*y)/((s*y-1)^2))+s^(n-1)*(y^(n+1)*(y*n-n-1))/((y-1)^2);
            xrange=[a0;y];
        end

        if (z-y)<1e-15
            x=z;
        end

        if f<-1e15
            x=y;
        end


        if ((z-y)>1e-15 && f<0 && f>-1e15)
            x = fzero(@(x1) GoldsteinStryer_func(x1, xtot, n, s),...
                xrange, options2);
        end

    end
end
