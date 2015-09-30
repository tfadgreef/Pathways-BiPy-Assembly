% Generate J starting parameter sets as input for a thermodynamic parameter 
% optimization routine using the single-pathway model. We define optimally 
% chosen initial parameter sets using linked Latin Hypercube Sampling (LHS). 
% LHS is a method to efficiently sample the entire parameter space, as
% opposed to fully random sampling. Additionally, to prevent large numbers
% of non-convergent fits because of unreasonable parameter combinations,
% the thermodynamic parameters for a single fit are chosen in a linked
% fashion with another layer of randomization. The parameters in the
% single-pathway model are as follows:
% [deltaH_nuc, deltaS_nuc, deltaH_el, deltaS_el]

% Set properties of equilibrium fitting routine
J=400; % Number of LHS parameter sets
N=8; % Number of cores
CurrentDomain=cd;

% Set Latin Hypercube Sampling properties 
dHevec=-275000+150000*(lhsdesign(J,1)-0.5); 
param_overall=[0.8*dHevec+100000*(lhsdesign(J,1)-0.5), 0.002*dHevec+200*(lhsdesign(J,1)-0.5),...
       dHevec, 0.003*dHevec+200*(lhsdesign(J,1)-0.5)]; 

% Divide the parameter matrix into parts for parallel computing
for i=1:N
    cd([CurrentDomain '\Core ' num2str(i)])
    param=param_overall((i-1)*(J/N)+1:i*(J/N),:);
    save('param.mat','param','-mat')
    cd(CurrentDomain)
end

% Save the overall parameter matrix
save param_overall.mat param_overall