% SolveMassBalance_TP
% Model description for a competitive two-pathway self-assembly process. 
% This script uses the input thermodynamic parameters to calculate molecular 
% distributions as a function of temperature, and converts these to CD, UV 
% and fluorescence traces as output. 
% InitiateVariableTemperatureFit_TP.m is used to call this script iteratively, 
% while adapting parameter values. 

function c=SolveMassBalance_TP(par,Temp1,CD1,UV1,FL1,...
            Temp2,CD2,UV2,FL2,Temp3,CD3,UV3,FL3,Temp4,CD4,UV4,FL4,...
            Temp5,CD5,UV5,FL5,Temp6,CD6,UV6,Temp7,CD7,UV7,CONC,sf)
format long
options=optimset('Display', 'off', 'TolFun', 1e-18);

% Set self-assembly parameters. These are thermodynamics of self-assembly
% (1-6), optical parameters (7-13) and correction factors for spectroscopic
% non-linearities.
deltaH2A=par(1);
deltaHA=par(2);
deltaSA=par(3);
deltaH2B=par(4);
deltaHB=par(5);
deltaSB=par(6);
epsm=par(7);
depsa=par(8);
epsa=par(9);
flinta=par(10);
depsb=par(11);
epsb=par(12);
flintb=par(13);
cfUV1=par(14);
cfUV2=par(15);
cfUV3=par(16);
cfUV4=par(17);
cfUV5=par(18);
cfUV6=par(19);
cfUV7=par(20);
cfFL1=par(21);
cfFL2=par(22);
cfFL3=par(23);
cfFL4=par(24);
cfFL5=par(25);

R=8.3145;           

%% for first concentration:
% Set concentration
ctot=CONC(1);

% Calculate equilibrium constants at each temperature
K2A_T = exp(-(deltaH2A-Temp1.*deltaSA)./(R.*Temp1));
KA_T = exp(-(deltaHA-Temp1.*deltaSA)./(R.*Temp1));
K2B_T = exp(-(deltaH2B-Temp1.*deltaSB)./(R.*Temp1));
KB_T = exp(-(deltaHB-Temp1.*deltaSB)./(R.*Temp1));

% Create empty vectors to store monomer concentrations and dimensionless 
% concentrations of A, B and monomer. 
x1=zeros(length(Temp1),1);
concentrationM1=zeros(length(Temp1),1);
concentrationA1=zeros(length(Temp1),1);
concentrationB1=zeros(length(Temp1),1);

% Find monomer concentration x1 for every temperature T by solving the
% mass balance. These equations are highly non-linear and contain many
% asymptotes, which this complicated manual implementation avoids.
for i=1:length(Temp1)

    K2A=K2A_T(i);
    KA=KA_T(i);
    K2B=K2B_T(i);
    KB=KB_T(i);
        
    sa=K2A/KA;
    sb=K2B/KB;
    B=KB/KA;
    
    xtot=KA*ctot;
    
    b=1;
    a=-1;
    a0=0;
   
    if xtot < 1

        a=0.99*xtot; 
            f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
            xrange=[0;a];   
            while f<-1e15
                a=0.99*a;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
        
            b=a/0.99;
            while (f>0 && (b-a)>1e-15)
                a=(a+b)/2;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
            
            if (b-a)<1e-15
                x1(i,1)=b;
            end

            if f<-1e15
                x1(i,1)=a;
            end

        if ((b-a)>1e-15 && f<0 && f>-1e15)
            x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                xrange, options);
        end
    end

    if xtot > 1
        
        if 1/B >= 1
            
            a=0.99*1; 
            f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
            xrange=[a0;a];   
            while f<-1e15
                a=0.99*a;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end

            b=a/0.99;
            while (f>0 && (b-a)>1e-15)
                a=(a+b)/2;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
            
            if (b-a)<1e-15
                x1(i,1)=b;
            end

            if f<-1e15
                x1(i,1)=a;
            end
        

            if ((b-a)>1e-15 && f<0 && f>-1e15)
                x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                    xrange, options);
            end
        
        end
        
        if 1/B < 1
            
            a=0.99*(1/B); 
            f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
            xrange=[a0;a];   
            while f<-1e15
                a=0.99*a;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end

            b=a/0.99;
            while (f>0 && (b-a)>1e-15)
                a=(a+b)/2;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
            
            if (b-a)<1e-15
                x1(i,1)=b;
            end

            if f<-1e15
                x1(i,1)=a;
            end
        

            if ((b-a)>1e-15 && f<0 && f>-1e15)
                x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                    xrange, options);
            end
            
        end
        
    end
                
    if 1/B < 1 && xtot < 1
            
            if 1/B < xtot
                
                a=0.99*(1/B); 
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];   
                while f<-1e15
                    a=0.99*a;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                b=a/0.99;
                while (f>0 && (b-a)>1e-15)
                    a=(a+b)/2;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                if (b-a)<1e-15
                    x1(i,1)=b;
                end

                if f<-1e15
                    x1(i,1)=a;
                end


                if ((b-a)>1e-15 && f<0 && f>-1e15)
                    x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                        xrange, options);
                end
                
            end
            
            if 1/B > xtot
                
                a=0.99*xtot; 
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];   
                while f<-1e15
                    a=0.99*a;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                b=a/0.99;
                while (f>0 && (b-a)>1e-15)
                    a=(a+b)/2;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                if (b-a)<1e-15
                    x1(i,1)=b;
                end

                if f<-1e15
                    x1(i,1)=a;
                end


                if ((b-a)>1e-15 && f<0 && f>-1e15)
                    x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                        xrange, options);
                end
                
            end
                
    end
     % Calculate the concentrations of other species based on monomer
     % concentration.
     concentrationA1(i,1)=(1/KA)*sa*(x1(i,1)/((1-x1(i,1))^2)-x1(i,1));
     concentrationB1(i,1)=(1/KA)*sb*(x1(i,1)/((1-B*x1(i,1))^2)-x1(i,1));
     concentrationM1(i,1)=(1/KA)*x1(i,1);
