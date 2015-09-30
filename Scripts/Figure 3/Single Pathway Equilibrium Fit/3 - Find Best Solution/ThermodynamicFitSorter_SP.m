% ThermodynamicFitSorter_SP
% This script sorts huge datasets of fitting results for thermodynamic fits 
% according to nucleus size. 
n_max=10;
j_max=50;
m_cores_max=8;
TrackMatrix=ones(m_cores_max*j_max,n_max-1);
CurrentDomain=cd;
param=[];

for m = 1:m_cores_max
    cd([CurrentDomain '\Core ' num2str(m) '\FitResults'])
    ParamStruc=load('param.mat');
    ParamTemp=ParamStruc.param;
    param=[param;ParamTemp];
    for n = 2:n_max
        for j = 1:j_max
            try
                copyfile([CurrentDomain '\Core ' num2str(m) ...
                    '\FitResults\jacobian_n' num2str(n) '_j' num2str(j) '.mat'],...
                    [CurrentDomain '\NucleusSize_' num2str(n) '\jacobian_n' ...
                    num2str(n) '_j' num2str(50*(m-1)+j) '.mat'])
                copyfile([CurrentDomain '\Core ' num2str(m) ...
                    '\FitResults\lagrangian_n' num2str(n) '_j' num2str(j) '.mat'],...
                    [CurrentDomain '\NucleusSize_' num2str(n) '\lagrangian_n' ...
                    num2str(n) '_j' num2str(50*(m-1)+j) '.mat'])
                copyfile([CurrentDomain '\Core ' num2str(m) ...
                    '\FitResults\par_fin_n' num2str(n) '_j' num2str(j) '.mat'],...
                    [CurrentDomain '\NucleusSize_' num2str(n) '\par_fin_n' ...
                    num2str(n) '_j' num2str(50*(m-1)+j) '.mat'])
                copyfile([CurrentDomain '\Core ' num2str(m) ...
                    '\FitResults\residual_n' num2str(n) '_j' num2str(j) '.mat'],...
                    [CurrentDomain '\NucleusSize_' num2str(n) '\residual_n' ...
                    num2str(n) '_j' num2str(50*(m-1)+j) '.mat'])
                copyfile([CurrentDomain '\Core ' num2str(m) ...
                    '\FitResults\resnorm_n' num2str(n) '_j' num2str(j) '.mat'],...
                    [CurrentDomain '\NucleusSize_' num2str(n) '\resnorm_n' ...
                    num2str(n) '_j' num2str(50*(m-1)+j) '.mat'])
            catch
                TrackMatrix(50*(m-1)+j,n-1)=0;
            end
        end
    
    end
end

for n2=2:n_max
    cd([CurrentDomain '\NucleusSize_' num2str(n2)])
    save('param.mat','param','-MAT')
end