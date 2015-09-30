% AnalyzerPredictionUncertainty_TP
% This script is a separate instance of the mass balance solver for use by
% the nlpredci command in AnalyzerThermodynamicFit_TP.m. The separate
% script is required because of the specific format of the call by
% nlpredci.

function ypred=AnalyzerPredictionUncertainty_TP(par,Tvector)
format long
options=optimset('Display', 'off', 'TolFun', 1e-18);

% Load input files
data1=load('1e-6M.txt');
sizedata1=size(data1,1);
data2=load('2-5e-6M.txt');
sizedata2=size(data2,1);
data3=load('5e-6M.txt');
sizedata3=size(data3,1);
data4=load('1e-5M.txt');
sizedata4=size(data4,1);
data5=load('2-5e-5M.txt');
sizedata5=size(data5,1);
data6=load('5e-5M.txt');
sizedata6=size(data6,1);
data7=load('1e-4M.txt');
sizedata7=size(data7,1);

CONC=[1e-6, 2.5e-6, 5e-6, 1e-5, 2.5e-5, 5e-5, 1e-4];

sf=[(1/4),(100),(16);(1/9),(40),(8);(1/20),(16),(4);(1/38),(9),(2.5);(1/100),(3),(2);(1/210),(10/6),(0);(1/420),(1),(0)];

Temp1=Tvector(1:sizedata1,1);
sizecounter=sizedata1;
Temp2=Tvector(sizecounter+1:sizecounter+sizedata2,1);
sizecounter=sizecounter+sizedata2;
Temp3=Tvector(sizecounter+1:sizecounter+sizedata3,1);
sizecounter=sizecounter+sizedata3;
Temp4=Tvector(sizecounter+1:sizecounter+sizedata4,1);
sizecounter=sizecounter+sizedata4;
Temp5=Tvector(sizecounter+1:sizecounter+sizedata5,1);
sizecounter=sizecounter+sizedata5;
Temp6=Tvector(sizecounter+1:sizecounter+sizedata6,1);
sizecounter=sizecounter+sizedata6;
Temp7=Tvector(sizecounter+1:sizecounter+sizedata7,1);

% Get parameters
dH2A=par(1);
dHA=par(2);
dSA=par(3);
dH2B=par(4);
dHB=par(5);
dSB=par(6);
Em=par(7);
dEa=par(8);
Ea=par(9);
FLa=par(10);
dEb=par(11);
Eb=par(12);
FLb=par(13);
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
cf=[cfUV1 cfFL1;cfUV2 cfFL2;cfUV3 cfFL3;cfUV4 cfFL4;cfUV5 cfFL5;cfUV6 1;cfUV7 1];

R=8.314472;           %gas constant

% for first concentration:
ctot=CONC(1);

%Calculate equilibrium constants at each temperature + cooperativity
K2A_T = exp(-(dH2A-Temp1.*dSA)./(R.*Temp1));
KA_T = exp(-(dHA-Temp1.*dSA)./(R.*Temp1));
K2B_T = exp(-(dH2B-Temp1.*dSB)./(R.*Temp1));
KB_T = exp(-(dHB-Temp1.*dSB)./(R.*Temp1));

%Allocate array of monomer concentrations. 
x1=zeros(length(Temp1),1);
concentrationM1=zeros(length(Temp1),1);
concentrationA1=zeros(length(Temp1),1);
concentrationB1=zeros(length(Temp1),1);

% find monomer concentration x for every temperature T
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
            x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                    x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                    x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
                        xrange, options);
                end
                
            end
                
     end
     concentrationA1(i,1)=(1/KA)*sa*(x1(i,1)/((1-x1(i,1))^2)-x1(i,1));
     concentrationB1(i,1)=(1/KA)*sb*(x1(i,1)/((1-B*x1(i,1))^2)-x1(i,1));
     concentrationM1(i,1)=(1/KA)*x1(i,1);
end
    
DE1CD=(sf(1,1)*(concentrationA1*dEa+concentrationB1*dEb));%/CONC(1);
DE1UV=(cf(1,1)*sf(1,2)*(concentrationM1*Em+concentrationA1*Ea+concentrationB1*Eb));%/CONC(1);
DE1FL=(cf(2,1)*sf(1,3)*(concentrationA1*FLa+concentrationB1*FLb));%/CONC(1);


% for second concentration:
ctot=CONC(2);

%Calculate equilibrium constants at each temperature + cooperativity
K2A_T = exp(-(dH2A-Temp2.*dSA)./(R.*Temp2));
KA_T = exp(-(dHA-Temp2.*dSA)./(R.*Temp2));
K2B_T = exp(-(dH2B-Temp2.*dSB)./(R.*Temp2));
KB_T = exp(-(dHB-Temp2.*dSB)./(R.*Temp2));

