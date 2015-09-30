% gTP 
% Description of the two-pathway ODE-system.

function dz=gTP(t,y,par)
% par is the array containing the rate constants; n is not given as a parameter
% to be estimated but is kept fixed.
kpnRP=par(1);
kmnRP=par(2);
kpRP=par(3);
kmRP=par(4);
kpnRM=par(5);
kmnRM=par(6);
kpRM=par(7);
kmRM=par(8);

nA=par(9);
nB=nA;
NO=par(10);

xP = zeros(NO,1);
dxP = zeros(NO,1);
for i=1:NO
  xP(i) = y(i);
  dxP(i) = 0;
end
fP=y(NO+1);
mP=y(NO+2);

xM = zeros(NO,1);
dxM = zeros(NO,1);
for i=1:NO
  xM(i) = y(i+NO+2);
  dxM(i) = 0;
end
fM=y(2*NO+3);
mM=y(2*NO+4);

% Introduce help variables 
if (mP-(NO+1)*fP)<1e-99
    alphaP=0;
else 
    alphaP=1-fP/(mP-NO*fP);
end
f1P=fP*(1-alphaP);

if (mM-(NO+1)*fM)<1e-99
    alphaM=0;
else
    alphaM=1-fM/(mM-NO*fM);
end
f1M=fM*(1-alphaM);

% Define the actual set of differential equations from trimers on
dRP = 0;
for i=3:NO
  if i<=nA 
    qRP = kpnRP*xP(1)*xP(i-1) - kmnRP*xP(i); 
  else
    qRP = kpRP*xP(1)*xP(i-1) - kmRP*xP(i); 
  end
  dxP(i) = dxP(i) + qRP;
  dxP(i-1) = dxP(i-1) - qRP;
  dRP = dRP - qRP;
end
qRP = kpRP*xP(1)*xP(NO) - kmRP*f1P;
dfP = qRP;
dmP = qRP*(NO+1);
dxP(NO) = dxP(NO) - qRP;
dRP = dRP - qRP;

qRP = kpRP*xP(1)*fP-kmRP*(fP-f1P);
dmP = dmP + qRP;
dRP = dRP - qRP;

% now for the M stacks
dRM = 0;
for i=3:NO
  if i<=nB 
    qRM = kpnRM*xP(1)*xM(i-1) - kmnRM*xM(i); 
  else
    qRM = kpRM*xP(1)*xM(i-1) - kmRM*xM(i); 
  end
  dxM(i) = dxM(i) + qRM;
  dxM(i-1) = dxM(i-1) - qRM;
  dRM = dRM - qRM;
end
qRM = kpRM*xP(1)*xM(NO) - kmRM*f1M;
dfM = qRM;
dmM = qRM*(NO+1);
dxM(NO) = dxM(NO) - qRM;
dRM = dRM - qRM;

qRM = kpRM*xP(1)*fM-kmRM*(fM-f1M);
dmM = dmM + qRM;
dRM = dRM - qRM;

% And finally for the monomer-dimer equilibrium
qRRP = kpnRP*xP(1)*xP(1) - kmnRP*xP(2);
qRRM = kpnRM*xP(1)*xP(1) - kmnRM*xM(2);

    
dRP = dRP - 2*qRRP;
dRM = dRM - 2*qRRM;

dxP(2) = dxP(2) + qRRP; 
dxM(2) = dxM(2) + qRRM; 
     
dxP(1) = dRP+dRM;
dxM(1) = 0;

% Store differential equations in avector. This has to be a column which
% the ode-solver is able to read.
dz=zeros(2*NO+4,1);
for i=1:NO
  dz(i)=dxP(i);
end
dz(NO+1)=dfP;
dz(NO+2)=dmP;
for i=1:NO
  dz(i+NO+2)=dxM(i);
end
dz(2*NO+3)=dfM;
dz(2*NO+4)=dmM;