end

% Calculate optical response based on molecular distributions
DE1CD=(sf(1,1)*(concentrationA1*depsa+concentrationB1*depsb));%/CONC(1);
DE1UV=(cfUV1*sf(1,2)*(concentrationM1*epsm+concentrationA1*epsa+concentrationB1*epsb));%/CONC(1);
DE1FL=(cfFL1*sf(1,3)*(concentrationA1*flinta+concentrationB1*flintb));%/CONC(1);

%% for second concentration:
% Set concentration
ctot=CONC(2);

% Calculate equilibrium constants at each temperature
K2A_T = exp(-(deltaH2A-Temp2.*deltaSA)./(R.*Temp2));
KA_T = exp(-(deltaHA-Temp2.*deltaSA)./(R.*Temp2));
K2B_T = exp(-(deltaH2B-Temp2.*deltaSB)./(R.*Temp2));
KB_T = exp(-(deltaHB-Temp2.*deltaSB)./(R.*Temp2));

% Create empty vectors to store monomer concentrations and dimensionless 
% concentrations of A, B and monomer. 
x1=zeros(length(Temp2),1);
concentrationM2=zeros(length(Temp2),1);
concentrationA2=zeros(length(Temp2),1);
concentrationB2=zeros(length(Temp2),1);

% Find monomer concentration x1 for every temperature T by solving the
% mass balance. These equations are highly non-linear and contain many
% asymptotes, which this complicated manual implementation avoids.
for i=1:length(Temp2)

    K2A=K2A_T(i);
    KA=KA_T(i);
    K2B=K2B_T(i);
    KB=KB_T(i);
        
    sa=K2A/KA;
    sb=K2B/KB;
    B=KB/KA;
    
    xtot=KA*ctot;
    
    b=1;
    a=-1;
    a0=0;
   
    if xtot < 1

        a=0.99*xtot; 
            f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
            xrange=[0;a];   
            while f<-1e15
                a=0.99*a;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
        
            b=a/0.99;
            while (f>0 && (b-a)>1e-15)
                a=(a+b)/2;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
            
            if (b-a)<1e-15
                x1(i,1)=b;
            end

            if f<-1e15
                x1(i,1)=a;
            end

        if ((b-a)>1e-15 && f<0 && f>-1e15)
            x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                xrange, options);
        end
    end

    if xtot > 1
        
        if 1/B >= 1
            
            a=0.99*1; 
            f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
            xrange=[a0;a];   
            while f<-1e15
                a=0.99*a;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end

            b=a/0.99;
            while (f>0 && (b-a)>1e-15)
                a=(a+b)/2;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
            
            if (b-a)<1e-15
                x1(i,1)=b;
            end

            if f<-1e15
                x1(i,1)=a;
            end
        

            if ((b-a)>1e-15 && f<0 && f>-1e15)
                x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                    xrange, options);
            end
        
        end
        
        if 1/B < 1
            
            a=0.99*(1/B); 
            f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
            xrange=[a0;a];   
            while f<-1e15
                a=0.99*a;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end

            b=a/0.99;
            while (f>0 && (b-a)>1e-15)
                a=(a+b)/2;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
            
            if (b-a)<1e-15
                x1(i,1)=b;
            end

            if f<-1e15
                x1(i,1)=a;
            end
        

            if ((b-a)>1e-15 && f<0 && f>-1e15)
                x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                    xrange, options);
            end
            
        end
        
    end
                
    if 1/B < 1 && xtot < 1
            
            if 1/B < xtot
                
                a=0.99*(1/B); 
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];   
                while f<-1e15
                    a=0.99*a;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                b=a/0.99;
                while (f>0 && (b-a)>1e-15)
                    a=(a+b)/2;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                if (b-a)<1e-15
                    x1(i,1)=b;
                end

                if f<-1e15
                    x1(i,1)=a;
                end


                if ((b-a)>1e-15 && f<0 && f>-1e15)
                    x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                        xrange, options);
                end
                
            end
            
            if 1/B > xtot
                
                a=0.99*xtot; 
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];   
                while f<-1e15
                    a=0.99*a;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                b=a/0.99;
                while (f>0 && (b-a)>1e-15)
                    a=(a+b)/2;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                if (b-a)<1e-15
                    x1(i,1)=b;
                end

                if f<-1e15
                    x1(i,1)=a;
                end


                if ((b-a)>1e-15 && f<0 && f>-1e15)
                    x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                        xrange, options);
                end
                
            end
                
    end
     % Calculate the concentrations of other species based on monomer
     % concentration.
     concentrationA2(i,1)=(1/KA)*sa*(x1(i,1)/((1-x1(i,1))^2)-x1(i,1));
     concentrationB2(i,1)=(1/KA)*sb*(x1(i,1)/((1-B*x1(i,1))^2)-x1(i,1));
     concentrationM2(i,1)=(1/KA)*x1(i,1);