%Allocate array of monomer concentrations. 
x1=zeros(length(Temp2),1);
concentrationM2=zeros(length(Temp2),1);
concentrationA2=zeros(length(Temp2),1);
concentrationB2=zeros(length(Temp2),1);

% find monomer concentration x for every temperature T
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
            x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                    x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                    x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
                        xrange, options);
                end
                
            end
                
    end
    concentrationA2(i,1)=(1/KA)*sa*(x1(i,1)/((1-x1(i,1))^2)-x1(i,1));
    concentrationB2(i,1)=(1/KA)*sb*(x1(i,1)/((1-B*x1(i,1))^2)-x1(i,1));
    concentrationM2(i,1)=(1/KA)*x1(i,1);
end
    
DE2CD=(sf(2,1)*(concentrationA2*dEa+concentrationB2*dEb));
DE2UV=(cf(2,1)*sf(2,2)*(concentrationM2*Em+concentrationA2*Ea+concentrationB2*Eb));
DE2FL=(cf(2,2)*sf(2,3)*(concentrationA2*FLa+concentrationB2*FLb));

% for third concentration:
ctot=CONC(3);

%Calculate equilibrium constants at each temperature + cooperativity
K2A_T = exp(-(dH2A-Temp3.*dSA)./(R.*Temp3));
KA_T = exp(-(dHA-Temp3.*dSA)./(R.*Temp3));
K2B_T = exp(-(dH2B-Temp3.*dSB)./(R.*Temp3));
KB_T = exp(-(dHB-Temp3.*dSB)./(R.*Temp3));

%Allocate array of monomer concentrations. 
x1=zeros(length(Temp3),1);
concentrationM3=zeros(length(Temp3),1);
concentrationA3=zeros(length(Temp3),1);
concentrationB3=zeros(length(Temp3),1);

% find monomer concentration x for every temperature T
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
            x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                    x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                    x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
                        xrange, options);
                end
                
            end
                
    end
    concentrationA3(i,1)=(1/KA)*sa*(x1(i,1)/((1-x1(i,1))^2)-x1(i,1));
    concentrationB3(i,1)=(1/KA)*sb*(x1(i,1)/((1-B*x1(i,1))^2)-x1(i,1));
    concentrationM3(i,1)=(1/KA)*x1(i,1);
end
    
DE3CD=(sf(3,1)*(concentrationA3*dEa+concentrationB3*dEb));
DE3UV=(cf(3,1)*sf(3,2)*(concentrationM3*Em+concentrationA3*Ea+concentrationB3*Eb));
DE3FL=(cf(3,2)*sf(3,3)*(concentrationA3*FLa+concentrationB3*FLb));

% for fourth concentration:
ctot=CONC(4);

%Calculate equilibrium constants at each temperature + cooperativity
K2A_T = exp(-(dH2A-Temp4.*dSA)./(R.*Temp4));
KA_T = exp(-(dHA-Temp4.*dSA)./(R.*Temp4));
K2B_T = exp(-(dH2B-Temp4.*dSB)./(R.*Temp4));
KB_T = exp(-(dHB-Temp4.*dSB)./(R.*Temp4));

%Allocate array of monomer concentrations. 
x1=zeros(length(Temp4),1);
concentrationM4=zeros(length(Temp4),1);
concentrationA4=zeros(length(Temp4),1);
concentrationB4=zeros(length(Temp4),1);

% find monomer concentration x for every temperature T
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
            x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                    x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                    x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
                        xrange, options);
                end
                
            end
                
    end
    concentrationA4(i,1)=(1/KA)*sa*(x1(i,1)/((1-x1(i,1))^2)-x1(i,1));
    concentrationB4(i,1)=(1/KA)*sb*(x1(i,1)/((1-B*x1(i,1))^2)-x1(i,1));
    concentrationM4(i,1)=(1/KA)*x1(i,1);
end
    
DE4CD=(sf(4,1)*(concentrationA4*dEa+concentrationB4*dEb));
DE4UV=(cf(4,1)*sf(4,2)*(concentrationM4*Em+concentrationA4*Ea+concentrationB4*Eb));
DE4FL=(cf(4,2)*sf(4,3)*(concentrationA4*FLa+concentrationB4*FLb));


% for fifth concentration:
ctot=CONC(5);

%Calculate equilibrium constants at each temperature + cooperativity
K2A_T = exp(-(dH2A-Temp5.*dSA)./(R.*Temp5));
KA_T = exp(-(dHA-Temp5.*dSA)./(R.*Temp5));
K2B_T = exp(-(dH2B-Temp5.*dSB)./(R.*Temp5));
KB_T = exp(-(dHB-Temp5.*dSB)./(R.*Temp5));

