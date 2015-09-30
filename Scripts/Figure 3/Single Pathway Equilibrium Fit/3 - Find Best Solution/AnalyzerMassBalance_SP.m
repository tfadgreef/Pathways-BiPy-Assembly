% AnalyzerMassBalance_SP
% Script containing the mass balance for a nucleated Goldstein-Stryer one-pathway model,
% designed for use with AnalyzerThermodynamicFit_SP.

function f=AnalyzerMassBalance_SP(x1, xtot, s, n)

f=xtot-(1/s)*(((s*x1)^(n+1)*(n*s*x1-n-1))/((s*x1-1)^2)+(s*x1)/((s*x1-1)^2))+s^(n-1)*(x1^(n+1)*(x1*n-n-1))/((x1-1)^2);
