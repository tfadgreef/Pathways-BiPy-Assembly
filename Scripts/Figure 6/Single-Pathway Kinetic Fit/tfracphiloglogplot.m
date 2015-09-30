% tfracphiloglogplot.m
% This script identifies the t50 and t90 of a simulation, and plots the
% mole fractions of different aggregates in time. 

function [t90,t50] = tfracphiloglogplot( t, y, C, np, nrodes, ptitle )

cmap1 = [0.170718953013420   0.448627471923828   0.676339864730835];
cmap2 = [0.652049899101257   0.824598968029022   0.283778965473175];
cmap3 = [1 0 0];

[Mmono, Mpre, Mpost] = speciesToFractions(t, y, np, nrodes);
Mmono = Mmono/C;
Mpre = Mpre/C;
Mpost = Mpost/C;

% Identify t90 and t50 of simulation
nT=length(t);
a90=0; a50=0;
for i=1:nT
    if abs((Mpost(nT)-Mpost(1))/Mpost(1)) > 1e-4
        if 9 * abs(Mpost(nT+1-i)-Mpost(nT)) > abs(Mpost(nT+1-i)-Mpost(1)) && a90 == 0
            a90 = 1; 
            t90 = t(nT+1-i);
        end
        if abs(Mpost(nT+1-i)-Mpost(nT)) > abs(Mpost(nT+1-i)-Mpost(1)) && a50 == 0
            a50 = 1;
            t50 = t(nT+1-i);
        end
    else 
        t90 = 0;
        t50 = 0;
    end
end

% Create plots
loglog(t, Mmono, 'Color', cmap1, 'LineWidth', 2);
ylim([1e-4 10^0.1]);
xlim([1e-5 1e5]);
hold on;
loglog(t, Mpre, 'Color', cmap2, 'LineWidth', 2);
loglog(t, Mpost, 'Color', cmap3, 'LineWidth', 2);
hold off;
set(gca, 'FontSize', 12);
xlabel('time (s)', 'FontAngle', 'italic','FontSize', 12);
ylabel('\phi (-)', 'FontAngle', 'italic','FontSize', 12);
title(ptitle, 'FontSize', 14, 'FontWeight', 'bold');

end

