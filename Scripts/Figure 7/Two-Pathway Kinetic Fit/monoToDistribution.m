% monoToDistribution.m 
% Go from normalized monomer concentration to distribution.

function [ a ] = monoToDistribution( a1, n, NO, sa, sb, B)

a = zeros(2*NO+4, 1);

% Monomer
a(1) = a1;

% Pre-nucleus and nucleus
for i=2:n
    a(i) = sa^(i-1) * a1^i;
end

for i=2:n
    a(i+NO+2)= B^-1 * sb^(i-1) * (B*a1)^i;
end

% Post-nucles
for i=n+1:NO
    a(i) = sa^(n-1) * a1^i;
end

for i=n+1:NO
    a(i+NO+2) = B^-1 * sb^(n-1) * (B*a1)^i;
end

% Fibres
a(NO+1) = sa^(n-1) * a1^(NO+1)/(1-a1);
a(NO+2) = (sa^(n-1)) * (-(a1^(NO+1)) * (NO*a1-NO-1))/((a1-1)^2);    
a(2*NO+3) = sb^(n-1) * (B*a1)^NO * a1 / (1-B*a1);
a(2*NO+4) = (sb^(n-1)) * (B*a1)^NO * (-a1 * (B*NO*a1-NO-1))/((B*a1-1)^2);  

end

