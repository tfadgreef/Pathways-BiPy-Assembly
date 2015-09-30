% MassBalanceExpression_TP
% Script containing the mass balance for a two-pathway competitive model,
% designed for use with SolveMassBalance_TP.

function f=MassBalanceExpression_TP(x1, xtot, sa, sb, B)

f=xtot-x1-sa*(x1/((1-x1)^2)-x1)-sb*(x1/((1-B*x1)^2)-x1);


