function [pars, resns] = dataFitting()

disp('This function fits the kin.m model to some computer generated example data.');

PPODE_translate('kin', 'AnaJac', 1);
tic;
PPODE_build('kin.F', 'kin_BDFSparse', 'Solver', 'LSODES');
toc

load('fit-exampledata.mat', 'tex', 'yex');

% Intial values
par0 = [0.1 10 50];
% Lower bounds
lb = [0 0 1];
% Upper bounds
ub = [10 10 5000];

options = odeset('RelTol',1e-9,'AbsTol',1e-9);

    function y = fitfunc(p, tdata)
        y0(1) = p(3);
        [~, y1] = kin_BDFSparse(N,options.AbsTol,options.RelTol, tdata,p(1:2),y0);
        y = y1(:,1);
    end

Ns = [10 100 1000];

pars = NaN(length(Ns), length(par0));
resns = NaN(length(Ns), 1);

for i=1:length(Ns) 
    N = round(Ns(i));
    fprintf('Trying N=%d\n', N);
    y0 = zeros(N,1);

    [par, resn] = lsqcurvefit(@fitfunc, par0, tex, yex, lb, ub);
    pars(i,:) = par;
    resns(i,:) = resn;
end

format long;

figure(1);
plot(Ns, resns, 'r-');
title('Resnorms per Cutoff (N)');
ylabel('Resnorm');
xlabel('N (-)');

disp('Original N = 1000');
[~, mini] = min(resns);
fprintf('Minimum resnorm at N = %d\n', Ns(mini));

minpar = pars(mini,:);

disp('Original parameters: ');
disp([1.0 1.0 100]);
disp('Found paramters: ');
disp(minpar);

yfit = fitfunc(minpar, tex);
figure(2);
loglog(tex, yex, 'b.', tex, yfit, 'r-');
title('Fit of some example data');
xlabel('Time (s)');
ylabel('Conenctration (-)');

format;

end