end
   
% Calculate optical response based on molecular distributions
DE2CD=(sf(2,1)*(concentrationA2*depsa+concentrationB2*depsb));%/CONC(2);
DE2UV=(cfUV2*sf(2,2)*(concentrationM2*epsm+concentrationA2*epsa+concentrationB2*epsb));%/CONC(2);
DE2FL=(cfFL2*sf(2,3)*(concentrationA2*flinta+concentrationB2*flintb));%/CONC(2);

%% for third concentration:
% Set concentration
ctot=CONC(3);

% Calculate equilibrium constants at each temperature
K2A_T = exp(-(deltaH2A-Temp3.*deltaSA)./(R.*Temp3));
KA_T = exp(-(deltaHA-Temp3.*deltaSA)./(R.*Temp3));
K2B_T = exp(-(deltaH2B-Temp3.*deltaSB)./(R.*Temp3));
KB_T = exp(-(deltaHB-Temp3.*deltaSB)./(R.*Temp3));

% Create empty vectors to store monomer concentrations and dimensionless 
% concentrations of A, B and monomer. 
x1=zeros(length(Temp3),1);
concentrationM3=zeros(length(Temp3),1);
concentrationA3=zeros(length(Temp3),1);
concentrationB3=zeros(length(Temp3),1);

% Find monomer concentration x1 for every temperature T by solving the
% mass balance. These equations are highly non-linear and contain many
% asymptotes, which this complicated manual implementation avoids.
for i=1:length(Temp3)

    K2A=K2A_T(i);
    KA=KA_T(i);
    K2B=K2B_T(i);
    KB=KB_T(i);
        
    sa=K2A/KA;
    sb=K2B/KB;
    B=KB/KA;
    
    xtot=KA*ctot;
    
    b=1;
    a=-1;
    a0=0;
   
    if xtot < 1

        a=0.99*xtot; 
            f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
            xrange=[0;a];   
            while f<-1e15
                a=0.99*a;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
        
            b=a/0.99;
            while (f>0 && (b-a)>1e-15)
                a=(a+b)/2;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
            
            if (b-a)<1e-15
                x1(i,1)=b;
            end

            if f<-1e15
                x1(i,1)=a;
            end

        if ((b-a)>1e-15 && f<0 && f>-1e15)
            x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                xrange, options);
        end
    end

    if xtot > 1
        
        if 1/B >= 1
            
            a=0.99*1; 
            f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
            xrange=[a0;a];   
            while f<-1e15
                a=0.99*a;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end

            b=a/0.99;
            while (f>0 && (b-a)>1e-15)
                a=(a+b)/2;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
            
            if (b-a)<1e-15
                x1(i,1)=b;
            end

            if f<-1e15
                x1(i,1)=a;
            end
        

            if ((b-a)>1e-15 && f<0 && f>-1e15)
                x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                    xrange, options);
            end
        
        end
        
        if 1/B < 1
            
            a=0.99*(1/B); 
            f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
            xrange=[a0;a];   
            while f<-1e15
                a=0.99*a;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end

            b=a/0.99;
            while (f>0 && (b-a)>1e-15)
                a=(a+b)/2;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
            
            if (b-a)<1e-15
                x1(i,1)=b;
            end

            if f<-1e15
                x1(i,1)=a;
            end
        

            if ((b-a)>1e-15 && f<0 && f>-1e15)
                x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                    xrange, options);
            end
            
        end
        
    end
                
    if 1/B < 1 && xtot < 1
            
            if 1/B < xtot
                
                a=0.99*(1/B); 
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];   
                while f<-1e15
                    a=0.99*a;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                b=a/0.99;
                while (f>0 && (b-a)>1e-15)
                    a=(a+b)/2;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                if (b-a)<1e-15
                    x1(i,1)=b;
                end

                if f<-1e15
                    x1(i,1)=a;
                end


                if ((b-a)>1e-15 && f<0 && f>-1e15)
                    x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                        xrange, options);
                end
                
            end
            
            if 1/B > xtot
                
                a=0.99*xtot; 
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];   
                while f<-1e15
                    a=0.99*a;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                b=a/0.99;
                while (f>0 && (b-a)>1e-15)
                    a=(a+b)/2;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                if (b-a)<1e-15
                    x1(i,1)=b;
                end

                if f<-1e15
                    x1(i,1)=a;
                end


                if ((b-a)>1e-15 && f<0 && f>-1e15)
                    x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                        xrange, options);
                end
                
            end
                
    end
     % Calculate the concentrations of other species based on monomer
     % concentration.
     concentrationA3(i,1)=(1/KA)*sa*(x1(i,1)/((1-x1(i,1))^2)-x1(i,1));
     concentrationB3(i,1)=(1/KA)*sb*(x1(i,1)/((1-B*x1(i,1))^2)-x1(i,1));
     concentrationM3(i,1)=(1/KA)*x1(i,1);
