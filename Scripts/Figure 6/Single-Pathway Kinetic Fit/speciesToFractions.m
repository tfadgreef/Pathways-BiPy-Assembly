% speciesToFraction.m
% Convert the concentration of individual species to mole fractions. 

function [ Mmon, Mprenuc, Mpostnuc ] = speciesToFractions( t, y, np, nrodes )

%% Calculate masses
% Mass of the nucleus species
Mmon = y(:, 1);
% Masses of species smaller than the nucleus, excluding monomer
Mprenuc = zeros(length(t), 1);
for k=2:np
    Mprenuc(:) = Mprenuc(:) + (y(:, k) * k);
end
% Masses of nucleus and larger
Mpostnuc = zeros(length(t), 1);
for k=np+1:nrodes
    Mpostnuc(:) = Mpostnuc(:) + (y(:, k) * k);
end
% Also consider the truncation
Mpostnuc(:) = Mpostnuc(:) + y(:, nrodes+2);

end

