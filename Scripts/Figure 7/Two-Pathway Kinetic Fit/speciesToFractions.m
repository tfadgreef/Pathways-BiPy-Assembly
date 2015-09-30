% speciesToFraction.m
% Convert the concentration of individual species to mole fractions. 

function [ Mmon, MpathA, MpathB ] = speciesToFractions( t, y, ~, NO )

%% Calculate masses
% Mass of the nucleus species
Mmon = y(:, 1);

% Masses of species in pathway A, excluding monomer
MpathA = zeros(length(t), 1);
for k=2:NO
    MpathA(:) = MpathA(:) + (y(:, k) * k);
end
% Add the bin
MpathA(:) = MpathA(:) + y(:, NO+2);

% Masses of species in pathway B
MpathB = zeros(length(t), 1);
for k=2:NO
    MpathB(:) = MpathB(:) + (y(:, k+NO+2) * k);
end
% Also consider the truncation
MpathB(:) = MpathB(:) + y(:, 2*NO+4);

end