end
   
% Calculate optical response based on molecular distributions
DE3CD=(sf(3,1)*(concentrationA3*depsa+concentrationB3*depsb));%/CONC(3);
DE3UV=(cfUV3*sf(3,2)*(concentrationM3*epsm+concentrationA3*epsa+concentrationB3*epsb));%/CONC(3);
DE3FL=(cfFL3*sf(3,3)*(concentrationA3*flinta+concentrationB3*flintb));%/CONC(3);

%% for fourth concentration
% Set concentration
ctot=CONC(4);

% Calculate equilibrium constants at each temperature
K2A_T = exp(-(deltaH2A-Temp4.*deltaSA)./(R.*Temp4));
KA_T = exp(-(deltaHA-Temp4.*deltaSA)./(R.*Temp4));
K2B_T = exp(-(deltaH2B-Temp4.*deltaSB)./(R.*Temp4));
KB_T = exp(-(deltaHB-Temp4.*deltaSB)./(R.*Temp4));

% Create empty vectors to store monomer concentrations and dimensionless 
% concentrations of A, B and monomer. 
x1=zeros(length(Temp4),1);
concentrationM4=zeros(length(Temp4),1);
concentrationA4=zeros(length(Temp4),1);
concentrationB4=zeros(length(Temp4),1);

