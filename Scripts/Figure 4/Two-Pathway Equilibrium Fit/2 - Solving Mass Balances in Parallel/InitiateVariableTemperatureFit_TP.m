% InitiateVariableTemperatureFit_SP
% This script fits cooling curves (CD-, UV- and Fluorescence-traces) at 
% fixed wavelength. The thermodynamics are described by a two-pathway 
% model adapted from theory by Bouteiller and an earlier model by 
% Daan van der Zwaag and Peter Korevaar. It is specifically designed to 
% fit datasets for compound BiPy-1.

clear
close all 
clc
format long

J=400;   % # initial parameter sets
uiteindelijke_check=[]; % initiate a vector to store the numbers of the best fits.

% Load data files: CD/UV/FL vs. Temp. Filenames should be inserted here
% manually, and scaling factors are used to eliminate any fitting bias 
% (effectively functioning as a weighting factor here).
% This scaling factor ensures that for any trace, max(trace)-min(trace)=~1
% The linear subtraction is the value for the blank (solvent).
sf=[(1/4),(100),(16);(1/9),(40),(8);(1/20),(16),(4);(1/38),(9),(2.5);(1/100),(3),(2);(1/210),(10/6),(0);(1/420),(1),(0)];
data1=load('1e-6M.txt');
Temp1=data1(:,1)+273;
CD1=sf(1,1)*(data1(:,2)-0.749945);
UV1=sf(1,2)*(data1(:,4)-0.91902);
FL1=sf(1,3)*(data1(:,5)-0.026011);
data2=load('2-5e-6M.txt');
Temp2=data2(:,1)+273;
CD2=sf(2,1)*(data2(:,2)-0.749945);
UV2=sf(2,2)*(data2(:,4)-0.91902);
FL2=sf(2,3)*(data2(:,5)-0.026011);
data3=load('5e-6M.txt');
Temp3=data3(:,1)+273;
CD3=sf(3,1)*(data3(:,2)-0.749945);
UV3=sf(3,2)*(data3(:,4)-0.91902);
FL3=sf(3,3)*(data3(:,5)-0.026011);
data4=load('1e-5M.txt');
Temp4=data4(:,1)+273;
CD4=sf(4,1)*(data4(:,2)-0.749945);
UV4=sf(4,2)*(data4(:,4)-0.91902);
FL4=sf(4,3)*(data4(:,5)-0.026011);
data5=load('2-5e-5M.txt');
Temp5=data5(:,1)+273;
CD5=sf(5,1)*(data5(:,2)-0.749945);
UV5=sf(5,2)*(data5(:,4)-0.91902);
FL5=sf(5,3)*(data5(:,5)-0.026011);
data6=load('5e-5M.txt');
Temp6=data6(:,1)+273;
CD6=10*sf(6,1)*(data6(:,2)-0.749945);   % Values for this sample are corrected by a
UV6=10*sf(6,2)*(data6(:,4)-0.91902);    % factor 10, as these were measured in a cuvette
%FL6=10*sf(6,3)*(data6(:,5)-0.026011);  % with d=1mm compared to the normal d=10mm.
data7=load('1e-4M.txt');
Temp7=data7(:,1)+273;
CD7=10*sf(7,1)*(data7(:,2)-0.749945);   % Values for this sample are corrected by a 
UV7=10*sf(7,2)*(data7(:,4)-0.91902);    % factor 10, as these were measured in a cuvette
%FL7=10*sf(7,3)*(data7(:,5)-0.026011);  % with d=1mm compared to the normal d=10mm.

CONC=[1e-6, 2.5e-6, 5e-6, 1e-5, 2.5e-5, 5e-5, 1e-4];

% Define lower and upper bounds for all  parameters. The first six
% entries are aggregation energetics-related, the next seven are
% absorption/emission coefficients (deps for CD, eps for UV and flint for FL).
% For compound BiPy-1, we assume that depsm=0 and flintm=0, and finally there
% are correction factors for non-linear absorption and emission behavior.
% The model contains two pathways, each with nucleation and elongation
% regimes. For computational feasibility, the entropy difference in
% nucleation and elongation regimes is assumed equal. 
% [dH2a, dHa, dSa, dH2b, dHb, dSb, epsm, depsa, epsa, flinta, depsb, epsb, flintb, cf1-12]
lb=[-Inf, -Inf, -Inf, -Inf, -Inf, -Inf, 0, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5];
ub=[-10000, -10000, -10, -10000, -10000, -10, Inf, Inf, Inf, Inf, Inf, Inf, Inf, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2];

% Set options for optimization
options=optimset('MaxIter',100,'Display','off','MaxFunEvals',2000,...
    'TolX',1e-7,'TolFun',1e-7);

% Set a large initial comparison threshold for the sum of squares
r_check=1e6;

% Load matrix of starting parameter values.
load('param.mat','param');

for j=1:J
    par=[param(j,1) param(j,2) param(j,3) param(j,4) param(j,5) param(j,6) ...
        param(j,7) param(j,8) param(j,9) param(j,10) param(j,11) param(j,12) param(j,13)...
        param(j,14) param(j,15) param(j,16) param(j,17) param(j,18) param(j,19) ...
        param(j,20) param(j,21) param(j,22) param(j,23) param(j,24) param(j,25)];

    % Minimize cost function (in this case sum of the differences between datapoints
    % and fit) by changing parameters. Return the parameters at best
    % fit, the sum of squared residuals, the actual residuals, the
    % lagrangian multiplier and the jacobian matrix.
    [par_fin,resnorm,residual,exitflag,output,lambda,Jacobian]=...
        lsqnonlin(@SolveMassBalance_TP,par,lb,ub,options,Temp1,CD1,UV1,FL1,...
        Temp2,CD2,UV2,FL2,Temp3,CD3,UV3,FL3,Temp4,CD4,UV4,FL4,...
        Temp5,CD5,UV5,FL5,Temp6,CD6,UV6,Temp7,CD7,UV7,CONC,sf);

    % For every starting parameter set, save the final output.
    save(['par_fin','-',num2str(j),'.mat'],'par_fin')
    save(['resnorm','-',num2str(j),'.mat'],'resnorm')
    save(['residual','-',num2str(j),'.mat'],'residual')
    save(['lambda','-',num2str(j),'.mat'],'lambda')
    save(['jacobian','-',num2str(j),'.mat'],'Jacobian')

    if resnorm <= r_check
        r_check=resnorm;
        uiteindelijke_check=[uiteindelijke_check; j];
    end
end


% Save information about the best fit.

save check1.mat uiteindelijke_check;

