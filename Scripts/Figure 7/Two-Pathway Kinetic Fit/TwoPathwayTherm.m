% TwoPathwayTherm.m
% This script contains the manual implementation for solving the 
% two-pathway thermodynamic model for use in kinetic BiPy-1 models. 

function x = TwoPathwayTherm(ctot, KnA_init, KeA_init, KnB_init, KeB_init)

options=optimset('Display', 'off', 'TolFun', 1e-18);
    
xtot=KeA_init*ctot;

sa  = KnA_init/KeA_init;
sb  = KnB_init/KeB_init;
B   = KeB_init/KeA_init;

y=-1;
z=1;

a0=0;
    
    if xtot < 1

        y=0.99*xtot; 
            f=xtot-y-sa*(y/((1-y)^2)-y)-sb*(y/((1-B*y)^2)-y);
            xrange=[0;y];   
            while f<-1e15
                y=0.99*y;
                f=xtot-y-sa*(y/((1-y)^2)-y)-sb*(y/((1-B*y)^2)-y);
                xrange=[a0;y];
            end
            
            z=y/0.99;
            while (f>0 && (z-y)>1e-15)
                y=(y+z)/2;
                f=xtot-y-sa*(y/((1-y)^2)-y)-sb*(y/((1-B*y)^2)-y);
                xrange=[a0;y];
            end
            
            if (z-y)<1e-15
                x=z;
            end

            if f<-1e15
                x=y;
            end

        if ((z-y)>1e-15 && f<0 && f>-1e15)
            x = fzero(@(x1) TwoPathwayTherm_func(x1, xtot, sa, sb, B),...
                xrange, options);
        end
    end

    if xtot > 1
        
        if 1/B >= 1
            
            y=0.99*1; 
            f=xtot-y-sa*(y/((1-y)^2)-y)-sb*(y/((1-B*y)^2)-y);
            xrange=[a0;y];   
            while f<-1e15
                y=0.99*y;
                f=xtot-y-sa*(y/((1-y)^2)-y)-sb*(y/((1-B*y)^2)-y);
                xrange=[a0;y];
            end

            z=y/0.99;
            while (f>0 && (z-y)>1e-15)
                y=(y+z)/2;
                f=xtot-y-sa*(y/((1-y)^2)-y)-sb*(y/((1-B*y)^2)-y);
                xrange=[a0;y];
            end
            
            if (z-y)<1e-15
                x=z;
            end

            if f<-1e15
                x=y;
            end
        

            if ((z-y)>1e-15 && f<0 && f>-1e15)
                x = fzero(@(x1) TwoPathwayTherm_func(x1, xtot, sa, sb, B),...
                    xrange, options);
            end
        
        end
        
        if 1/B < 1
            
            y=0.99*(1/B); 
            f=xtot-y-sa*(y/((1-y)^2)-y)-sb*(y/((1-B*y)^2)-y);
            xrange=[a0;y];   
            while f<-1e15
                y=0.99*y;
                f=xtot-y-sa*(y/((1-y)^2)-y)-sb*(y/((1-B*y)^2)-y);
                xrange=[a0;y];
            end

            z=y/0.99;
            while (f>0 && (z-y)>1e-15)
                y=(y+z)/2;
                f=xtot-y-sa*(y/((1-y)^2)-y)-sb*(y/((1-B*y)^2)-y);
                xrange=[a0;y];
            end
            
            if (z-y)<1e-15
                x=z;
            end

            if f<-1e15
                x=y;
            end
        

            if ((z-y)>1e-15 && f<0 && f>-1e15)
                x = fzero(@(x1) TwoPathwayTherm_func(x1, xtot, sa, sb, B),...
                    xrange, options);
            end
            
        end
        
    end
                
    if 1/B < 1 && xtot < 1
            
            if 1/B < xtot
                
                y=0.99*(1/B); 
                f=xtot-y-sa*(y/((1-y)^2)-y)-sb*(y/((1-B*y)^2)-y);
                xrange=[a0;y];   
                while f<-1e15
                    y=0.99*y;
                    f=xtot-y-sa*(y/((1-y)^2)-y)-sb*(y/((1-B*y)^2)-y);
                    xrange=[a0;y];
                end

                z=y/0.99;
                while (f>0 && (z-y)>1e-15)
                    y=(y+z)/2;
                    f=xtot-y-sa*(y/((1-y)^2)-y)-sb*(y/((1-B*y)^2)-y);
                    xrange=[a0;y];
                end

                if (z-y)<1e-15
                    x=z;
                end

                if f<-1e15
                    x=y;
                end


                if ((z-y)>1e-15 && f<0 && f>-1e15)
                    x = fzero(@(x1) TwoPathwayTherm_func(x1, xtot, sa, sb, B),...
                        xrange, options);
                end
                
            end
            
            if 1/B > xtot
                
                y=0.99*xtot; 
                f=xtot-y-sa*(y/((1-y)^2)-y)-sb*(y/((1-B*y)^2)-y);
                xrange=[a0;y];   
                while f<-1e15
                    y=0.99*y;
                    f=xtot-y-sa*(y/((1-y)^2)-y)-sb*(y/((1-B*y)^2)-y);
                    xrange=[a0;y];
                end

                z=y/0.99;
                while (f>0 && (z-y)>1e-15)
                    y=(y+z)/2;
                    f=xtot-y-sa*(y/((1-y)^2)-y)-sb*(y/((1-B*y)^2)-y);
                    xrange=[a0;y];
                end

                if (z-y)<1e-15
                    x=z;
                end

                if f<-1e15
                    x=y;
                end


                if ((z-y)>1e-15 && f<0 && f>-1e15)
                    x = fzero(@(x1) TwoPathwayTherm_func(x1, xtot, sa, sb, B),...
                        xrange, options);
                end
                
            end
                
     end
    
end