% Find monomer concentration x1 for every temperature T by solving the
% mass balance. These equations are highly non-linear and contain many
% asymptotes, which this complicated manual implementation avoids.
for i=1:length(Temp4)

    K2A=K2A_T(i);
    KA=KA_T(i);
    K2B=K2B_T(i);
    KB=KB_T(i);
        
    sa=K2A/KA;
    sb=K2B/KB;
    B=KB/KA;
    
    xtot=KA*ctot;
    
    b=1;
    a=-1;
    a0=0;
   
    if xtot < 1

        a=0.99*xtot; 
            f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
            xrange=[0;a];   
            while f<-1e15
                a=0.99*a;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
        
            b=a/0.99;
            while (f>0 && (b-a)>1e-15)
                a=(a+b)/2;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
            
            if (b-a)<1e-15
                x1(i,1)=b;
            end

            if f<-1e15
                x1(i,1)=a;
            end

        if ((b-a)>1e-15 && f<0 && f>-1e15)
            x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                xrange, options);
        end
    end

    if xtot > 1
        
        if 1/B >= 1
            
            a=0.99*1; 
            f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
            xrange=[a0;a];   
            while f<-1e15
                a=0.99*a;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end

            b=a/0.99;
            while (f>0 && (b-a)>1e-15)
                a=(a+b)/2;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
            
            if (b-a)<1e-15
                x1(i,1)=b;
            end

            if f<-1e15
                x1(i,1)=a;
            end
        

            if ((b-a)>1e-15 && f<0 && f>-1e15)
                x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                    xrange, options);
            end
        
        end
        
        if 1/B < 1
            
            a=0.99*(1/B); 
            f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
            xrange=[a0;a];   
            while f<-1e15
                a=0.99*a;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end

            b=a/0.99;
            while (f>0 && (b-a)>1e-15)
                a=(a+b)/2;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
            
            if (b-a)<1e-15
                x1(i,1)=b;
            end

            if f<-1e15
                x1(i,1)=a;
            end
        

            if ((b-a)>1e-15 && f<0 && f>-1e15)
                x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                    xrange, options);
            end
            
        end
        
    end
                
    if 1/B < 1 && xtot < 1
            
            if 1/B < xtot
                
                a=0.99*(1/B); 
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];   
                while f<-1e15
                    a=0.99*a;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                b=a/0.99;
                while (f>0 && (b-a)>1e-15)
                    a=(a+b)/2;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                if (b-a)<1e-15
                    x1(i,1)=b;
                end

                if f<-1e15
                    x1(i,1)=a;
                end


                if ((b-a)>1e-15 && f<0 && f>-1e15)
                    x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                        xrange, options);
                end
                
            end
            
            if 1/B > xtot
                
                a=0.99*xtot; 
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];   
                while f<-1e15
                    a=0.99*a;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                b=a/0.99;
                while (f>0 && (b-a)>1e-15)
                    a=(a+b)/2;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                if (b-a)<1e-15
                    x1(i,1)=b;
                end

                if f<-1e15
                    x1(i,1)=a;
                end


                if ((b-a)>1e-15 && f<0 && f>-1e15)
                    x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                        xrange, options);
                end
                
            end
                
    end
     % Calculate the concentrations of other species based on monomer
     % concentration.
     concentrationA4(i,1)=(1/KA)*sa*(x1(i,1)/((1-x1(i,1))^2)-x1(i,1));
     concentrationB4(i,1)=(1/KA)*sb*(x1(i,1)/((1-B*x1(i,1))^2)-x1(i,1));
     concentrationM4(i,1)=(1/KA)*x1(i,1);
end
   
% Calculate optical response based on molecular distributions
DE4CD=(sf(4,1)*(concentrationA4*depsa+concentrationB4*depsb));%/CONC(4);
DE4UV=(cfUV4*sf(4,2)*(concentrationM4*epsm+concentrationA4*epsa+concentrationB4*epsb));%/CONC(4);
DE4FL=(cfFL4*sf(4,3)*(concentrationA4*flinta+concentrationB4*flintb));%/CONC(4);

%% for fifth concentration:
% Set concentration
ctot=CONC(5);

% Calculate equilibrium constants at each temperature
K2A_T = exp(-(deltaH2A-Temp5.*deltaSA)./(R.*Temp5));
KA_T = exp(-(deltaHA-Temp5.*deltaSA)./(R.*Temp5));
K2B_T = exp(-(deltaH2B-Temp5.*deltaSB)./(R.*Temp5));
KB_T = exp(-(deltaHB-Temp5.*deltaSB)./(R.*Temp5));

% Create empty vectors to store monomer concentrations and dimensionless 
% concentrations of A, B and monomer. 
x1=zeros(length(Temp5),1);
concentrationM5=zeros(length(Temp5),1);
concentrationA5=zeros(length(Temp5),1);
concentrationB5=zeros(length(Temp5),1);

