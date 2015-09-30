% AnalyzerMassBalance_TP
% Script containing the mass balance for a two-pathway competitive model,
% designed for use with AnalyzerThermodynamicFit_TP.

function f=AnalyzerMassBalance_TP(M,Xt,sa,sb,Ka,Kb)

f=1-(M/Xt)-(sa/Xt)*(M/((1-M)^2)-M)-(sb/Xt)*(M/((1-(Kb/Ka)*M)^2)-M);