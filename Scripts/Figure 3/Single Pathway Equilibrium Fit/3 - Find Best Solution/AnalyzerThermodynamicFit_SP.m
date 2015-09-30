% AnalyzerThermodynamicFit_SP
% This script finds the best fits from the large LHS-sampled fitting procedure. The best fit
% is identified for each nucleus size and determined using the residual sum of squares.
% Additionally, using the optimal thermodynamic data, it plots the overlay
% of the best fit on the data, and calculates a pseuso-phase diagram
% describing the molecular distributions as a function of concentration and
% temperature. 

clear all
close all
clc

% Set properties for fit overlay
J=400;
kkend=1000;
Tdist=[273:5:353]; Tdist_l=length(Tdist);
n_max=10;
N=7;
FinalFitResults=zeros(n_max,3);
CurrentDomain=cd; % Save current (parent) domain. Daughter folders should be named NucleusSize_2 etc.

% Load experimental data
data1=load('1e-6M.txt');
Temp1=data1(:,1)+273;
CD1=(data1(:,2)-0.749945);
UV1=(data1(:,4)-0.91902);
FL1=(data1(:,5)-0.026011);

data2=load('2-5e-6M.txt');
Temp2=data2(:,1)+273;
CD2=(data2(:,2)-0.749945);
UV2=(data2(:,4)-0.91902);
FL2=(data2(:,5)-0.026011);

data3=load('5e-6M.txt');
Temp3=data3(:,1)+273;
CD3=(data3(:,2)-0.749945);
UV3=(data3(:,4)-0.91902);
FL3=(data3(:,5)-0.026011);

data4=load('1e-5M.txt');
Temp4=data4(:,1)+273;
CD4=(data4(:,2)-0.749945);
UV4=(data4(:,4)-0.91902);
FL4=(data4(:,5)-0.026011);

data5=load('2-5e-5M.txt');
Temp5=data5(:,1)+273;
CD5=(data5(:,2)-0.749945);
UV5=(data5(:,4)-0.91902);
FL5=(data5(:,5)-0.026011);

data6=load('5e-5M.txt');
Temp6=data6(:,1)+273;
CD6=10*(data6(:,2)-0.749945);   % Values for this sample are corrected by a
UV6=10*(data6(:,4)-0.91902);    % factor 10, as these were measured in a cuvette
%FL6=10*(data6(:,5)-0.026011);  % with d=1mm compared to the normal d=10mm.

data7=load('1e-4M.txt');
Temp7=data7(:,1)+273;
CD7=10*(data7(:,2)-0.749945);   % Values for this sample are corrected by a 
UV7=10*(data7(:,4)-0.91902);    % factor 10, as these were measured in a cuvette
%FL7=10*(data7(:,5)-0.026011);

% Initiate storage structures
Temp=cell(7,1);
Temp{1,1}=Temp1; Temp{2,1}=Temp2; Temp{3,1}=Temp3; Temp{4,1}=Temp4; Temp{5,1}=Temp5; Temp{6,1}=Temp6; Temp{7,1}=Temp7;
CD=cell(7,1);
CD{1,1}=CD1; CD{2,1}=CD2; CD{3,1}=CD3; CD{4,1}=CD4; CD{5,1}=CD5; CD{6,1}=CD6; CD{7,1}=CD7;
UV=cell(7,1);
UV{1,1}=UV1; UV{2,1}=UV2; UV{3,1}=UV3; UV{4,1}=UV4; UV{5,1}=UV5; UV{6,1}=UV6; UV{7,1}=UV7;
FL=cell(7,1);
FL{1,1}=FL1; FL{2,1}=FL2; FL{3,1}=FL3; FL{4,1}=FL4; FL{5,1}=FL5; %FL{6,1}=FL6; FL{7,1}=FL7;

resCD=cell(N,1);
resUV=cell(N,1);
resFL=cell(N,1);

% Set properties of determined energy landscape
TES=273:20:353; % Temperatures for saving the energy landscape. These values should be present in all Temp{k,1} vectors.
nTES=length(TES);
niES=20; % Maximum aggregate size to calculate the energy landscape for. 
EnergyScape=zeros(nTES,niES,n_max,N); % Save energy landscape in 4-dimensional structure. Dimensions are: 1 Temperature 2 Aggregate Size 3 Nucleus Size 4 Concentration

