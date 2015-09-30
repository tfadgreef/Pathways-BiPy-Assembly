% TwoPathwayTherm_func.m
% This script contains the expression for the two-pathway thermodynamic model.

function f=TwoPathwayTherm_func(x1, xtot, sa, sb, B)

f=xtot-x1-sa*(x1/((1-x1)^2)-x1)-sb*(x1/((1-B*x1)^2)-x1);
