%function compareSolvers()
clear all;

y0 = [0 1 1];
par = [-0.51];
t = 0:0.01:20;

options = odeset('RelTol',1e-4,'AbsTol',1e-4);

leg = {};

figure(1);
hold on;

comptime = [];
evaltime = [];

% The ode15s solver
comptime = [comptime 0];
tic;
[t1, yr] = ode15s(@(t,y)(rigid(t,y,par)),t,y0,options);
evaltime = [evaltime toc];
plot(t1, abs(yr(:,1)-yr(:,1)), 'b-');
leg = [leg 'ode15s'];

% The ode45 solver
comptime = [comptime 0];
tic;
[t1, y1] = ode45(@(t,y)(rigid(t,y,par)),t,y0,options);
evaltime = [evaltime toc];
plot(t1, y1(:,1)-yr(:,1), 'r-');
leg = [leg 'ode45'];

% The Adams-Moulton solver
tic;
PPODE_build('rigid.F', 'rigid_AM', 'Solver', 'Adams-Moulton');
comptime = [comptime toc];
tic;
[t1, y1] = rigid_AM(length(y0),options.AbsTol,options.RelTol, ...
                       t,par,y0);
evaltime = [evaltime toc];
plot(t1, y1(:,1)-yr(:,1), 'g-');
leg = [leg 'AM12'];

% The Stiff BDF solver
tic;
PPODE_build('rigid.F', 'rigid_BDF', 'Solver', 'Stiff');
comptime = [comptime toc];
tic;
[t1, y1] = rigid_BDF(length(y0),options.AbsTol,options.RelTol, ...
                       t,par,y0);
evaltime = [evaltime toc];
plot(t1, y1(:,1)-yr(:,1), 'm-');
leg = [leg 'BDF'];

% The VODE solver
tic;
PPODE_build('rigid.F', 'rigid_VODE', 'Solver', 'VODE');
comptime = [comptime toc];
tic;
[t1, y1] = rigid_VODE(length(y0),options.AbsTol,options.RelTol, ...
                       t,par,y0);
evaltime = [evaltime toc];
plot(t1, y1(:,1)-yr(:,1), 'g-');
leg = [leg 'VODE'];


% The Switching solver
tic;
PPODE_build('rigid.F', 'rigid_Switching', 'Solver', 'Switching');
comptime = [comptime toc];
tic;
[t1, y1] = rigid_Switching(length(y0),options.AbsTol,options.RelTol, ...
                       t,par,y0);
evaltime = [evaltime toc];
plot(t1, y1(:,1)-yr(:,1), 'c-');
leg = [leg 'Switching'];

% The RK23 solver
tic;
PPODE_build('rigid.F', 'rigid_RK23', 'Solver', 'RK23');
comptime = [comptime toc];
tic;
[t1, y1] = rigid_RK23(length(y0),options.AbsTol,options.RelTol, ...
                       t,par,y0);
evaltime = [evaltime toc];
plot(t1, y1(:,1)-yr(:,1), 'y-');
leg = [leg 'RK23'];

% The RK45 solver
tic;
PPODE_build('rigid.F', 'rigid_RK45', 'Solver', 'RK45');
comptime = [comptime toc];
tic;
[t1, y1] = rigid_RK45(length(y0),options.AbsTol,options.RelTol, ...
                       t,par,y0);
evaltime = [evaltime toc];
plot(t1, y1(:,1)-yr(:,1), 'r-');
leg = [leg 'RK45'];

% The RK78 solver
tic;
PPODE_build('rigid.F', 'rigid_RK78', 'Solver', 'RK78');
comptime = [comptime toc];
tic;
[t1, y1] = rigid_RK78(length(y0),options.AbsTol,options.RelTol, ...
                       t,par,y0);
evaltime = [evaltime toc];
plot(t1, y1(:,1)-yr(:,1), 'b-');
leg = [leg 'RK78'];

legend(leg);
title('Difference compared to ode15s (y(1))')
hold off;

figure(2);
bar(comptime', 'r', 'Stacked');
hold on;
bar(evaltime', 'b', 'Stacked');
hold off;
legend({'Compilation', 'Evaluation'});
title('Benchmark');
ylabel('Time (s)');
set(gca,'XTickLabel',leg);

figure(3);
plot(t1, yr(:,1), 'r-');
xlabel('Time (s)');
title('Solution for y(1)');

%end