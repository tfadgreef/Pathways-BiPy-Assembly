% tfracphiloglogplot.m
% This script identifies the t50 and t90 of a simulation, and plots the
% mole fractions of different aggregates in time. 

function [t90,t50] = tfracphiloglogplot( t, y, C, n, NO, ptitle )

cmap1 = [0.170718953013420   0.448627471923828   0.676339864730835];
cmap2 = [0.652049899101257   0.824598968029022   0.283778965473175];
cmap3 = [1 0 0];

[Mmono, MpathA, MpathB] = speciesToFractions(t, y, n, NO);
Mmono = Mmono/C;
MpathA = MpathA/C;
MpathB = MpathB/C;

% Identify t90 and t50 of simulation
nT=length(t);
a90=0; a50=0;
for i=1:nT
    if abs((MpathB(nT)-MpathB(1))/MpathB(1)) > 1e-4
        if 9 * abs(MpathB(nT+1-i)-MpathB(nT)) > abs(MpathB(nT+1-i)-MpathB(1)) && a90 == 0
            a90 = 1; 
            t90 = t(nT+1-i);
        end
        if abs(MpathB(nT+1-i)-MpathB(nT)) > abs(MpathB(nT+1-i)-MpathB(1)) && a50 == 0
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
loglog(t, MpathA, 'Color', cmap2, 'LineWidth', 2);
loglog(t, MpathB, 'Color', cmap3, 'LineWidth', 2);
hold off;
set(gca, 'FontSize', 12);
xlabel('time (s)', 'FontAngle', 'italic','FontSize', 12);
ylabel('\phi (-)', 'FontAngle', 'italic','FontSize', 12);
title(ptitle, 'FontSize', 14, 'FontWeight', 'bold');

end

