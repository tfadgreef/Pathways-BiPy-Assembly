% AnalyzerThermodynamicFit_TP
% This script finds the best fits from the large LHS-sampled fitting 
% procedure. The best fit is determined using the residual sum of squares.
% Additionally, using the optimal thermodynamic data, it plots the overlay
% of the best fit on the data, and calculates a pseuso-phase diagram
% describing the molecular distributions as a function of concentration and
% temperature. 
% N.B.: Since pathways A and B are equivalent, the parameters resulting 
% from the fit may also be inverted. For consistency, we have taken the
% final parameters for which pathway B is stable at low temperature, in
% this case the fit with the second lowest resnorm.

clear all
close all
clc

% Set properties for fit overlay
J=400;
kkend=1000;
Tdist=[273:5:353]; Tdist_l=length(Tdist);

% Determine best fit
NVR=[];
for j=1:J
    a=['load Bresnorm-' num2str(j) '.mat'];
    eval(a); 
    NVR=[NVR,resnorm];
end
 
[Y,I]=sort(NVR,2,'ascend');
par_fin_best=[];
NVR_best=I(:,1:10);
for i=1:10
    a=['load Bpar_fin-' num2str(NVR_best(i)),'.mat'];
    eval(a);
    b=['load Bresnorm-' num2str(NVR_best(i)),'.mat'];
    eval(b);
    par_fin_best(:,i)=par_fin';                     %These are the final parameters from the best simulations
    resnorm_best(i)=resnorm;                        
end

load param2.mat
par_init=param2(NVR_best,:)'; 

% Load output files for best fit
ind=2;
I=NVR_best(ind)
Y=resnorm_best(ind)
resnorm=(['load Bresnorm-' num2str(I) '.mat']);
par_fin=(['load Bpar_fin-' num2str(I) '.mat']); 
Jacobian=['load Bjacobian-' num2str(I) '.mat'];
lambda=(['load Blambda-' num2str(I) '.mat']);
residual=['load Bresidual-' num2str(I) '.mat'];
eval(resnorm);
eval(par_fin); 
eval(Jacobian);
eval(lambda);
eval(residual);

Jacobian=full(Jacobian);

% Load experimental data
name1='Concentration 1e-6';
name2='Concentration 2.5e-6';
name3='Concentration 5e-6';
name4='Concentration 1e-5';
name5='Concentration 2.5e-5';
name6='Concentration 5e-5';
name7='Concentration 1e-4';

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

% Calculate errors in parameters using nlparci

% About 68% of values drawn from a normal distribution are within one
% standard deviation ? > 0 away from the mean ?; about 95% of the values
% are within two standard deviations and about 99.7% lie within three
% standard deviations. This is known as the "68-95-99.7 rule" or the
% "empirical rule" or the "3-sigma rule."
conflevel=0.05; % select confidence level
% estimate confidence interval using NLPARCI
ci = nlparci(par_fin,residual,'jacobian',Jacobian,'alpha',conflevel);

% Compute confidence interval using nlparci (using Fischer Information
% Matrix)
tsd = tinv(1-conflevel/2,length(residual)-length(par_fin));
% Convert confidence intervals to standard deviations
par_sd = (ci(:,2)-ci(:,1)) ./ (2*tsd); 
par_fin_t=par_fin';
ParSD=[par_fin_t-par_sd par_fin_t par_fin_t+par_sd];
ParSD_2=[par_fin_t par_sd];
save('Par_SD.txt','ParSD','-ASCII')
save('Par_SD_2.txt','ParSD_2','-ASCII')

% Calculate errors in function values using nlpredci
N=7;
Tvector=[];
Sizevector=zeros(N,1);
SizevectorCum=zeros(N,1);

% Some bookkeeping is involved due to the structure enforced by lsqnonlin.
for n=1:N
    Ttemp=eval(strcat('Temp',num2str(n)));
    Sizevector(n,1)=size(Ttemp,1);
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
[ypred,delta]=nlpredci(@DZT_004_pred,Tvector,par_fin,residual,'jacobian',Jacobian,'alpha',0.05);
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
save('VarCovarMat.txt','Cov','-ASCII')

