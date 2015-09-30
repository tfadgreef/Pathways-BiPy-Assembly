% AnalyzerPredictionUncertainty_SP
% This script is a separate instance of the mass balance solver for use by
% the nlpredci command in AnalyzerThermodynamicFit_SP.m. The separate
% script is required because of the specific format of the call by
% nlpredci.

function ypred=AnalyzerPredictionUncertainty_SP(par,Tvector,n)
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

CONC=[1e-6, 2.5e-6, 5e-6, 1e-5, 2.5e-5, 5e-5, 1e-4]; N=length(CONC);

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
Temp=cell(7,1);
Temp{1,1}=Temp1; Temp{2,1}=Temp2; Temp{3,1}=Temp3; Temp{4,1}=Temp4; Temp{5,1}=Temp5; Temp{6,1}=Temp6; Temp{7,1}=Temp7;

DECD=cell(N,1);
DEUV=cell(N,1);
DEFL=cell(N,1);

% Get thermodynamic parameters
deltaHnuc=par(1);
deltaSnuc=par(2);
deltaHel=par(3);
deltaSel=par(4);
epsm=7.00e4;
depsa=6.52e1;
epsa=5.27e4;
flinta=3.45e4;
depsb=3.80e6;
epsb=6.49e4;
flintb=3.50e4;
cfUV1=1.61;
cfUV2=0.95;
cfUV3=0.76;
cfUV4=0.62;
cfUV5=0.57;
cfUV6=0.77;
cfUV7=0.66;
cfFL1=1.69;
cfFL2=1.33;
cfFL3=1.23;
cfFL4=0.93;
cfFL5=0.55;
cfUV=[cfUV1 cfUV2 cfUV3 cfUV4 cfUV5 cfUV6 cfUV7];
cfFL=[cfFL1 cfFL2 cfFL3 cfFL4 cfFL5];

R=8.314472; 

% Solve the mass balance
for k=1:N
    % Cycle over concentrations:
    ctot=CONC(k);

    % Calculate equilibrium constants at each temperature
    Knuc_T = exp(-(deltaHnuc-Temp{k,1}.*deltaSnuc)./(R.*Temp{k,1}));
    Kel_T = exp(-(deltaHel-Temp{k,1}.*deltaSel)./(R.*Temp{k,1}));

    % Create empty vectors to store monomer concentrations and dimensionless 
    % concentrations of A, B and monomer. 
    x1=zeros(length(Temp{k,1}),1);
    concentration_m=zeros(length(Temp{k,1}),1);
    concentration_o=zeros(length(Temp{k,1}),1);
    concentration_p=zeros(length(Temp{k,1}),1);

    % Find monomer concentration x1 for every temperature T
    for i=1:length(Temp{k,1})

        Knuc=Knuc_T(i);
        Kel=Kel_T(i);
        s=Knuc/Kel; % Cooperativity

        xtot=Kel*ctot;

        b=1;
        a=-1;
        a0=0;

        if xtot < 1

            a=0.99*xtot; 
                f=xtot-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                xrange=[0;a];   
                while f<-1e15
                    a=0.99*a;
                    f=xtot-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                    xrange=[a0;a];
                end

                b=a/0.99;
                while (f>0 && (b-a)>1e-15)
                    a=(a+b)/2;
                    f=xtot-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                    xrange=[a0;a];
                end

                if (b-a)<1e-15
                    x1(i,1)=b;
                end

                if f<-1e15
                    x1(i,1)=a;
                end

            if ((b-a)>1e-15 && f<0 && f>-1e15)
                x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_SP(x1, xtot, s, n),...
                    xrange, options);
            end
        end

        if xtot > 1

            a=0.99*1; 
            f=xtot-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
            xrange=[a0;a];   
            while f<-1e15
                a=0.99*a;
                f=xtot-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                xrange=[a0;a];
            end

            b=a/0.99;
            while (f>0 && (b-a)>1e-15)
                a=(a+b)/2;
                f=xtot-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                xrange=[a0;a];
            end

            if (b-a)<1e-15
                x1(i,1)=b;
            end

            if f<-1e15
                x1(i,1)=a;
            end


            if ((b-a)>1e-15 && f<0 && f>-1e15)
                x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_SP(x1, xtot, s, n),...
                    xrange, options);
            end

        end

        if 1/s < xtot && s > 1

                a=0.99*(1/s); 
                f=xtot-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                xrange=[a0;a];   
                while f<-1e15
                    a=0.99*a;
                    f=xtot-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                    xrange=[0;a];
                end

                if f > 0
                    b=a/0.99;
                    while (f>0 && (b-a)>1e-15)
                        a=(a+b)/2;
                        f=xtot-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                        xrange=[0;a];
                    end

                    if (b-a)<1e-15
                        x1(i,1)=b;
                    end

                    if f<-1e15
                        x1(i,1)=a;
                    end
                end

                if ((b-a)>1e-15 && f<0 && f>-1e15)
                    x1(i,1) = fzero(@(x1) AnalyzerPredMassBalance_SP(x1, xtot, s, n),...
                        xrange, options);
                end

        end
        
        % Calculate concentrations of all species
         concentration_m(i,1)=(1/Kel)*x1(i,1);
         conc_o=zeros(n,1);
         for jj=2:n
             conc_o(jj)=jj*(1/Kel)*s^(jj-1)*x1(i,1)^jj;
         end
         conc_jj_cum=sum(conc_o);
         concentration_o(i,1)=conc_jj_cum;
         concentration_p(i,1)=ctot-concentration_o(i,1)-concentration_m(i,1);
    end

    DECD{k,1}=(sf(k,1)*(concentration_o*depsa+concentration_p*depsb));
    DEUV{k,1}=(cfUV(1,k)*sf(k,2)*(concentration_m*epsm+concentration_o*epsa+concentration_p*epsb));
    if k < 6
        DEFL{k,1}=(cfFL(1,k)*sf(k,3)*(concentration_o*flinta+concentration_p*flintb));
    end
end

ypred=[DECD{1,1}; DEUV{1,1}; DEFL{1,1}; DECD{2,1}; DEUV{2,1}; DEFL{2,1}; DECD{3,1}; ...
    DEUV{3,1}; DEFL{3,1}; DECD{4,1}; DEUV{4,1}; DEFL{4,1}; DECD{5,1}; DEUV{5,1}; DEFL{5,1}; ...
    DECD{6,1}; DEUV{6,1}; DECD{7,1}; DEUV{7,1}];

end



