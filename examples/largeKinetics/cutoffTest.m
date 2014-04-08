clear all;

PPODE_translate('kin', 'AnaJac', 1);
tic;
PPODE_build('kin.F', 'kin_BDF', 'Solver', 'Stiff');
toc
tic;
PPODE_build('kin.F', 'kin_BDFSparse', 'Solver', 'LSODES');
toc

par = [1 1];
t = logspace(-20, 1, 5000);

options = odeset('RelTol',1e-9,'AbsTol',1e-9);

Ns = 200:200:3000;
evaltime = NaN(length(Ns),3);

for i=1:length(Ns)
    N = Ns(i);
    fprintf('Cutoff = %d\n', N);
    y0 = zeros(N,1);
    y0(1) = 100;

    if (N <= 1000)
        % The ode15s solver
        tic;
        [t1, y1] = ode15s(@(t,y)(kin(t,y,par,N)),t,y0,options);
        evaltime(i, 1) = toc;

        % The Stiff BDF solver
        tic;
        [t1, y1] = kin_BDF(N,options.AbsTol,options.RelTol, ...
                               t,par,y0);
        evaltime(i, 2) = toc;
    end

    % The Sparse Jac BDF solver
    tic;
    [t1, y1] = kin_BDFSparse(N,options.AbsTol,options.RelTol, ...
                           t,par,y0);
    evaltime(i, 3) = toc;
end

figure(1);
plot(Ns, evaltime(:,1), 'b-', Ns, evaltime(:,2), 'r-', Ns, evaltime(:,3), 'g-');
legend({'ode15s', 'LSODE', 'LSODES'});
title('Large Kinetics Problem');
xlabel('N_{cutoff} (-)');
ylabel('Evaluation Time (s)');
