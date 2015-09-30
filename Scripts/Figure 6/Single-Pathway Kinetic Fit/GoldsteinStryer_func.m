% GoldsteinStryer_func.m
% This script contains the expression for the single-pathway Goldstein-Stryer model.

function f=GoldsteinStryer_func(x, xtot, n, s)

f=xtot-(1/s)*(((s*x)^(n+1)*(n*s*x-n-1))/((s*x-1)^2)+(s*x)/((s*x-1)^2))+s^(n-1)*(x^(n+1)*(x*n-n-1))/((x-1)^2);

