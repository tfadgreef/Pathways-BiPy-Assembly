% tnphinucloglogcontourf.m
% This script creates a contour plot of polymer species concentration over time.

function p = tnphinucloglogcontourf( t, y, C, n, np, contours, ptitle, clrbar )
%   t should be a vector of the time points. y should be a matrix of the
%   concentration of the species over time. Each column i represents the
%   species of length i, each row represents a time point. n is the number
%   of species of which concentrations are given. If n is equal to the
%   number of columns in y, it is assumed there was no bin used to
%   account for fibres longer than n. If the number of colums of y is
%   larger than n, a bin will be plotted using the concentration of
%   y(:,n+1). np is the nucleus size. All species smaller than the nucleus
%   will be plotted as wide bars. contours is to be a list of values that
%   should be used as ticks for the colorbar. ptitle is a string containing
%   the title of the plot.
%   Returns plot handle.

% Size of the sides (monomer and fibre bin)
sides = 100;

% Size of pre-nucleus species
nuc = 50;
mnuc = nuc/2;

% Whether the fibre bin should be shown
fibbin = (length(y(1,:)) ~= n);

% Start off with every species from the nucleus to n.
ya = y(:,np+1:n) / C;
for i=1:length(ya(1,:))
    ya(:,i) = ya(:,i) * (i + np);
end

% Add nuc times each pre-nuclues species
for ns=np:-1:2
    for i=1:nuc
        ya = [ns*y(:,ns)/C ya];
    end
end

% Add sides times the monomer and fibre bin
for i=1:sides
    if fibbin
        ya = [y(:,1)/C ya y(:,n+2)/C];
    else
        ya = [y(:,1)/C ya];
    end
end

% Calculate the total length of the plot
if fibbin
    totl = n - np + 2*sides + (np-1)*nuc;
else
    totl = n - np  + sides + (np-1)*nuc;
end

% Plot using 30 contour lines which will be marked by white dotted lines
p = contourf(t, 1:totl, log10(ya'), log10(contours), 'LineStyle', 'None');%, 'LineStyle', ':', 'Color', [1 1 1]);
% Adjust the color scaling to the contours given
set(gca, 'CLim', [min(log10(contours)), max(log10(contours))]);
% Set the time scale to be logarithmic
set(gca, 'FontSize', 12);
set(gca, 'xscale','log');
%set(gca,'xscale','log');

% Add the ticks to the polymer length axis. Ticks are added for each
% pre-nucleus species, for the nucleus itselves, for every 200 species and
% - if required - for the fibre bin.
if fibbin
    set(gca, 'YTick', [(sides/2) (sides+mnuc):nuc:(sides+mnuc+(np-1)*nuc-1), (sides+(np-1)*nuc):200:((sides+(np-1)*nuc)+n-1), (sides+(np-1)*nuc)+n+(sides/2)]);
else
    set(gca, 'YTick', [(sides/2) (sides+mnuc):nuc:(sides+mnuc+(np-1)*nuc-1), (sides+(np-1)*nuc):200:((sides+(np-1)*nuc)+n)]);
end

% Add the complementary labels to the ticks.
yl = {'1'};

for i=2:np
    yl = [yl [num2str(i)*(mod(i,2) && i ~= np-1) '']];
end

yl = [yl ['  ' num2str(np)]];

for i=200:200:(n-1)
    yl = [yl num2str(i)];
end
if fibbin
    yl = [yl, 'f'];
else
    yl = [yl, num2str(n)];
end
set(gca, 'YTickLabel', yl);

% Add white boxes seperating the monomer from the pre-nucleus species, the
% pre-nucleus species from the rest and the fibre bin if necessary
rectangle('Position', [min(t) sides-7 (max(t)-min(t)) 8], 'LineWidth', 1, 'LineStyle','-', 'EdgeColor', [0 0 0], 'FaceColor', [1 1 1]);
rectangle('Position', [min(t) sides+(np-1)*nuc-7 (max(t)-min(t)) 8], 'LineWidth', 1, 'LineStyle','-', 'EdgeColor', [0 0 0], 'FaceColor', [1 1 1]);
if fibbin
    rectangle('Position', [min(t) ((sides+(np-1)*nuc)+n) (max(t)-min(t)) 8], 'LineWidth', 1, 'LineStyle','-', 'EdgeColor', [0 0 0], 'FaceColor', [1 1 1]);
end

ylabel('N (-)', 'FontAngle', 'italic');
xlabel('Time (s)', 'FontAngle', 'italic');
title(ptitle, 'FontSize', 14, 'FontWeight', 'bold');
if clrbar
    cb = colorbar('location','eastoutside',...
         'FontSize',12,'YTick',log10(contours(1:2:end)),'YTickLabel',contours(1:2:end));
    set(get(cb,'ylabel'),'String', '\phi (-)');
end

end