% Find monomer concentration x1 for every temperature T by solving the
% mass balance. These equations are highly non-linear and contain many
% asymptotes, which this complicated manual implementation avoids.
for i=1:length(Temp5)

    K2A=K2A_T(i);
    KA=KA_T(i);
    K2B=K2B_T(i);
    KB=KB_T(i);
        
    sa=K2A/KA;
    sb=K2B/KB;
    B=KB/KA;
    
    xtot=KA*ctot;
    
    b=1;
    a=-1;
    a0=0;
   
    if xtot < 1

        a=0.99*xtot; 
            f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
            xrange=[0;a];   
            while f<-1e15
                a=0.99*a;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
        
            b=a/0.99;
            while (f>0 && (b-a)>1e-15)
                a=(a+b)/2;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
            
            if (b-a)<1e-15
                x1(i,1)=b;
            end

            if f<-1e15
                x1(i,1)=a;
            end

        if ((b-a)>1e-15 && f<0 && f>-1e15)
            x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                xrange, options);
        end
    end

    if xtot > 1
        
        if 1/B >= 1
            
            a=0.99*1; 
            f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
            xrange=[a0;a];   
            while f<-1e15
                a=0.99*a;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end

            b=a/0.99;
            while (f>0 && (b-a)>1e-15)
                a=(a+b)/2;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
            
            if (b-a)<1e-15
                x1(i,1)=b;
            end

            if f<-1e15
                x1(i,1)=a;
            end
        

            if ((b-a)>1e-15 && f<0 && f>-1e15)
                x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                    xrange, options);
            end
        
        end
        
        if 1/B < 1
            
            a=0.99*(1/B); 
            f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
            xrange=[a0;a];   
            while f<-1e15
                a=0.99*a;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end

            b=a/0.99;
            while (f>0 && (b-a)>1e-15)
                a=(a+b)/2;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
            
            if (b-a)<1e-15
                x1(i,1)=b;
            end

            if f<-1e15
                x1(i,1)=a;
            end
        

            if ((b-a)>1e-15 && f<0 && f>-1e15)
                x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                    xrange, options);
            end
            
        end
        
    end
                
    if 1/B < 1 && xtot < 1
            
            if 1/B < xtot
                
                a=0.99*(1/B); 
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];   
                while f<-1e15
                    a=0.99*a;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                b=a/0.99;
                while (f>0 && (b-a)>1e-15)
                    a=(a+b)/2;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                if (b-a)<1e-15
                    x1(i,1)=b;
                end

                if f<-1e15
                    x1(i,1)=a;
                end


                if ((b-a)>1e-15 && f<0 && f>-1e15)
                    x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                        xrange, options);
                end
                
            end
            
            if 1/B > xtot
                
                a=0.99*xtot; 
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];   
                while f<-1e15
                    a=0.99*a;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                b=a/0.99;
                while (f>0 && (b-a)>1e-15)
                    a=(a+b)/2;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                if (b-a)<1e-15
                    x1(i,1)=b;
                end

                if f<-1e15
                    x1(i,1)=a;
                end


                if ((b-a)>1e-15 && f<0 && f>-1e15)
                    x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                        xrange, options);
                end
                
            end
                
    end
     % Calculate the concentrations of other species based on monomer
     % concentration.
     concentrationA5(i,1)=(1/KA)*sa*(x1(i,1)/((1-x1(i,1))^2)-x1(i,1));
     concentrationB5(i,1)=(1/KA)*sb*(x1(i,1)/((1-B*x1(i,1))^2)-x1(i,1));
     concentrationM5(i,1)=(1/KA)*x1(i,1);
end
   
% Calculate optical response based on molecular distributions
DE5CD=(sf(5,1)*(concentrationA5*depsa+concentrationB5*depsb));%/CONC(5);
DE5UV=(cfUV5*sf(5,2)*(concentrationM5*epsm+concentrationA5*epsa+concentrationB5*epsb));%/CONC(5);
DE5FL=(cfFL5*sf(5,3)*(concentrationA5*flinta+concentrationB5*flintb));%/CONC(5);

%% for sixth concentration:
% Set concentration
ctot=CONC(6);

% Calculate equilibrium constants at each temperature
K2A_T = exp(-(deltaH2A-Temp6.*deltaSA)./(R.*Temp6));
KA_T = exp(-(deltaHA-Temp6.*deltaSA)./(R.*Temp6));
K2B_T = exp(-(deltaH2B-Temp6.*deltaSB)./(R.*Temp6));
KB_T = exp(-(deltaHB-Temp6.*deltaSB)./(R.*Temp6));

% Create empty vectors to store monomer concentrations and dimensionless 
% concentrations of A, B and monomer. 
x1=zeros(length(Temp6),1);
concentrationM6=zeros(length(Temp6),1);
concentrationA6=zeros(length(Temp6),1);
concentrationB6=zeros(length(Temp6),1);