par_sd_2=sqrt(diag(Cov))';
Corr=Cov./(sqrt(diag(Cov)*diag(Cov)')); %This is the Pearson Correlation Matrix
save('CorrMat.txt','Corr','-ASCII')

% Plot spectral data, fitted spectra, fraction of aggregation, association
% constant and residual for each different concentration. The fit is
% calculated in similar fashion to SolveMassBalance_TP.m in Step 2,
% using optimal thermodynamic parameters.
dH2a = par_fin(1); 
dHa = par_fin(2);     
dSa = par_fin(3);
dS2a = par_fin(3);
dH2b = par_fin(4); 
dHb = par_fin(5); 
dSb = par_fin(6);
dS2b = par_fin(6);
Em = par_fin(7);
dEa = par_fin(8);
Ea = par_fin(9);
FLa = par_fin(10);
dEb = par_fin(11);
Eb = par_fin(12);
FLb = par_fin(13);
cfUV1 = par_fin(14);
cfUV2 = par_fin(15);
cfUV3 = par_fin(16);
cfUV4 = par_fin(17);
cfUV5 = par_fin(18);
cfUV6 = par_fin(19);
cfUV7 = par_fin(20);
cfFL1 = par_fin(21);
cfFL2 = par_fin(22);
cfFL3 = par_fin(23);
cfFL4 = par_fin(24);
cfFL5 = par_fin(25);
cf=[cfUV1 cfFL1;cfUV2 cfFL2;cfUV3 cfFL3;cfUV4 cfFL4;cfUV5 cfFL5;cfUV6 1;cfUV7 1];
CONC=[1e-6, 2.5e-6, 5e-6, 1e-5, 2.5e-5, 5e-5, 1e-4];
R=8.314472;
nTcumul=0;

% Cycle over concentrations
for k=1:N
    options=optimset('Display', 'off', 'TolFun', 1e-18, 'TolX', 1e-18);
    range1=1e-14;   
    T=eval(strcat('Temp',num2str(k)));
    expCD=eval(strcat('CD',num2str(k)));
    expUV=eval(strcat('UV',num2str(k)));
    if k <= 5
        expFL=eval(strcat('FL',num2str(k)));
    end
    nT=length(T);
    Ct=CONC(k);      

    K2_Ta = exp(-(dH2a-T.*dS2a)./(R.*T));
    save(strcat('K2a-conc',num2str(k),'.txt'),'K2_Ta','-ASCII')
    K_Ta = exp(-(dHa-T.*dSa)./(R.*T));     
    save(strcat('Ka-conc',num2str(k),'.txt'),'K_Ta','-ASCII')
    K2_Tb = exp(-(dH2b-T.*dS2b)./(R.*T));  
    save(strcat('K2b-conc',num2str(k),'.txt'),'K2_Tb','-ASCII')
    K_Tb = exp(-(dHb-T.*dSb)./(R.*T)); 
    save(strcat('Kb-conc',num2str(k),'.txt'),'K_Tb','-ASCII')
    sigma_a=K2_Ta./K_Ta;                       
    sigma_b=K2_Tb./K_Tb;
    B_T=K_Ta./K_Tb;

    Mvec=zeros(nT,1); 
    x1=zeros(nT,1);
    concentrationA1=zeros(nT,1);
    concentrationB1=zeros(nT,1);
    concentrationM1=zeros(nT,1);
    length_distr=zeros(Tdist_l,kkend+1);
    length_distr_full=zeros(Tdist_l,2*kkend+1);
    
    for i=1:nT 
        lb=0;
        ub=1;
        Ka=K_Ta(i);
        Kb=K_Tb(i);
        sa=sigma_a(i);
        sb=sigma_b(i);
        xtot=Ka*Ct;

        B=Kb/Ka;

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
                x1(i,1) = fzero(@(x1) DZT_004_cost(x1, xtot, sa, sb, Ka, Kb),...
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
                    x1(i,1) = fzero(@(x1) DZT_004_cost(x1, xtot, sa, sb, Ka, Kb),...
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
                    x1(i,1) = fzero(@(x1) DZT_004_cost(x1, xtot, sa, sb, Ka, Kb),...
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
                        x1(i,1) = fzero(@(x1) DZT_004_cost(x1, xtot, sa, sb, Ka, Kb),...
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
                        x1(i,1) = fzero(@(x1) DZT_004_cost(x1, xtot, sa, sb, Ka, Kb),...
                            xrange, options);
                    end

                end

         end
         concentrationA1(i,1)=(1/Ka)*sa*(x1(i,1)/((1-x1(i,1))^2)-x1(i,1));
         concentrationB1(i,1)=(1/Ka)*sb*(x1(i,1)/((1-B*x1(i,1))^2)-x1(i,1));
         concentrationM1(i,1)=(1/Ka)*x1(i,1);
        
         conc_a=zeros(kkend,1);
         for jj=2:kkend
             conc_a(jj)=jj*(1/Ka)*sa*x1(i,1)^jj;
         end
         conc_jj_cum=sum(conc_a);
         conc_b=zeros(kkend,1);
         for kk=2:kkend
             conc_b(kk)=kk*(1/Kb)*sb*(B*x1(i,1))^kk;
         end
         conc_kk_cum=sum(conc_b);
         conc_t=conc_a+conc_b;

         for ll=1:Tdist_l
             if T(i)==Tdist(ll)
                 length_distr(ll,:)=[concentrationM1(i,1);conc_t(2:kkend,1);Ct-conc_jj_cum-conc_kk_cum-concentrationM1(i,1)]';
                 length_distr_full(ll,:)=[concentrationM1(i,1);conc_a(2:kkend,1);Ct-concentrationB1(i,1)-conc_jj_cum-concentrationM1(i,1);conc_b(2:kkend,1);Ct-concentrationA1(i,1)-conc_kk_cum-concentrationM1(i,1)]';
             end
         end
         Mvec(i)=x1(i,1);
    end

    % Save length distributions
    save(strcat('LengthDistr_Conc_Ct',num2str(CONC(k)),'.txt'),'length_distr','-ASCII')
    save(strcat('LengthDistFull_Conc_Ct',num2str(CONC(k)),'.txt'),'length_distr_full','-ASCII')
           
    % Calculate molefractions
    phiA=(sigma_a.*(Mvec./((1-Mvec).^2)-Mvec))./(K_Ta*Ct);
    save(strcat('phiA-conc',num2str(k),'.txt'),'phiA','-ASCII')
    phiB=(sigma_b.*(Mvec./((1-(K_Tb./K_Ta).*Mvec).^2)-Mvec))./(K_Ta.*Ct); 
    save(strcat('phiB-conc',num2str(k),'.txt'),'phiB','-ASCII')
    phi1=Mvec./(K_Ta*Ct);
    save(strcat('phi1-conc',num2str(k),'.txt'),'phi1','-ASCII')
    
    % Save concentrations
    cA=(sigma_a.*(Mvec./((1-Mvec).^2)-Mvec))./(K_Ta);
    cB=(sigma_b.*(Mvec./((1-(K_Tb./K_Ta).*Mvec).^2)-Mvec))./(K_Ta);
    cM=Mvec./K_Ta;
    
    % Calculate spectra from best fit, and save these.
    CDtrace=(cA*dEa+cB*dEb);
    save(strcat('CDfit-conc',num2str(k),'.txt'),'CDtrace','-ASCII')
    UVtrace=cf(k,1)*(cM*Em+cA*Ea+cB*Eb);
    save(strcat('UVfit-conc',num2str(k),'.txt'),'UVtrace','-ASCII')
    FLtrace=cf(k,2)*(cA*FLa+cB*FLb);
    save(strcat('FLfit-conc',num2str(k),'.txt'),'FLtrace','-ASCII')   
    
    % Plot the results of the best fit
    
    % Overlay data, best fit and confidence interval of CD channel
    figure('name',eval(strcat('name',num2str(k))),'numbertitle','off')
    subplot(2,3,1)
    Tplot=[T;T(end:-1:1)];
    PatchY=[(eval(strcat('ypred',num2str(k),'CD'))+eval(strcat('delta',num2str(k),'CD')));...
        (eval(strcat('ypred',num2str(k),'CD(end:-1:1,1)'))-eval(strcat('delta',num2str(k),'CD(end:-1:1,1)')))];
    CDCIl=(eval(strcat('ypred',num2str(k),'CD'))-eval(strcat('delta',num2str(k),'CD')));
    CDCIh=(eval(strcat('ypred',num2str(k),'CD'))+eval(strcat('delta',num2str(k),'CD')));
    save(strcat('ypred-conc',num2str(k),'.txt'),strcat('ypred',num2str(k),'CD'),'-ASCII');
    save(strcat('fitCDCIl-conc',num2str(k),'.txt'),'CDCIl','-ASCII')
    save(strcat('fitCDCIh-conc',num2str(k),'.txt'),'CDCIh','-ASCII')
    PatchPlot=patch(Tplot,PatchY,[(135/255) (206/255) (250/255)],'EdgeColor','None');
    hold on
    FitPlot=plot(T,eval(strcat('ypred',num2str(k),'CD')),'b');
    hold on
    DataPlot=plot(T,expCD,'k');
    hold on
    xlabel('Temperature')
    ylabel('Ellipticity')
    legend('CI','fit','data')
    
    % Overlay data, best fit and confidence interval of UV channel
    subplot(2,3,2)
    Tplot=[T;T(end:-1:1)];
    PatchY=[(eval(strcat('ypred',num2str(k),'UV'))+eval(strcat('delta',num2str(k),'UV')));...
        (eval(strcat('ypred',num2str(k),'UV(end:-1:1,1)'))-eval(strcat('delta',num2str(k),'UV(end:-1:1,1)')))];
    UVCIl=(eval(strcat('ypred',num2str(k),'UV'))-eval(strcat('delta',num2str(k),'UV')));
    UVCIh=(eval(strcat('ypred',num2str(k),'UV'))+eval(strcat('delta',num2str(k),'UV')));
    save(strcat('fitUVCIl-conc',num2str(k),'.txt'),'UVCIl','-ASCII')
    save(strcat('fitUVCIh-conc',num2str(k),'.txt'),'UVCIh','-ASCII')
    PatchPlot2=patch(Tplot,PatchY,[(135/255) (206/255) (250/255)],'EdgeColor','None');
    hold on
    FitPlot2=plot(T,UVtrace,'b');
    hold on
    DataPlot2=plot(T,expUV,'k');
    hold on
    xlabel('Temperature')
    ylabel('Absorption')
    legend('CI','fit','data')
    
    % Overlay data, best fit and confidence interval of FL channel
    if k <= 5
        subplot(2,3,3)
        Tplot=[T;T(end:-1:1)];
        PatchY=[(eval(strcat('ypred',num2str(k),'FL'))+eval(strcat('delta',num2str(k),'FL')));...
            (eval(strcat('ypred',num2str(k),'FL(end:-1:1,1)'))-eval(strcat('delta',num2str(k),'FL(end:-1:1,1)')))];
        FLCIl=(eval(strcat('ypred',num2str(k),'FL'))-eval(strcat('delta',num2str(k),'FL')));
        FLCIh=(eval(strcat('ypred',num2str(k),'FL'))+eval(strcat('delta',num2str(k),'FL')));
        save(strcat('fitFLCIl-conc',num2str(k),'.txt'),'FLCIl','-ASCII')
        save(strcat('fitFLCIh-conc',num2str(k),'.txt'),'FLCIh','-ASCII')
        PatchPlot3=patch(Tplot,PatchY,[(135/255) (206/255) (250/255)],'EdgeColor','None');
        hold on
        FitPlot3=plot(T,FLtrace,'b');
        hold on
        DataPlot3=plot(T,expFL,'k');
        hold on
        xlabel('Temperature')
        ylabel('Fluorescence')
        legend('CI','fit','data')
    end
    
    % Plot molecular distributions
    subplot(2,3,4)
    plot(T,phi1,'b')
    hold on
    plot(T,phiA,'k')
    hold on
    plot(T,phiB,'r')
    hold on
    plot(T,phi1+phiA+phiB,'g')
    xlabel('Temperature')
    ylabel('\phi')
    legend('free monomer','A','B')

    % Plot equilibrium constants as function of temperature
    subplot(2,3,5)
    semilogy(T,K_Ta,'k')
    hold on
    semilogy(T,K2_Ta,'k--')
    hold on
    semilogy(T,K_Tb,'r')
    hold on
    semilogy(T,K2_Tb,'r--')
    hold on
    xlabel('Temperature')
    ylabel('K')
    legend('A','A2','B','B2')
    
    % Plot residual
    residualvec=residual(nTcumul+1:nTcumul+nT);
    subplot(2,3,6)
    plot(T,residualvec,'ko')
    xlabel('Temperature Point')
    ylabel('Residual at Temperature Point')
    
    if k <= 5
        nTcumul=nTcumul+3*nT;
    else
        nTcumul=nTcumul+2*nT;
    end
end
alpha(0.15);

for k=1:N
    % Save output files
    filename = strcat('FitResults-conc',num2str(CONC(k)),'.txt');
    if k <= 5
        out1=[T eval(strcat('CD',num2str(k))) eval(strcat('UV',num2str(k))) eval(strcat('FL',num2str(k)))];
    else
        out1=[T eval(strcat('CD',num2str(k))) eval(strcat('UV',num2str(k)))];
    end
    nT2=size(out1,1);
    out2l=load(strcat('fitCDCIl-conc',num2str(k),'.txt'));
    out2=load(strcat('ypred-conc',num2str(k),'.txt'));
    out2h=load(strcat('fitCDCIh-conc',num2str(k),'.txt'));
    out3l=load(strcat('fitUVCIl-conc',num2str(k),'.txt'));
    out3=load(strcat('UVfit-conc',num2str(k),'.txt'));
    out3h=load(strcat('fitUVCIh-conc',num2str(k),'.txt'));
    if k <= 5
        out4l=load(strcat('fitFLCIl-conc',num2str(k),'.txt'));
        out4=load(strcat('FLfit-conc',num2str(k),'.txt'));
        out4h=load(strcat('fitFLCIh-conc',num2str(k),'.txt'));
    end    
    out5=load(strcat('phi1-conc',num2str(k),'.txt'));
    out6=load(strcat('phiA-conc',num2str(k),'.txt'));
    out7=load(strcat('phiB-conc',num2str(k),'.txt'));
    out8=load(strcat('Ka-conc',num2str(k),'.txt'));
    out9=load(strcat('Kb-conc',num2str(k),'.txt'));
    out10=load(strcat('residual-conc',num2str(k),'.txt'));
    fid = fopen(filename, 'w');
    if k <= 5
        fprintf(fid, '%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s\n', ...
            'Temperature', 'CDdata', 'UVdata', 'FLdata', 'LowerBoundCD', 'CDfit', 'UpperBoundCD', ...
            'LowerBoundUV', 'UVfit', 'UpperBoundUV', 'LowerBoundFL', 'FLfit', 'UpperBoundFL', ...
            'Phi1', 'PhiA', 'PhiB', 'Ka', 'Kb', 'Residual');
            for i=1:nT2
                     fprintf(fid, '%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e\n', ...
                         out1(i,1), out1(i,2), out1(i,3), out1(i,4), out2l(i), out2(i), out2h(i), out3l(i), out3(i), out3h(i), ...
                         out4l(i), out4(i), out4h(i), out5(i), out6(i), out7(i), out8(i), out9(i), out10(i));
            end
    else
        fprintf(fid, '%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s\n', ...
            'Temperature', 'CDdata', 'UVdata', 'LowerBoundCD', 'CDfit', 'UpperBoundCD', ...
            'LowerBoundUV', 'UVfit', 'UpperBoundUV', ...
            'Phi1', 'PhiA', 'PhiB', 'Ka', 'Kb', 'Residual');
            for i=1:nT2
                     fprintf(fid, '%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e%16e\n', ...
                         out1(i,1), out1(i,2), out1(i,3), out2l(i), out2(i), out2h(i), out3l(i), out3(i), out3h(i), ...
                         out5(i), out6(i), out7(i), out8(i), out9(i), out10(i));
            end
    end
    fclose(fid);
end

%% Plot the pseudo phase diagram
phasediagram='off';
switch phasediagram
    case 'on'
        % Define conditions to be investigated
        Cmin=-7; Cmax=-3; nC=100;
        Tmin=200; Tmax=400; nT=1000;

        Cvec=logspace(Cmin,Cmax,nC)';
        save(strcat('Cvec-model.txt'),'Cvec','-ASCII')
        Tvec=linspace(Tmax,Tmin,nT)';
        save(strcat('Tvec-model.txt'),'Tvec','-ASCII')
        
        [X,Y]=meshgrid(Cvec,Tvec);
        Z=X.*Y;

        C(:,:,1) = rand(size(Z));
        C(:,:,2) = rand(size(Z));
        C(:,:,3) = rand(size(Z));
        
        Color_Grey  = [216 216 216];
        Color_Green = [177 235 184];
        Color_Red   = [249 183 183];

        % Solve mass balance for each condition
        for k=1:nC
            options=optimset('Display', 'off', 'TolFun', 1e-18, 'TolX', 1e-18);
            range1=1e-14;   
            Ct=Cvec(k);      

            K2_Ta = exp(-(dH2a-Tvec.*dS2a)./(R.*Tvec));
            K_Ta = exp(-(dHa-Tvec.*dSa)./(R.*Tvec));     
            K2_Tb = exp(-(dH2b-Tvec.*dS2b)./(R.*Tvec));  
            K_Tb = exp(-(dHb-Tvec.*dSb)./(R.*Tvec)); 
            save(strcat('K2a-model.txt'),'K2_Ta','-ASCII')
            save(strcat('Ka-model.txt'),'K_Ta','-ASCII')
            save(strcat('K2b-model.txt'),'K2_Tb','-ASCII')
            save(strcat('Kb-model.txt'),'K_Tb','-ASCII')
            sigma_a=K2_Ta./K_Ta;                       
            sigma_b=K2_Tb./K_Tb;
            Bvec=K_Tb./K_Ta;

            Mvec=zeros(nT,1); 
            res=zeros(nT,1);

            
            
            for i=1:nT  
                lb=0;
                ub=1;
                Ka=K_Ta(i);
                Kb=K_Tb(i);
                sa=sigma_a(i);
                sb=sigma_b(i);
                xtot=Ka*Ct;

                B=Kb/Ka;

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
                        x1(i,1) = fzero(@(x1) DZT_004_cost(x1, xtot, sa, sb, Ka, Kb),...
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
                            x1(i,1) = fzero(@(x1) DZT_004_cost(x1, xtot, sa, sb, Ka, Kb),...
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
                            x1(i,1) = fzero(@(x1) DZT_004_cost(x1, xtot, sa, sb, Ka, Kb),...
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
                                x1(i,1) = fzero(@(x1) DZT_004_cost(x1, xtot, sa, sb, Ka, Kb),...
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
                                x1(i,1) = fzero(@(x1) DZT_004_cost(x1, xtot, sa, sb, Ka, Kb),...
                                    xrange, options);
                            end

                        end

                 end
                 concentrationA1(i,1)=(1/Ka)*sa*(x1(i,1)/((1-x1(i,1))^2)-x1(i,1));
                 concentrationB1(i,1)=(1/Ka)*sb*(x1(i,1)/((1-B*x1(i,1))^2)-x1(i,1));
                 concentrationM1(i,1)=(1/Ka)*x1(i,1);

                 conc_a=zeros(kkend,1);
                 for jj=2:kkend
                     conc_a(jj)=jj*(1/Ka)*sa*x1(i,1)^jj;
                 end
                 conc_jj_cum=sum(conc_a);
                 conc_b=zeros(kkend,1);
                 for kk=2:kkend
                     conc_b(kk)=kk*(1/Kb)*sb*(B*x1(i,1))^kk;
                 end
                 conc_kk_cum=sum(conc_b);
                 conc_t=conc_a+conc_b;

                 Mvec(i)=x1(i,1);
            end
            
            disp(strcat('Population Diagram-',num2str(k)))

            phiA=(sigma_a.*(Mvec./((1-Mvec).^2)-Mvec))./(K_Ta*Ct);
            phi1=Mvec./(K_Ta*Ct);
            phiB=ones(size(Mvec))-phi1-phiA;
             save(strcat('PDphiA-conc',num2str(k),'.txt'),'phiA','-ASCII')
             save(strcat('PDphiB-conc',num2str(k),'.txt'),'phiB','-ASCII')
             save(strcat('PDphi1-conc',num2str(k),'.txt'),'phi1','-ASCII')
             

            C(:,k,1)=round(phi1*Color_Grey(1)+phiA*Color_Green(1)+phiB*Color_Red(1))/255;
            C(:,k,2)=round(phi1*Color_Grey(2)+phiA*Color_Green(2)+phiB*Color_Red(2))/255;
            C(:,k,3)=round(phi1*Color_Grey(3)+phiA*Color_Green(3)+phiB*Color_Red(3))/255;
        end
        
        % Plot pseudo phase diagram
        h_fig=figure('name','Population Diagram','numbertitle','off');
        surf(X,Y,Z,C,'EdgeColor','None','EdgeAlpha',0)
        set(gca,'XScale','log')
        view(2)
%         axis([min(Cvec) max(Cvec) baseLine roof(1)])
        title('Phase Diagram');
        xlabel('Total Monomer Concentration'); 
        ylabel('Temperature');
        print(h_fig,'-depsc','-r300','-tiff','Phase Diagram BiPy')
        print(h_fig,'-dsvg','-r300','Phase Diagram BiPy')
        print(h_fig,'-dpng','-r300','Phase Diagram BiPy')
        print(h_fig,'-dtiff','-r300','Phase Diagram BiPy')
    case 'off'
        disp('No Phase Diagram has been created')
end