% Cycle over fits for different nucleus sizes
for n=2:n_max
    
    DataDomain=[CurrentDomain '\NucleusSize_' num2str(n)];
    AnalysisDomain=[CurrentDomain '\NucleusSize_' num2str(n) '\AnalysisResults'];
    
    cd(DataDomain);
    
    % Determine best fit for this nucleus size.
    NVR=[];
    for j=1:J
        try
            a=['load resnorm_n' num2str(n) '_j' num2str(j) '.mat'];
            eval(a); 
            NVR=[NVR;[j resnorm]];
        catch
            unsuccessful=[n  j];
        end
    end

    [~,I]=sort(NVR(:,2),1,'ascend');
    par_fin_best=[];
    NVR_best=NVR(I(1:5,:),1);
    for i=1:5
        a=['load par_fin_n' num2str(n) '_j' num2str(NVR_best(i)),'.mat'];
        eval(a);
        b=['load resnorm_n' num2str(n) '_j' num2str(NVR_best(i)),'.mat'];
        eval(b);
        par_fin_best(:,i)=par_fin';                     %These are the final parameters from the best simulations
        resnorm_best(i)=resnorm;                        
    end

    load param.mat
    par_init=param(NVR_best,:)';
    save(strcat('Par_Init_n',num2str(n),'.txt'),'par_init','-ASCII')

    % Load output files for best fit
    ind=1;
    I=NVR_best(ind);
    Y=resnorm_best(ind);
    resnorm=(['load resnorm_n' num2str(n) '_j' num2str(I) '.mat']);
    par_fin=(['load par_fin_n' num2str(n) '_j' num2str(I) '.mat']); 
    Jacobian=['load jacobian_n' num2str(n) '_j' num2str(I) '.mat'];
    lambda=(['load lagrangian_n' num2str(n) '_j' num2str(I) '.mat']);
    residual=['load residual_n' num2str(n) '_j' num2str(I) '.mat'];
    eval(resnorm);
    eval(par_fin); 
    eval(Jacobian); 
    eval(lambda);
    eval(residual);
    
    FinalFitResults(n,:)=[n I Y];

    cd(AnalysisDomain);
    
    % Calculate errors in parameters using nlparci

    % About 68% of values drawn from a normal distribution are within one
    % standard deviation ? > 0 away from the mean ?; about 95% of the values
    % are within two standard deviations and about 99.7% lie within three
    % standard deviations. This is known as the "68-95-99.7 rule" or the
    % "empirical rule" or the "3-sigma rule."
    conflevel=0.05; % select confidence level
    ci = nlparci(par_fin,residual,'jacobian',Jacobian,'alpha',conflevel);

    % Compute confidence interval using nlparci (using Fischer Information
    % Matrix)
    tsd = tinv(1-conflevel/2,length(residual)-length(par_fin));
    % Convert confidence intervals to standard deviations
    par_sd = (ci(:,2)-ci(:,1)) ./ (2*tsd); 
    par_fin_t=par_fin';
    ParSD=[par_fin_t-par_sd par_fin_t par_fin_t+par_sd];
    ParSD_2=[par_fin_t par_sd];
    save(strcat('Par_SD_n',num2str(n),'.txt'),'ParSD','-ASCII')
    save(strcat('Par_SD_2_n',num2str(n),'.txt'),'ParSD_2','-ASCII')

    % Calculate errors in function values using nlpredci. 
    Tvector=[];
    Sizevector=zeros(N,1);
    SizevectorCum=zeros(N,1);

    for o=1:N
        Ttemp=Temp{o,1};
        Sizevector(o,1)=size(Ttemp,1);
        Tvector=[Tvector;Ttemp(:,1)];
    end

    for m=2:N
        if m <= 6
            SizevectorCum(m,1)=SizevectorCum(m-1,1)+3*Sizevector(m-1);
        else
            SizevectorCum(m,1)=SizevectorCum(m-1,1)+2*Sizevector(m-1);
        end
    end    

    sf=[(1/4),(100),(16);(1/9),(40),(8);(1/20),(16),(4);(1/38),(9),(2.5);(1/100),(3),(2);(1/210),(10/6),(0);(1/420),(1),(0)];
    cd(CurrentDomain);
    [ypred,delta]=nlpredci(@(par_fin,Tvector)AnalyzerPredictionUncertainty_SP(par_fin,Tvector,n),Tvector,par_fin,residual,'jacobian',full(Jacobian),'alpha',0.05);
    
    % Some bookkeeping is involved due to the structure enforced by lsqnonlin.
    cd(AnalysisDomain);
    ypred1CD=ypred((SizevectorCum(1,1)+1):(SizevectorCum(1,1)+Sizevector(1,1)),1)./sf(1,1);
    ypred1UV=ypred((SizevectorCum(1,1)+Sizevector(1,1)+1):(SizevectorCum(1,1)+2*Sizevector(1,1)),1)./sf(1,2);
    ypred1FL=ypred((SizevectorCum(1,1)+2*Sizevector(1,1)+1):(SizevectorCum(1,1)+3*Sizevector(1,1)),1)./sf(1,3);
    ypred2CD=ypred((SizevectorCum(2,1)+1):(SizevectorCum(2,1)+Sizevector(2,1)),1)./sf(2,1);
    ypred2UV=ypred((SizevectorCum(2,1)+Sizevector(2,1)+1):(SizevectorCum(2,1)+2*Sizevector(2,1)),1)./sf(2,2);
    ypred2FL=ypred((SizevectorCum(2,1)+2*Sizevector(2,1)+1):(SizevectorCum(2,1)+3*Sizevector(2,1)),1)./sf(2,3);
    ypred3CD=ypred((SizevectorCum(3,1)+1):(SizevectorCum(3,1)+Sizevector(3,1)),1)./sf(3,1);
    ypred3UV=ypred((SizevectorCum(3,1)+Sizevector(3,1)+1):(SizevectorCum(3,1)+2*Sizevector(3,1)),1)./sf(3,2);
    ypred3FL=ypred((SizevectorCum(3,1)+2*Sizevector(3,1)+1):(SizevectorCum(3,1)+3*Sizevector(3,1)),1)./sf(3,3);
    ypred4CD=ypred((SizevectorCum(4,1)+1):(SizevectorCum(4,1)+Sizevector(4,1)),1)./sf(4,1);
    ypred4UV=ypred((SizevectorCum(4,1)+Sizevector(4,1)+1):(SizevectorCum(4,1)+2*Sizevector(4,1)),1)./sf(4,2);
    ypred4FL=ypred((SizevectorCum(4,1)+2*Sizevector(4,1)+1):(SizevectorCum(4,1)+3*Sizevector(4,1)),1)./sf(4,3);
    ypred5CD=ypred((SizevectorCum(5,1)+1):(SizevectorCum(5,1)+Sizevector(5,1)),1)./sf(5,1);
    ypred5UV=ypred((SizevectorCum(5,1)+Sizevector(5,1)+1):(SizevectorCum(5,1)+2*Sizevector(5,1)),1)./sf(5,2);
    ypred5FL=ypred((SizevectorCum(5,1)+2*Sizevector(5,1)+1):(SizevectorCum(5,1)+3*Sizevector(5,1)),1)./sf(5,3);
    ypred6CD=ypred((SizevectorCum(6,1)+1):(SizevectorCum(6,1)+Sizevector(6,1)),1)./sf(6,1);
    ypred6UV=ypred((SizevectorCum(6,1)+Sizevector(6,1)+1):(SizevectorCum(6,1)+2*Sizevector(6,1)),1)./sf(6,2);
    % ypred6FL=ypred((SizevectorCum(6,1)+2*Sizevector(6,1)+1):(SizevectorCum(6,1)+3*Sizevector(6,1)),1)./sf(6,3);
    ypred7CD=ypred((SizevectorCum(7,1)+1):(SizevectorCum(7,1)+Sizevector(7,1)),1)./sf(7,1);
    ypred7UV=ypred((SizevectorCum(7,1)+Sizevector(7,1)+1):(SizevectorCum(7,1)+2*Sizevector(7,1)),1)./sf(7,2);
    % ypred7FL=ypred((SizevectorCum(7,1)+2*Sizevector(7,1)+1):(SizevectorCum(7,1)+3*Sizevector(7,1)),1)./sf(7,3);

    delta1CD=delta((SizevectorCum(1,1)+1):(SizevectorCum(1,1)+Sizevector(1,1)),1)./sf(1,1);
    delta1UV=delta((SizevectorCum(1,1)+Sizevector(1,1)+1):(SizevectorCum(1,1)+2*Sizevector(1,1)),1)./sf(1,2);
    delta1FL=delta((SizevectorCum(1,1)+2*Sizevector(1,1)+1):(SizevectorCum(1,1)+3*Sizevector(1,1)),1)./sf(1,3);
    delta2CD=delta((SizevectorCum(2,1)+1):(SizevectorCum(2,1)+Sizevector(2,1)),1)./sf(2,1);
    delta2UV=delta((SizevectorCum(2,1)+Sizevector(2,1)+1):(SizevectorCum(2,1)+2*Sizevector(2,1)),1)./sf(2,2);
    delta2FL=delta((SizevectorCum(2,1)+2*Sizevector(2,1)+1):(SizevectorCum(2,1)+3*Sizevector(2,1)),1)./sf(2,3);
    delta3CD=delta((SizevectorCum(3,1)+1):(SizevectorCum(3,1)+Sizevector(3,1)),1)./sf(3,1);
    delta3UV=delta((SizevectorCum(3,1)+Sizevector(3,1)+1):(SizevectorCum(3,1)+2*Sizevector(3,1)),1)./sf(3,2);
    delta3FL=delta((SizevectorCum(3,1)+2*Sizevector(3,1)+1):(SizevectorCum(3,1)+3*Sizevector(3,1)),1)./sf(3,3);
    delta4CD=delta((SizevectorCum(4,1)+1):(SizevectorCum(4,1)+Sizevector(4,1)),1)./sf(4,1);
    delta4UV=delta((SizevectorCum(4,1)+Sizevector(4,1)+1):(SizevectorCum(4,1)+2*Sizevector(4,1)),1)./sf(4,2);
    delta4FL=delta((SizevectorCum(4,1)+2*Sizevector(4,1)+1):(SizevectorCum(4,1)+3*Sizevector(4,1)),1)./sf(4,3);
    delta5CD=delta((SizevectorCum(5,1)+1):(SizevectorCum(5,1)+Sizevector(5,1)),1)./sf(5,1);
    delta5UV=delta((SizevectorCum(5,1)+Sizevector(5,1)+1):(SizevectorCum(5,1)+2*Sizevector(5,1)),1)./sf(5,2);
    delta5FL=delta((SizevectorCum(5,1)+2*Sizevector(5,1)+1):(SizevectorCum(5,1)+3*Sizevector(5,1)),1)./sf(5,3);
    delta6CD=delta((SizevectorCum(6,1)+1):(SizevectorCum(6,1)+Sizevector(6,1)),1)./sf(6,1);
    delta6UV=delta((SizevectorCum(6,1)+Sizevector(6,1)+1):(SizevectorCum(6,1)+2*Sizevector(6,1)),1)./sf(6,2);
    % delta6FL=delta((SizevectorCum(6,1)+2*Sizevector(6,1)+1):(SizevectorCum(6,1)+3*Sizevector(6,1)),1)./sf(6,3);
    delta7CD=delta((SizevectorCum(7,1)+1):(SizevectorCum(7,1)+Sizevector(7,1)),1)./sf(7,1);
    delta7UV=delta((SizevectorCum(7,1)+Sizevector(7,1)+1):(SizevectorCum(7,1)+2*Sizevector(7,1)),1)./sf(7,2);
    % delta7FL=delta((SizevectorCum(7,1)+2*Sizevector(7,1)+1):(SizevectorCum(7,1)+3*Sizevector(7,1)),1)./sf(7,3);


    % Calculate correlation matrices for the parameter values.
    dof=size(Jacobian,1)-size(par_fin,2);
    Q=full(Jacobian)'*full(Jacobian);
    Qinv=Q\eye(size(Q));
    Cov=(resnorm/dof).*Qinv;                %This is the variance-covariance matrix
    save(strcat('VarCovarMat_n',num2str(n),'.txt'),'Cov','-ASCII')

    par_sd_2=sqrt(diag(Cov))';
    Corr=Cov./(sqrt(diag(Cov)*diag(Cov)')); %This is the Pearson Correlation Matrix
    save(strcat('CorrMat_n',num2str(n),'.txt'),'Corr','-ASCII')

    % Plot spectral data, fitted spectra, fraction of aggregation, association
    % constant and residual for each different concentration. The fit is
    % calculated in similar fashion to SolveMassBalance_SP.m in Step 2,
    % using optimal thermodynamic parameters.
    deltaHnuc = par_fin(1);
    deltaSnuc = par_fin(2);
    deltaHel = par_fin(3);
    deltaSel = par_fin(4);
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
    cf=[cfUV1 cfFL1;cfUV2 cfFL2;cfUV3 cfFL3;cfUV4 cfFL4;cfUV5 cfFL5;cfUV6 1;cfUV7 1];
    
    DECD=cell(N,1);
    DEUV=cell(N,1);
    DEFL=cell(N,1);
    CONC=[1e-6, 2.5e-6, 5e-6, 1e-5, 2.5e-5, 5e-5, 1e-4];
    R=8.314472;
    nTcumul=0;
    
    name1='Concentration 1e-6';
    name2='Concentration 2.5e-6';
    name3='Concentration 5e-6';
    name4='Concentration 1e-5';
    name5='Concentration 2.5e-5';
    name6='Concentration 5e-5';
    name7='Concentration 1e-4';

    % Cycle over concentrations
    for k=1:N
        options=optimset('Display', 'off', 'TolFun', 1e-21, 'TolX', 1e-21);
        range1=1e-14;   
        T=Temp{k,1};
        expCD=CD{k,1};
        expUV=UV{k,1};
        if k <= 5
            expFL=FL{k,1};
        end
        nT=length(T);
        Ct=CONC(k);      

        Knuc_T = exp(-(deltaHnuc-Temp{k,1}.*deltaSnuc)./(R.*Temp{k,1}));
        save(strcat('Knuc_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'),'Knuc_T','-ASCII')
        Kel_T = exp(-(deltaHel-Temp{k,1}.*deltaSel)./(R.*Temp{k,1}));     
        save(strcat('Kel_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'),'Kel_T','-ASCII')

        sigma=Knuc_T./Kel_T;                       
        
        x1=zeros(length(Temp{k,1}),1);
        concentration_m=zeros(length(Temp{k,1}),1);
        concentration_o=zeros(length(Temp{k,1}),1);
        concentration_p=zeros(length(Temp{k,1}),1);
        length_distr=zeros(Tdist_l,kkend+1);

        cd(CurrentDomain);
        for i=1:nT
            lb=0;
            ub=1;
            Knuc=Knuc_T(i);
            Kel=Kel_T(i);
            s=sigma(i);
            Xt=Kel*Ct;
            
            % Calculate the energy landscape (i.e. relative energetic cost
            % of subsequent assembly steps)
            for iES1=1:nTES
                if T(i)==TES(iES1)
                    for iES2=2:niES
                        if iES2 <= n
                            EnergyScape(iES1,iES2,n,k)=EnergyScape(iES1,iES2-1,n,k)-8.3145*T(i)*(log(Knuc)+log(Ct));
                        elseif iES2 > n
                            EnergyScape(iES1,iES2,n,k)=EnergyScape(iES1,iES2-1,n,k)-8.3145*T(i)*(log(Kel)+log(Ct));
                        end
                    end
                end
            end
            
            b=1;
            a=-1;
            a0=0;
                
            if Xt < 1

                a=0.99*Xt; 
                    f=Xt-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                    xrange=[0;a];   
                    while f<-1e15
                        a=0.99*a;
                        f=Xt-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                        xrange=[a0;a];
                    end

                    b=a/0.99;
                    while (f>0 && (b-a)>1e-15)
                        a=(a+b)/2;
                        f=Xt-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                        xrange=[a0;a];
                    end

                    if (b-a)<1e-15
                        x1(i,1)=b;
                    end

                    if f<-1e15
                        x1(i,1)=a;
                    end

                if ((b-a)>1e-15 && f<0 && f>-1e15)
                    x1(i,1) = fzero(@(x1) AnalyzerFunc(x1, Xt, s, n),...
                        xrange, options);
                end
            end

            if Xt > 1

                a=0.99*1; 
                f=Xt-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                xrange=[a0;a];   
                while f<-1e15
                    a=0.99*a;
                    f=Xt-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                    xrange=[a0;a];
                end

                b=a/0.99;
                while (f>0 && (b-a)>1e-15)
                    a=(a+b)/2;
                    f=Xt-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                    xrange=[a0;a];
                end

                if (b-a)<1e-15
                    x1(i,1)=b;
                end

                if f<-1e15
                    x1(i,1)=a;
                end


                if ((b-a)>1e-15 && f<0 && f>-1e15)
                    x1(i,1) = fzero(@(x1) AnalyzerFunc(x1, Xt, s, n),...
                        xrange, options);
                end

            end

            if 1/s < Xt && s > 1

                    a=0.99*(1/s); 
                    f=Xt-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                    xrange=[a0;a];   
                    while f<-1e15
                        a=0.99*a;
                        f=Xt-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                        xrange=[0;a];
                    end

                    if f > 0
                        b=a/0.99;
                        while (f>0 && (b-a)>1e-15)
                            a=(a+b)/2;
                            f=Xt-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
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
                        x1(i,1) = fzero(@(x1) AnalyzerFunc(x1, Xt, s, n),...
                            xrange, options);
                    end

            end
            
             concentration_m(i,1)=(1/Kel)*x1(i,1);
             conc_o=zeros(n,1);
             for jj=2:n
                 conc_o(jj)=jj*(1/Kel)*s^(jj-1)*x1(i,1)^jj;
             end
             conc_jj_cum=sum(conc_o);
             concentration_o(i,1)=conc_jj_cum;
             conc_p=zeros(kkend,1);
             for kk=n+1:kkend
                 conc_p(kk)=kk*(1/Kel)*s^(n-1)*x1(i,1)^kk;
             end
             conc_kk_cum=sum(conc_p);
             concentration_p(i,1)=Ct-concentration_o(i,1)-concentration_m(i,1);
             
             for ll=1:Tdist_l
                 if T(i)==Tdist(ll)
                     length_distr(ll,:)=[concentration_m(i,1);conc_o(2:n,1);conc_p(n+1:kkend);concentration_p(i,1)-conc_kk_cum]';
                 end
             end
        end
        cd(AnalysisDomain);
        
        % Save length distributions
        save(strcat('LengthDistr_Conc_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'),'length_distr','-ASCII')
        
        % Calculate molefractions
        phi_m=concentration_m/Ct; save(strcat('PhiM_Conc_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'),'phi_m','-ASCII')
        phi_o=concentration_o/Ct; save(strcat('PhiO_Conc_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'),'phi_o','-ASCII')
        phi_p=concentration_p/Ct; save(strcat('PhiP_Conc_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'),'phi_p','-ASCII')
        
        % Save concentrations
        save(strcat('Mono_Conc_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'),'concentration_m','-ASCII')
        save(strcat('PreN_Conc_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'),'concentration_o','-ASCII')
        save(strcat('PostN_Conc_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'),'concentration_p','-ASCII')
        
        % Calculate spectra from best fit, and save these.
        DECD{k,1}=(concentration_o*depsa+concentration_p*depsb);
        DECD_current=DECD{k,1};
        save(strcat('CDfit_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'),'DECD_current','-ASCII')
        
        DEUV{k,1}=(cf(k,1)*(concentration_m*epsm+concentration_o*epsa+concentration_p*epsb));
        DEUV_current=DEUV{k,1};
        save(strcat('UVfit_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'),'DEUV_current','-ASCII')
        
        if k < 6
            DEFL{k,1}=(cf(k,2)*(concentration_o*flinta+concentration_p*flintb));
            DEFL_current=DEFL{k,1};
            save(strcat('FLfit_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'),'DEFL_current','-ASCII')
        end
        
        resCDcurrent=(DECD{k,1}-CD{k,1}).^2; resCD{k,1}=resCDcurrent;
        save(strcat('ResidualCD_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'),'resCDcurrent','-ASCII')
        resUVcurrent=(DEUV{k,1}-UV{k,1}).^2; resUV{k,1}=resUVcurrent;
        save(strcat('ResidualUV_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'),'resUVcurrent','-ASCII')
        if k < 6
            resFLcurrent=(DEFL{k,1}-FL{k,1}).^2; resFL{k,1}=resFLcurrent;
            save(strcat('ResidualFL_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'),'resFLcurrent','-ASCII')
        end    
    end
    
        % Calculate residual
        c=[resCD{1,1}; resUV{1,1}; resFL{1,1}; resCD{2,1}; resUV{2,1}; resFL{2,1}; resCD{3,1}; resUV{3,1}; resFL{3,1};...
            resCD{4,1}; resUV{4,1}; resFL{4,1}; resCD{5,1}; resUV{5,1}; resFL{5,1}; resCD{6,1}; resUV{6,1}; ...
            resCD{7,1}; resUV{7,1}]; 
        SSQR=sum(c,1);
        
        %disp(strcat('Sum of squared residuals = ',num2str(SSQR)))
        save(strcat('SSQR_n',num2str(n),'.txt'),'SSQR','-ASCII')

    nTcumul=0;
        
    for k=1:N
        
        % Plot the results of the best fit
        T=Temp{k,1};
        expCD=CD{k,1};
        expUV=UV{k,1};
        if k <= 5
            expFL=FL{k,1};
        end
        nT=length(T);
        Ct=CONC(k); 
        
       	cd(DataDomain)
        residual=['load residual_n' num2str(n) '_j' num2str(I) '.mat'];
        eval(residual)
        cd(AnalysisDomain)
        
        % Overlay data, best fit and confidence interval of CD channel
        figure('name',eval(strcat('name',num2str(k))),'numbertitle','off')
        subplot(3,3,1)
        Tplot=[T;T(end:-1:1)];
        PatchY=[(eval(strcat('ypred',num2str(k),'CD'))+eval(strcat('delta',num2str(k),'CD')));...
            (eval(strcat('ypred',num2str(k),'CD(end:-1:1,1)'))-eval(strcat('delta',num2str(k),'CD(end:-1:1,1)')))];
        CDCIl=(eval(strcat('ypred',num2str(k),'CD'))-eval(strcat('delta',num2str(k),'CD')));
        CDCIh=(eval(strcat('ypred',num2str(k),'CD'))+eval(strcat('delta',num2str(k),'CD')));
        save(strcat('ypred_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'),strcat('ypred',num2str(k),'CD'),'-ASCII');
        save(strcat('fitCDCIl_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'),'CDCIl','-ASCII')
        save(strcat('fitCDCIh_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'),'CDCIh','-ASCII')
        PatchPlot=patch(Tplot,PatchY,[(135/255) (206/255) (250/255)],'EdgeColor','None');
        hold on
        FitPlot=plot(T,DECD{k,1},'b');
        hold on
        DataPlot=plot(T,expCD,'k');
        hold on
        xlabel('Temperature')
        ylabel('Ellipticity')
        legend('CI','fit','data')

        % Overlay data, best fit and confidence interval of UV channel
        subplot(3,3,2)
        Tplot=[T;T(end:-1:1)];
        PatchY=[(eval(strcat('ypred',num2str(k),'UV'))+eval(strcat('delta',num2str(k),'UV')));...
            (eval(strcat('ypred',num2str(k),'UV(end:-1:1,1)'))-eval(strcat('delta',num2str(k),'UV(end:-1:1,1)')))];
        UVCIl=(eval(strcat('ypred',num2str(k),'UV'))-eval(strcat('delta',num2str(k),'UV')));
        UVCIh=(eval(strcat('ypred',num2str(k),'UV'))+eval(strcat('delta',num2str(k),'UV')));
        save(strcat('fitUVCIl_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'),'UVCIl','-ASCII')
        save(strcat('fitUVCIh_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'),'UVCIh','-ASCII')
        PatchPlot2=patch(Tplot,PatchY,[(135/255) (206/255) (250/255)],'EdgeColor','None');
        hold on
        FitPlot2=plot(T,DEUV{k,1},'b');
        hold on
        DataPlot2=plot(T,expUV,'k');
        hold on
        xlabel('Temperature')
        ylabel('Absorption')
        legend('CI','fit','data')

        % Overlay data, best fit and confidence interval of FL channel
        if k <= 5
            subplot(3,3,3)
            Tplot=[T;T(end:-1:1)];
            PatchY=[(eval(strcat('ypred',num2str(k),'FL'))+eval(strcat('delta',num2str(k),'FL')));...
                (eval(strcat('ypred',num2str(k),'FL(end:-1:1,1)'))-eval(strcat('delta',num2str(k),'FL(end:-1:1,1)')))];
            FLCIl=(eval(strcat('ypred',num2str(k),'FL'))-eval(strcat('delta',num2str(k),'FL')));
            FLCIh=(eval(strcat('ypred',num2str(k),'FL'))+eval(strcat('delta',num2str(k),'FL')));
            save(strcat('fitFLCIl_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'),'FLCIl','-ASCII')
            save(strcat('fitFLCIh_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'),'FLCIh','-ASCII')
            PatchPlot3=patch(Tplot,PatchY,[(135/255) (206/255) (250/255)],'EdgeColor','None');
            hold on
            FitPlot3=plot(T,DEFL{k,1},'b');
            hold on
            DataPlot3=plot(T,expFL,'k');
            hold on
            xlabel('Temperature')
            ylabel('Fluorescence')
            legend('CI','fit','data')
        end

        % Plot residual of CD channel
        residualvecCD=residual(nTcumul+1:nTcumul+nT);
        subplot(3,3,4)
        plot(T,residualvecCD,'ko')
        xlabel('Temperature Point')
        ylabel('Residual at Temperature Point')
        
        % Plot residual of UV channel
        residualvecUV=residual(nTcumul+nT+1:nTcumul+2*nT);
        subplot(3,3,5)
        plot(T,residualvecUV,'ko')
        xlabel('Temperature Point')
        ylabel('Residual at Temperature Point')
        
        % Plot residual of FL channel
        if k <= 5
            residualvecFL=residual(nTcumul+2*nT+1:nTcumul+3*nT);
            subplot(3,3,6)
            plot(T,residualvecFL,'ko')
            xlabel('Temperature Point')
            ylabel('Residual at Temperature Point')
        end
        
        phi_m=load(strcat('PhiM_Conc_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'));
        phi_o=load(strcat('PhiO_Conc_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'));
        phi_p=load(strcat('PhiP_Conc_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'));
        
        % Plot molecular distributions
        subplot(3,3,7)
        plot(T,phi_m,'b')
        hold on
        plot(T,phi_o,'k')
        hold on
        plot(T,phi_p,'r')
        hold on
        plot(T,phi_m+phi_o+phi_p,'g')
        xlabel('Temperature')
        ylabel('\phi')
        legend('free monomer','A','B')

        Knuc_T = load(strcat('Knuc_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'));
        Kel_T = load(strcat('Kel_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'));
        
        % Plot equilibrium constants as function of temperature
        subplot(3,3,8)
        semilogy(T,Knuc_T,'k')
        hold on
        semilogy(T,Kel_T,'r')
        hold on
        xlabel('Temperature')
        ylabel('K')
        legend('nucleation','elongation')
        
        % Plot energy landscape
        xES=linspace(1,niES,niES);

        LegendCell=cell(nTES,1);
        for iES4=1:nTES
            LegendCell{iES4,1}=['T=' num2str(TES(1,iES4)) 'K'];
        end
        subplot(3,3,9)
        plot(xES,EnergyScape(:,:,n,k))
        xlabel('Aggregate Size (#)')
        ylabel('dG1i (kJ/mol)')
        legend(LegendCell)
        
        saveas(gcf,strcat('Thermodynamic Fit n=',num2str(n),'_Ct=',num2str(CONC(k)),'.fig'),'fig')
        
        if k <= 5
            nTcumul=nTcumul+3*nT;
        else
            nTcumul=nTcumul+2*nT;
        end
    end
    alpha(0.15);

    for k=1:N
        % Save output files
        filename = strcat('FitResults_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt');
        if k <= 5
            out1=[T CD{k,1} UV{k,1} FL{k,1}];
        else
            out1=[T CD{k,1} UV{k,1}];
        end
        nT2=size(out1,1);
        out2l=load(strcat('fitCDCIl_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'));
        out2=load(strcat('ypred_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'));
        out2h=load(strcat('fitCDCIh_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'));
        out3l=load(strcat('fitUVCIl_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'));
        out3=load(strcat('UVfit_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'));
        out3h=load(strcat('fitUVCIh_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'));
        if k <= 5
            out4l=load(strcat('fitFLCIl_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'));
            out4=load(strcat('FLfit_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'));
            out4h=load(strcat('fitFLCIh_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'));
        end    
        out5=load(strcat('PhiM_Conc_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'));
        out6=load(strcat('PhiO_Conc_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'));
        out7=load(strcat('PhiP_Conc_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'));
        out8=load(strcat('Knuc_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'));
        out9=load(strcat('Kel_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'));       
        out10=load(strcat('ResidualCD_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'));
        out11=load(strcat('ResidualUV_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'));
        if k <= 5
            out12=load(strcat('ResidualFL_n',num2str(n),'_Ct',num2str(CONC(k)),'.txt'));
        end
        fid = fopen(filename, 'w');
        if k <= 5
            fprintf(fid, '%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s\n', ...
                'Temperature', 'CDdata', 'UVdata', 'FLdata', 'LowerBoundCD', 'CDfit', 'UpperBoundCD', ...
                'LowerBoundUV', 'UVfit', 'UpperBoundUV', 'LowerBoundFL', 'FLfit', 'UpperBoundFL', ...
                'PhiMono', 'PhiOligo', 'PhiPoly', 'Knuc', 'Kel', 'ResidualCD','ResidualUV','ResidualFL');
                for i=1:nT2
                         fprintf(fid, '%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e\n', ...
                             out1(i,1), out1(i,2), out1(i,3), out1(i,4), out2l(i), out2(i), out2h(i), out3l(i), out3(i), out3h(i), ...
                             out4l(i), out4(i), out4h(i), out5(i), out6(i), out7(i), out8(i), out9(i), out10(i), out11(i),out12(i));
                end
        else
            fprintf(fid, '%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s\n', ...
                'Temperature', 'CDdata', 'UVdata', 'LowerBoundCD', 'CDfit', 'UpperBoundCD', ...
                'LowerBoundUV', 'UVfit', 'UpperBoundUV', ...
                'PhiMono', 'PhiOligo', 'PhiPoly', 'Knuc', 'Kel', 'ResidualCD','ResidualUV');
                for i=1:nT2
                         fprintf(fid, '%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e\n', ...
                             out1(i,1), out1(i,2), out1(i,3), out2l(i), out2(i), out2h(i), out3l(i), out3(i), out3h(i), ...
                             out5(i), out6(i), out7(i), out8(i), out9(i), out10(i),out11(i));
                end
        end
        fclose(fid);
    end
    
    
    %% Plot the pseudo phase diagram
    phasediagram='on';
    switch phasediagram
        case 'on'
            % Define conditions to be investigated
            Cmin=-7; Cmax=-3; nC=100;
            Tmin=200; Tmax=400; nT=1000;

            Cvec=logspace(Cmin,Cmax,nC)';
            save(strcat('Cvec-model_n',num2str(n),'.txt'),'Cvec','-ASCII')
            Tvec=linspace(Tmax,Tmin,nT)';
            save(strcat('Tvec-model_n',num2str(n),'.txt'),'Tvec','-ASCII')

            MAvec=zeros(nC,1);
            ABvec=zeros(nC,1);
            MBvec=zeros(nC,1);
            
            % Solve mass balance for each condition
            for k=1:nC
                options=optimset('Display', 'off', 'TolFun', 1e-18, 'TolX', 1e-18);
                range1=1e-14;   
                Ct=Cvec(k);      

                Knuc_T = exp(-(deltaHnuc-Tvec.*deltaSnuc)./(R.*Tvec));
                Kel_T = exp(-(deltaHel-Tvec.*deltaSel)./(R.*Tvec));
                if k == 1
                    save(strcat('Knuc-model_n',num2str(n),'.txt'),'Knuc_T','-ASCII')
                    save(strcat('Kel-model_n',num2str(Ct),'.txt'),'Kel_T','-ASCII')
                end
                sigma=Knuc_T./Kel_T;

                Mvec=zeros(nT,1); 
                res=zeros(nT,1);

                cd(CurrentDomain)
                for i=1:nT
                    lb=0;
                    ub=1;
                    Knuc=Knuc_T(i);
                    Kel=Kel_T(i);
                    s=sigma(i);
                    Xt=Kel*Ct;

                    b=1;
                    a=-1;
                    a0=0;

                    if Xt < 1

                        a=0.99*Xt; 
                            f=Xt-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                            xrange=[0;a];   
                            while f<-1e15
                                a=0.99*a;
                                f=Xt-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                                xrange=[a0;a];
                            end

                            b=a/0.99;
                            while (f>0 && (b-a)>1e-15)
                                a=(a+b)/2;
                                f=Xt-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                                xrange=[a0;a];
                            end

                            if (b-a)<1e-15
                                x1(i,1)=b;
                            end

                            if f<-1e15
                                x1(i,1)=a;
                            end

                        if ((b-a)>1e-15 && f<0 && f>-1e15)
                            x1(i,1) = fzero(@(x1) AnalyzerFunc(x1, Xt, s, n),...
                                xrange, options);
                        end
                    end

                    if Xt > 1

                        a=0.99*1; 
                        f=Xt-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                        xrange=[a0;a];   
                        while f<-1e15
                            a=0.99*a;
                            f=Xt-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                            xrange=[a0;a];
                        end

                        b=a/0.99;
                        while (f>0 && (b-a)>1e-15)
                            a=(a+b)/2;
                            f=Xt-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                            xrange=[a0;a];
                        end

                        if (b-a)<1e-15
                            x1(i,1)=b;
                        end

                        if f<-1e15
                            x1(i,1)=a;
                        end


                        if ((b-a)>1e-15 && f<0 && f>-1e15)
                            x1(i,1) = fzero(@(x1) AnalyzerFunc(x1, Xt, s, n),...
                                xrange, options);
                        end

                    end

                    if 1/s < Xt && s > 1

                            a=0.99*(1/s); 
                            f=Xt-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                            xrange=[a0;a];   
                            while f<-1e15
                                a=0.99*a;
                                f=Xt-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
                                xrange=[0;a];
                            end

                            if f > 0
                                b=a/0.99;
                                while (f>0 && (b-a)>1e-15)
                                    a=(a+b)/2;
                                    f=Xt-(1/s)*(((s*a)^(n+1)*(n*s*a-n-1))/((s*a-1)^2)+(s*a)/((s*a-1)^2))+s^(n-1)*(a^(n+1)*(a*n-n-1))/((a-1)^2);
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
                                x1(i,1) = fzero(@(x1) AnalyzerFunc(x1, Xt, s, n),...
                                    xrange, options);
                            end

                    end
                    
                     concentration_m(i,1)=(1/Kel)*x1(i,1);
                     conc_o=zeros(n,1);
                     for jj=2:n
                         conc_o(jj)=jj*Knuc^(jj-1)*concentration_m(i,1)^jj;
                     end
                     conc_jj_cum=sum(conc_o);
                     concentration_o(i,1)=conc_jj_cum;
                     concentration_p(i,1)=Ct-concentration_o(i,1)-concentration_m(i,1);
                end

                cd(AnalysisDomain)
                phi_m=concentration_m/Ct; 
                phi_o=concentration_o/Ct; 
                phi_p=concentration_p/Ct; 
                save(strcat('PDphiM_n',num2str(n),'_Ct',num2str(Ct),'.txt'),'phi_m','-ASCII')
                save(strcat('PDphiO_n',num2str(n),'_Ct',num2str(Ct),'.txt'),'phi_o','-ASCII')
                save(strcat('PDphiP_n',num2str(n),'_Ct',num2str(Ct),'.txt'),'phi_p','-ASCII')

                % Identify phase boundaries
                A=0;
                B=0;
                C=0;
                for l=1:nT
                    if (phi_o(l)-phi_m(l))^2 < 5e-4 && phi_o(l) > 0.1 && A == 0
                        MAvec(k)=Tvec(l);
                        A=1;
                    elseif (phi_p(l)-phi_m(l))^2 < 1e-3 && B == 0
                        MBvec(k)=Tvec(l);
                        B=1;
                    elseif (phi_p(l)-phi_o(l))^2 < 7e-4 && phi_p(l) > 0.1 && C == 0
                        ABvec(k)=Tvec(l);
                        C=1;
                    elseif (phi_p(l)-phi_o(l))^2 < 1.5e-3 && Cvec(k) > 1e-4 && phi_p(l) > 0.1 && C == 0
                        ABvec(k)=Tvec(l);
                        C=1;
                    end
                end 
            end
            
            save(strcat('MAvec_n',num2str(n),'.txt'),'MAvec','-ASCII')
            save(strcat('ABvec_n',num2str(n),'.txt'),'ABvec','-ASCII')
            save(strcat('MBvec_n',num2str(n),'.txt'),'MBvec','-ASCII')

            figure('name','Population Diagram Raw Data','numbertitle','off');
            semilogx(Cvec,MAvec,'ro',Cvec,ABvec,'bo',Cvec,MBvec,'ko');
            xlabel('Monomer Concentration'); 
            ylabel('Temperature');

            for q=1:nC
                if ABvec(q) > MAvec(q)
                    MAvec(q)=MBvec(q);
                    ABvec(q)=MBvec(q);
                else
                    MBvec(q)=ABvec(q);
                end
            end

            saveas(gcf,strcat('Phase Diagram Raw n_',num2str(n)),'fig')
            save(strcat('MAvec_edit_n',num2str(n),'.txt'),'MAvec','-ASCII')
            save(strcat('ABvec_edit_n',num2str(n),'.txt'),'ABvec','-ASCII')
            save(strcat('MBvec_edit_n',num2str(n),'.txt'),'MBvec','-ASCII')

            % Plot pseudo phase diagram
            roof=350*ones(1,nC);  % Highest temperature value in graph in K
            baseLine = 260;       % Baseline value for filling under the curves 
            index = 1:nC;         % Indices of points to fill under 

            Cvec=Cvec';
            MAvec=MAvec';
            ABvec=ABvec';

            figure('name','Population Diagram','numbertitle','off')
            semilogx(Cvec,roof,'');                %# Plot the first line 
            hold on;                                     %# Add to the plot 
            h1 = fill(Cvec(index([1 1:end end])),...        %# Plot the first filled polygon 
                      [baseLine roof(index) baseLine],... 
                      [30/255 144/255 255/255],'EdgeColor','none'); 
            semilogx(Cvec,MAvec,'');               %# Plot the second line 
            h2 = fill(Cvec(index([1 1:end end])),...        %# Plot the second filled polygon 
                      [baseLine MAvec(index) baseLine],... 
                      [205/255 201/255 201/255],'EdgeColor','none'); 
            semilogx(Cvec,ABvec,'');               %# Plot the third line 
            h3 = fill(Cvec(index([1 1:end end])),...        %# Plot the third filled polygon 
                      [baseLine ABvec(index) baseLine],... 
                      [250/255 128/255 114/255],'EdgeColor','none');
            alpha(0.2);
            axis([min(Cvec) max(Cvec) baseLine roof(1)])
            title('Phase Diagram');
            xlabel('Monomer Concentration'); 
            ylabel('Temperature');
            
            saveas(gcf,strcat('Phase Diagram n_',num2str(n)),'fig')
            
        case 'off'
            disp('No Phase Diagram has been created')
    end
    close all
    cd(CurrentDomain);
end

save('FinalFitResults.txt','FinalFitResults','-ASCII')
save('EnergyScape.mat','EnergyScape','-MAT')