% Find monomer concentration x1 for every temperature T by solving the
% mass balance. These equations are highly non-linear and contain many
% asymptotes, which this complicated manual implementation avoids.
for i=1:length(Temp6)

    K2A=K2A_T(i);
    KA=KA_T(i);
    K2B=K2B_T(i);
    KB=KB_T(i);
        
    sa=K2A/KA;
    sb=K2B/KB;
    B=KB/KA;
    
    xtot=KA*ctot;
    
    b=1;
    a=-1;
    a0=0;
   
    if xtot < 1

        a=0.99*xtot; 
            f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
            xrange=[0;a];   
            while f<-1e15
                a=0.99*a;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
        
            b=a/0.99;
            while (f>0 && (b-a)>1e-15)
                a=(a+b)/2;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
            
            if (b-a)<1e-15
                x1(i,1)=b;
            end

            if f<-1e15
                x1(i,1)=a;
            end

        if ((b-a)>1e-15 && f<0 && f>-1e15)
            x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                xrange, options);
        end
    end

    if xtot > 1
        
        if 1/B >= 1
            
            a=0.99*1; 
            f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
            xrange=[a0;a];   
            while f<-1e15
                a=0.99*a;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end

            b=a/0.99;
            while (f>0 && (b-a)>1e-15)
                a=(a+b)/2;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
            
            if (b-a)<1e-15
                x1(i,1)=b;
            end

            if f<-1e15
                x1(i,1)=a;
            end
        

            if ((b-a)>1e-15 && f<0 && f>-1e15)
                x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                    xrange, options);
            end
        
        end
        
        if 1/B < 1
            
            a=0.99*(1/B); 
            f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
            xrange=[a0;a];   
            while f<-1e15
                a=0.99*a;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end

            b=a/0.99;
            while (f>0 && (b-a)>1e-15)
                a=(a+b)/2;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
            
            if (b-a)<1e-15
                x1(i,1)=b;
            end

            if f<-1e15
                x1(i,1)=a;
            end
        

            if ((b-a)>1e-15 && f<0 && f>-1e15)
                x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                    xrange, options);
            end
            
        end
        
    end
                
    if 1/B < 1 && xtot < 1
            
            if 1/B < xtot
                
                a=0.99*(1/B); 
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];   
                while f<-1e15
                    a=0.99*a;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                b=a/0.99;
                while (f>0 && (b-a)>1e-15)
                    a=(a+b)/2;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                if (b-a)<1e-15
                    x1(i,1)=b;
                end

                if f<-1e15
                    x1(i,1)=a;
                end


                if ((b-a)>1e-15 && f<0 && f>-1e15)
                    x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                        xrange, options);
                end
                
            end
            
            if 1/B > xtot
                
                a=0.99*xtot; 
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];   
                while f<-1e15
                    a=0.99*a;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                b=a/0.99;
                while (f>0 && (b-a)>1e-15)
                    a=(a+b)/2;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                if (b-a)<1e-15
                    x1(i,1)=b;
                end

                if f<-1e15
                    x1(i,1)=a;
                end


                if ((b-a)>1e-15 && f<0 && f>-1e15)
                    x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                        xrange, options);
                end
                
            end
                
    end
     % Calculate the concentrations of other species based on monomer
     % concentration.
     concentrationA6(i,1)=(1/KA)*sa*(x1(i,1)/((1-x1(i,1))^2)-x1(i,1));
     concentrationB6(i,1)=(1/KA)*sb*(x1(i,1)/((1-B*x1(i,1))^2)-x1(i,1));
     concentrationM6(i,1)=(1/KA)*x1(i,1);
end
   
% Calculate optical response based on molecular distributions
DE6CD=(sf(6,1)*(concentrationA6*depsa+concentrationB6*depsb));%/CONC(6);
DE6UV=(cfUV6*sf(6,2)*(concentrationM6*epsm+concentrationA6*epsa+concentrationB6*epsb));%/CONC(6);
% DE6FL=(sf(6,3)*(concentrationA6*flinta+concentrationB6*flintb));%/CONC(6);

%% for seventh concentration:
% Set concentration
ctot=CONC(7);

% Calculate equilibrium constants at each temperature
K2A_T = exp(-(deltaH2A-Temp7.*deltaSA)./(R.*Temp7));
KA_T = exp(-(deltaHA-Temp7.*deltaSA)./(R.*Temp7));
K2B_T = exp(-(deltaH2B-Temp7.*deltaSB)./(R.*Temp7));
KB_T = exp(-(deltaHB-Temp7.*deltaSB)./(R.*Temp7));

% Create empty vectors to store monomer concentrations and dimensionless 
% concentrations of A, B and monomer. 
x1=zeros(length(Temp7),1);
concentrationM7=zeros(length(Temp7),1);
concentrationA7=zeros(length(Temp7),1);
concentrationB7=zeros(length(Temp7),1);

