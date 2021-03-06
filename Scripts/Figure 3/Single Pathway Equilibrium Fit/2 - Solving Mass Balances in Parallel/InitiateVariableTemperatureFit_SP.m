% InitiateVariableTemperatureFit_SP
% This script fits cooling curves (CD-, UV- and Fluorescence-traces) at 
% fixed wavelength. The thermodynamics are described by a single pathway 
% model adapted from theory by Powers and Powers and an earlier model by 
% Daan van der Zwaag and Peter Korevaar. It is specifically designed to 
% fit datasets for compound BiPy-1.

clear
close all 
clc
format long

J=50;   % # initial parameter sets
final_check=[]; % initiate a vector to store the numbers of the best fits.
n_max=10; % maximum nucleus size

% Initiate files in which the residual sums of squares are stored, together
% with nucleus size.
for j=1:J
        eval(['nucsize_resnorm_j' num2str(j) '=[];']);
end

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

Temp=cell(7,1);
Temp{1,1}=Temp1; Temp{2,1}=Temp2; Temp{3,1}=Temp3; Temp{4,1}=Temp4; Temp{5,1}=Temp5; Temp{6,1}=Temp6; Temp{7,1}=Temp7;
CD=cell(7,1);
CD{1,1}=CD1; CD{2,1}=CD2; CD{3,1}=CD3; CD{4,1}=CD4; CD{5,1}=CD5; CD{6,1}=CD6; CD{7,1}=CD7;
UV=cell(7,1);
UV{1,1}=UV1; UV{2,1}=UV2; UV{3,1}=UV3; UV{4,1}=UV4; UV{5,1}=UV5; UV{6,1}=UV6; UV{7,1}=UV7;
FL=cell(7,1);
FL{1,1}=FL1; FL{2,1}=FL2; FL{3,1}=FL3; FL{4,1}=FL4; FL{5,1}=FL5; %FL{6,1}=FL6; FL{7,1}=FL7;

CONC=[1e-6, 2.5e-6, 5e-6, 1e-5, 2.5e-5, 5e-5, 1e-4];

% Define lower and upper bounds for the thermodynamic parameters.
% There is a single pathway present, with nucleation and elongation steps.
% [dHn, dSn, dHe, dSe]
lb=[-Inf, -Inf, -Inf, -Inf];
ub=[-10000, -10, -10000, -10];

% Set options for optimization
options=optimset('MaxIter',300,'Display','off','MaxFunEvals',2000,...
    'TolX',1e-7,'TolFun',1e-7);

% Set a large initial comparison threshold for the sum of squares
r_check=1e6;

% Load matrix of starting parameter values.
load('param.mat','param');
param=param(1:J,:);

for n=2:n_max
    for j=1:J
        try
            par=param(j,:);

            % Minimize cost function (in this case sum of the differences between datapoints
            % and fit) by changing parameters. Return the parameters at best
            % fit, the sum of squared residuals, the actual residuals, the
            % lagrangian multiplier and the jacobian matrix.
            [par_fin,resnorm,residual,exitflag,output,lambda,Jacobian]=...
                lsqnonlin(@SolveMassBalance_SP,par,lb,ub,options,Temp,CD,UV,FL,...
                CONC,sf,n);

            % For every starting parameter set, save the final output.
            save(['par_fin_n',num2str(n),'_j',num2str(j),'.mat'],'par_fin')
            save(['resnorm_n',num2str(n),'_j',num2str(j),'.mat'],'resnorm')
            save(['residual_n',num2str(n),'_j',num2str(j),'.mat'],'residual')
            save(['lagrangian_n',num2str(n),'_j',num2str(j),'.mat'],'lambda')
            save(['jacobian_n',num2str(n),'_j',num2str(j),'.mat'],'Jacobian')

            % Progress indicator
            fprintf('Progress: %g %% \n', ((n-2)*J+j)/((n_max-1)*J)*100); 
            fprintf('n = %d \n', n);
            fprintf('j = %d \n', j);

            eval(['nucsize_resnorm_j' num2str(j) '=[nucsize_resnorm_j' num2str(j)...
                ';n resnorm];']);
            if resnorm <= r_check
                r_check=resnorm;
                final_check=[final_check;n j];
            end

        catch
            n
            j
        end
    end
end

% Save the matrices containing the residual norm at every n
for j=1:J
    eval(['save nucsize_resnorm_j' num2str(j) '.mat nucsize_resnorm_j' num2str(j)]);
end

% Save information about the best fit.

save check1.mat final_check;

