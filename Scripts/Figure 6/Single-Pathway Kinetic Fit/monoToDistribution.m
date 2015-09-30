% monoToDistribution.m 
% Go from normalized monomer concentration to distribution.

function [ a ] = monoToDistribution( a1, np, nrodes, sigma )

a = zeros(nrodes+2, 1);

% Monomer
a(1) = a1;

% Pre-nucleus and nucleus
for i=2:np
    a(i) = sigma^(i-1) * a1^i;
end

% Post-nucles
for i=np+1:nrodes
    a(i) = sigma^(np-1) * a1^i;
end

% Fibres
a(nrodes+1) = sigma^(np-1) * a1^(nrodes+1)/(1-a1);
a(nrodes+2) = (sigma^(np-1)) * (-(a1^(nrodes+1)) * (nrodes*a1-nrodes-1))/((a1-1)^2);    

end