% Find monomer concentration x1 for every temperature T by solving the
% mass balance. These equations are highly non-linear and contain many
% asymptotes, which this complicated manual implementation avoids.
for i=1:length(Temp7)

    K2A=K2A_T(i);
    KA=KA_T(i);
    K2B=K2B_T(i);
    KB=KB_T(i);
        
    sa=K2A/KA;
    sb=K2B/KB;
    B=KB/KA;
    
    xtot=KA*ctot;
    
    b=1;
    a=-1;
    a0=0;
   
    if xtot < 1

        a=0.99*xtot; 
            f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
            xrange=[0;a];   
            while f<-1e15
                a=0.99*a;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
        
            b=a/0.99;
            while (f>0 && (b-a)>1e-15)
                a=(a+b)/2;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
            
            if (b-a)<1e-15
                x1(i,1)=b;
            end

            if f<-1e15
                x1(i,1)=a;
            end

        if ((b-a)>1e-15 && f<0 && f>-1e15)
            x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                xrange, options);
        end
    end

    if xtot > 1
        
        if 1/B >= 1
            
            a=0.99*1; 
            f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
            xrange=[a0;a];   
            while f<-1e15
                a=0.99*a;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end

            b=a/0.99;
            while (f>0 && (b-a)>1e-15)
                a=(a+b)/2;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
            
            if (b-a)<1e-15
                x1(i,1)=b;
            end

            if f<-1e15
                x1(i,1)=a;
            end
        

            if ((b-a)>1e-15 && f<0 && f>-1e15)
                x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                    xrange, options);
            end
        
        end
        
        if 1/B < 1
            
            a=0.99*(1/B); 
            f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
            xrange=[a0;a];   
            while f<-1e15
                a=0.99*a;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end

            b=a/0.99;
            while (f>0 && (b-a)>1e-15)
                a=(a+b)/2;
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];
            end
            
            if (b-a)<1e-15
                x1(i,1)=b;
            end

            if f<-1e15
                x1(i,1)=a;
            end
        

            if ((b-a)>1e-15 && f<0 && f>-1e15)
                x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                    xrange, options);
            end
            
        end
        
    end
                
    if 1/B < 1 && xtot < 1
            
            if 1/B < xtot
                
                a=0.99*(1/B); 
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];   
                while f<-1e15
                    a=0.99*a;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                b=a/0.99;
                while (f>0 && (b-a)>1e-15)
                    a=(a+b)/2;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                if (b-a)<1e-15
                    x1(i,1)=b;
                end

                if f<-1e15
                    x1(i,1)=a;
                end


                if ((b-a)>1e-15 && f<0 && f>-1e15)
                    x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                        xrange, options);
                end
                
            end
            
            if 1/B > xtot
                
                a=0.99*xtot; 
                f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                xrange=[a0;a];   
                while f<-1e15
                    a=0.99*a;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                b=a/0.99;
                while (f>0 && (b-a)>1e-15)
                    a=(a+b)/2;
                    f=xtot-a-sa*(a/((1-a)^2)-a)-sb*(a/((1-B*a)^2)-a);
                    xrange=[a0;a];
                end

                if (b-a)<1e-15
                    x1(i,1)=b;
                end

                if f<-1e15
                    x1(i,1)=a;
                end


                if ((b-a)>1e-15 && f<0 && f>-1e15)
                    x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, sa, sb, B),...
                        xrange, options);
                end
                
            end
                
    end
     % Calculate the concentrations of other species based on monomer
     % concentration.
     concentrationA7(i,1)=(1/KA)*sa*(x1(i,1)/((1-x1(i,1))^2)-x1(i,1));
     concentrationB7(i,1)=(1/KA)*sb*(x1(i,1)/((1-B*x1(i,1))^2)-x1(i,1));
     concentrationM7(i,1)=(1/KA)*x1(i,1);
end
   
% Calculate optical response based on molecular distributions
DE7CD=(sf(7,1)*(concentrationA7*depsa+concentrationB7*depsb));%/CONC(7);
DE7UV=(cfUV7*sf(7,2)*(concentrationM7*epsm+concentrationA7*epsa+concentrationB7*epsb));%/CONC(7);
% DE7FL=(sf(7,3)*(concentrationA7*flinta+concentrationB7*flintb))/CONC(7);

%% Define the overall weighted cost function in format appropriate for lsqnonlin solver

c1cd=(DE1CD-CD1);
c1uv=(DE1UV-UV1);
c1fl=(DE1FL-FL1);
c2cd=(DE2CD-CD2);
c2uv=(DE2UV-UV2);
c2fl=(DE2FL-FL2);
c3cd=(DE3CD-CD3);
c3uv=(DE3UV-UV3);
c3fl=(DE3FL-FL3);
c4cd=(DE4CD-CD4);
c4uv=(DE4UV-UV4);
c4fl=(DE4FL-FL4);
c5cd=(DE5CD-CD5);
c5uv=(DE5UV-UV5);
c5fl=(DE5FL-FL5);
c6cd=(DE6CD-CD6);
c6uv=(DE6UV-UV6);
% c6fl=(DE6FL-FL6);
c7cd=(DE7CD-CD7);
c7uv=(DE7UV-UV7);
% c7fl=(DE7FL-FL7);

c=[c1cd; c1uv; c1fl; c2cd; c2uv; c2fl; c3cd; c3uv; c3fl; c4cd; c4uv; c4fl;...
    c5cd; c5uv; c5fl; c6cd; c6uv; c7cd; c7uv]; % c6fl; c7fl];

end



