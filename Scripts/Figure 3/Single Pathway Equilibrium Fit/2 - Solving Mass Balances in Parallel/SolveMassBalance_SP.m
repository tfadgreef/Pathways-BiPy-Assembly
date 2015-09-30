% SolveMassBalance_SP
% Model description for a single-pathway self-assembly process. This script
% uses the input thermodynamic parameters to calculate molecular 
% distributions as a function of temperature, and converts these to CD, UV 
% and fluorescence traces as output. 
% InitiateVariableTemperatureFit_SP.m is used to call this script iteratively, 
% while adapting parameter values. 

function c=SolveMassBalance_SP(par,Temp,CD,UV,FL,...
           CONC,sf,n)
format long
options=optimset('Display', 'off', 'TolFun', 1e-18);

% Number of concentrations
N=length(CONC);

% Set self-assembly parameters. These are thermodynamics of self-assembly
% (1-4), optical parameters (5-11) and correction factors for spectroscopic
% non-linearities.
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

% Initiate storage cell structures for simulated traces
DECD=cell(N,1);
DEUV=cell(N,1);
DEFL=cell(N,1);

R=8.3145;           

for k=1:N
    % Set concentration:
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

    % Find monomer concentration x1 for every temperature T by solving the
    % mass balance. These equations are highly non-linear and contain many
    % asymptotes, which this complicated manual implementation avoids.
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
                x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, s, n),...
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
                x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, s, n),...
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
                    x1(i,1) = fzero(@(x1) MassBalanceExpression_SP(x1, xtot, s, n),...
                        xrange, options);
                end

        end

        % Calculate the concentrations of other species based on monomer
        % concentration.
         concentration_m(i,1)=(1/Kel)*x1(i,1);
         conc_o=zeros(n,1);
         for jj=2:n
             conc_o(jj)=jj*Knuc^(jj-1)*concentration_m(i,1)^jj;
         end
         conc_jj_cum=sum(conc_o);
         concentration_o(i,1)=conc_jj_cum;
         concentration_p(i,1)=ctot-concentration_o(i,1)-concentration_m(i,1);

    end

    % Calculate optical response based on molecular distributions
    DECD{k,1}=(sf(k,1)*(concentration_o*depsa+concentration_p*depsb));%/CONC(k);
    DEUV{k,1}=(cfUV(1,k)*sf(k,2)*(concentration_m*epsm+concentration_o*epsa+concentration_p*epsb));%/CONC(k);
    if k < 6
        DEFL{k,1}=(cfFL(1,k)*sf(k,3)*(concentration_o*flinta+concentration_p*flintb));%/CONC(k);
    end
end

%% Define the overall weighted cost function in format appropriate for lsqnonlin solver

c1cd=(DECD{1,1}-CD{1,1});
c1uv=(DEUV{1,1}-UV{1,1});
c1fl=(DEFL{1,1}-FL{1,1});
c2cd=(DECD{2,1}-CD{2,1});
c2uv=(DEUV{2,1}-UV{2,1});
c2fl=(DEFL{2,1}-FL{2,1});
c3cd=(DECD{3,1}-CD{3,1});
c3uv=(DEUV{3,1}-UV{3,1});
c3fl=(DEFL{3,1}-FL{3,1});
c4cd=(DECD{4,1}-CD{4,1});
c4uv=(DEUV{4,1}-UV{4,1});
c4fl=(DEFL{4,1}-FL{4,1});
c5cd=(DECD{5,1}-CD{5,1});
c5uv=(DEUV{5,1}-UV{5,1});
c5fl=(DEFL{5,1}-FL{5,1});
c6cd=(DECD{6,1}-CD{6,1});
c6uv=(DEUV{6,1}-UV{6,1});
c7cd=(DECD{7,1}-CD{7,1});
c7uv=(DEUV{7,1}-UV{7,1});

c=[c1cd; c1uv; c1fl; c2cd; c2uv; c2fl; c3cd; c3uv; c3fl; c4cd; c4uv; c4fl;...
    c5cd; c5uv; c5fl; c6cd; c6uv; c7cd; c7uv]; 

end



