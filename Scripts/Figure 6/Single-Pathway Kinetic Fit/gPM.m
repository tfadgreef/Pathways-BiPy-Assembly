% gPM 
% Description of the single-pathway ODE-system.

function dx=gPM(t,x,p)
% par is the array containing the rate constants; n is not given as a parameter
% to be estimated but is kept fixed.
kpnRP=p(1);
kmnRP=p(2);
kpRP=p(3);
kmRP=p(4);

s = p(5);
nrodes = p(6);

dx = zeros(nrodes+2,1);

fP=x(nrodes+1);
mP=x(nrodes+2);

% Introduce help variables 
if (mP-(nrodes+1)*fP)<1e-99
    alphaP=0;
else 
    alphaP=1-fP/(mP-nrodes*fP);
end
f1P=fP*(1-alphaP);

% Define the actual set of differential equations from trimers on
dRP = 0;
for i=3:nrodes
  if i<=s 
    qRP = kpnRP*x(1)*x(i-1) - kmnRP*x(i); 
  else
    qRP = kpRP*x(1)*x(i-1) - kmRP*x(i); 
  end
  dx(i) = dx(i) + qRP;
  dx(i-1) = dx(i-1) - qRP;
  dRP = dRP - qRP;
end
qRP = kpRP*x(1)*x(nrodes) - kmRP*f1P;
dfP = qRP;
dmP = qRP*(nrodes+1);
dx(nrodes) = dx(nrodes) - qRP;
dRP = dRP - qRP;

qRP = kpRP*x(1)*fP-kmRP*(fP-f1P);
dmP = dmP + qRP;
dRP = dRP - qRP;

% And finally for the monomer-dimer equilibrium
qRRP = kpnRP*x(1)*x(1) - kmnRP*x(2);
    
dRP = dRP - 2*qRRP;

dx(2) = dx(2) + qRRP; 
     
dx(1) = dRP;

dx(nrodes+1) = dfP;
dx(nrodes+2) = dmP;

dx = dx(:); % For the matlab ode solvers