%Allocate array of monomer concentrations. 
x1=zeros(length(Temp5),1);
concentrationM5=zeros(length(Temp5),1);
concentrationA5=zeros(length(Temp5),1);
concentrationB5=zeros(length(Temp5),1);

% find monomer concentration x for every temperature T
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
            x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                    x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                    x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
                        xrange, options);
                end
                
            end
                
    end
    concentrationA5(i,1)=(1/KA)*sa*(x1(i,1)/((1-x1(i,1))^2)-x1(i,1));
    concentrationB5(i,1)=(1/KA)*sb*(x1(i,1)/((1-B*x1(i,1))^2)-x1(i,1));
    concentrationM5(i,1)=(1/KA)*x1(i,1);
end
    
DE5CD=(sf(5,1)*(concentrationA5*dEa+concentrationB5*dEb));
DE5UV=(cf(5,1)*sf(5,2)*(concentrationM5*Em+concentrationA5*Ea+concentrationB5*Eb));
DE5FL=(sf(5,2)*sf(5,3)*(concentrationA5*FLa+concentrationB5*FLb));

% for sixth concentration:
ctot=CONC(6);

%Calculate equilibrium constants at each temperature + cooperativity
K2A_T = exp(-(dH2A-Temp6.*dSA)./(R.*Temp6));
KA_T = exp(-(dHA-Temp6.*dSA)./(R.*Temp6));
K2B_T = exp(-(dH2B-Temp6.*dSB)./(R.*Temp6));
KB_T = exp(-(dHB-Temp6.*dSB)./(R.*Temp6));

%Allocate array of monomer concentrations. 
x1=zeros(length(Temp6),1);
concentrationM6=zeros(length(Temp6),1);
concentrationA6=zeros(length(Temp6),1);
concentrationB6=zeros(length(Temp6),1);

% find monomer concentration x for every temperature T
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
            x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                    x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                    x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
                        xrange, options);
                end
                
            end
                
    end
    concentrationA6(i,1)=(1/KA)*sa*(x1(i,1)/((1-x1(i,1))^2)-x1(i,1));
    concentrationB6(i,1)=(1/KA)*sb*(x1(i,1)/((1-B*x1(i,1))^2)-x1(i,1));
    concentrationM6(i,1)=(1/KA)*x1(i,1);
end
    
DE6CD=(sf(6,1)*(concentrationA6*dEa+concentrationB6*dEb));
DE6UV=(cf(6,1)*sf(6,2)*(concentrationM6*Em+concentrationA6*Ea+concentrationB6*Eb));
% DE6FL=(cf(6,2)*sf(6,3)*(concentrationA6*FLa+concentrationB6*FLb));

% for seventh concentration:
ctot=CONC(7);

%Calculate equilibrium constants at each temperature + cooperativity
K2A_T = exp(-(dH2A-Temp7.*dSA)./(R.*Temp7));
KA_T = exp(-(dHA-Temp7.*dSA)./(R.*Temp7));
K2B_T = exp(-(dH2B-Temp7.*dSB)./(R.*Temp7));
KB_T = exp(-(dHB-Temp7.*dSB)./(R.*Temp7));

%Allocate array of monomer concentrations. 
x1=zeros(length(Temp7),1);
concentrationM7=zeros(length(Temp7),1);
concentrationA7=zeros(length(Temp7),1);
concentrationB7=zeros(length(Temp7),1);

% find monomer concentration x for every temperature T
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
            x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                    x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
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
                    x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_TP(x1, xtot, sa, sb, B),...
                        xrange, options);
                end
                
            end
                
    end
    concentrationA7(i,1)=(1/KA)*sa*(x1(i,1)/((1-x1(i,1))^2)-x1(i,1));
    concentrationB7(i,1)=(1/KA)*sb*(x1(i,1)/((1-B*x1(i,1))^2)-x1(i,1));
    concentrationM7(i,1)=(1/KA)*x1(i,1);
end
    
DE7CD=(sf(7,1)*(concentrationA7*dEa+concentrationB7*dEb));
DE7UV=(cf(7,1)*sf(7,2)*(concentrationM7*Em+concentrationA7*Ea+concentrationB7*Eb));
% DE7FL=(cf(7,2)*sf(7,3)*(concentrationA7*FLa+concentrationB7*FLb));

% Define the actual weighted cost function

ypred=[DE1CD; DE1UV; DE1FL; DE2CD; DE2UV; DE2FL; DE3CD; ...
    DE3UV; DE3FL; DE4CD; DE4UV; DE4FL; DE5CD; DE5UV; DE5FL; ...
    DE6CD; DE6UV; DE7CD; DE7UV];

end



