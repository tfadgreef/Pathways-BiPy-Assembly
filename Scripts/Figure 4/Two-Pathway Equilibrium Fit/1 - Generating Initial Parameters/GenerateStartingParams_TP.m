% Generate J starting parameter sets as input for a thermodynamic parameter 
% optimization routine using the two-pathway model. We define optimally 
% chosen initial parameter sets using linked Latin Hypercube Sampling (LHS). 
% LHS is a method to efficiently sample the entire parameter space, as
% opposed to fully random sampling. Additionally, to prevent large numbers
% of non-convergent fits because of unreasonable parameter combinations,
% the thermodynamic parameters for a single fit are chosen in a linked
% fashion with another layer of randomization. The parameters in the
% two-pathway model are as follows:
% [deltaH_A_nuc, deltaH_A_el, deltaS_A, deltaH_B_nuc, deltaH_B_el, deltaS_B, epsm, depsa, epsa, flinta, depsb, epsb, flintb]
% In the implementation for the two-pathway model, the first six parameters
% are the thermodynamic values of the model, then seven optical
% coefficients are included and finally twelve correction factors for
% nonlinear response in the UV- and FL-channels. 

% Set properties of equilibrium fitting routine
J=400;

% Set Latin Hypercube Sampling properties 
dHavec=-70000+40000*(lhsdesign(J,1)-0.5);
dHbvec=-80000+40000*(lhsdesign(J,1)-0.5);
dEavec=45000+20000*(lhsdesign(J,1)-0.5);
FLavec=45000+20000*(lhsdesign(J,1)-0.5);
Emvec=63000+20000*(lhsdesign(J,1)-0.5);
param=[0.985*dHavec+2000*(lhsdesign(J,1)-0.5), dHavec, 0.00165*dHavec+20*(lhsdesign(J,1)-0.5),...
       0.95*dHbvec+4000*(lhsdesign(J,1)-0.5), dHbvec, 0.00183*dHbvec+20*(lhsdesign(J,1)-0.5),...
       Emvec, dEavec,0.57*Emvec+6000*(lhsdesign(J,1)-0.5),...
       FLavec , 80*dEavec+500000*(lhsdesign(J,1)-0.5),0.86*Emvec+6000*(lhsdesign(J,1)-0.5),...
       0.96*FLavec+6000*(lhsdesign(J,1)-0.5), 1+0.4*(lhsdesign(J,1)-0.5), 1+0.4*(lhsdesign(J,1)-0.5),...
       1+0.4*(lhsdesign(J,1)-0.5), 1+0.4*(lhsdesign(J,1)-0.5), 1+0.4*(lhsdesign(J,1)-0.5),...
       1+0.4*(lhsdesign(J,1)-0.5), 1+0.4*(lhsdesign(J,1)-0.5), 1+0.4*(lhsdesign(J,1)-0.5),...
       1+0.4*(lhsdesign(J,1)-0.5), 1+0.4*(lhsdesign(J,1)-0.5), 1+0.4*(lhsdesign(J,1)-0.5),...
       1+0.4*(lhsdesign(J,1)-0.5)];
save param.mat param