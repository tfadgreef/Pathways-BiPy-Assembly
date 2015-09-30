% KineticSimulationTJump_TP
% This script simulates a T-Jump experiment using coupled ODE-equations to
% describe the rate of change in the concentration of individual species.
% Here, a two-pathway model is used, in which aggregates change size by
% monomer transfer, as described by work of Peter Korevaar. 
% The system of ODEs is solved using PPODESUITE, requiring kinetic
% parameters as input and yielding the time-dependent concentration
% changes in the system as output. Optionally, thermodynamic parameters can
% be used as constraints. This script is specifically designed to simulate
% the behavior of compound BiPy-1.

%% Build the model in Fortran using PPODESUITE
PPODE_translate('gTP', 'AnaJac', 1);
PPODE_build('gTP.F', 'gTPPP', 'Solver', 'AUTO', 'MaxSteps', 20000,...
   'MaxTime',[0 1],'InputNNZ', 0, 'Debug', 0);

%% Figures
columns = 3;

%% Cycle over concentrations and jumps
conc_vector=logspace(-7,-3,20); N_c=length(conc_vector);
CurrentDomain=cd;

% TJumps
Ts = [0 5 10 15 20 25];
l = length(Ts);

% Initiate storage vectors
t90_vector=zeros(N_c,l); t50_vector=zeros(N_c,l);
maxEnerSteps=20;
EnergyScape_A=zeros(N_c,maxEnerSteps); EnergyScape_B=zeros(N_c,maxEnerSteps);

% Cycle over different concentrations
for i=1:N_c
    ctot = conc_vector(i);

    %% Set the parameters
    % Thermodynamic Parameters (from thermodynamic two-pathway fit, n=2, DZT004)
    % Two aggregate states called A and B.
    dHnA     = -1.0314667e5;
    dHeA     = -7.3174825e4;
    dSA      = -2.3213507e2;
    dHnB     = -3.2616052e5;
    dHeB     = -3.2264361e5;
    dSB      = -9.8485124e2;

    Tfin    = 20 + 273;

    R       = 8.3144621;

    % Simulation properties
    n      = 2; % Currently, the script uses a K2K model to solve the mass balance, so is restricted to nA=nB=2
    NO      = 1000;

    % Molecular properties
    KnA=exp(-(dHnA-Tfin*dSA)/(R*Tfin));
    KeA=exp(-(dHeA-Tfin*dSA)/(R*Tfin));
    sigmaA=KnA/KeA;

    aA=1; % ratio of forward rate constants of nucleation and elongation
    kefA=1e8; % forward rate constant of elongation
    knfA=aA*kefA; % forward rate constant of nucleation, determined by a and kef

    kebA=kefA/KeA; % backward rate constant of elongation
    knbA=knfA/KnA; % backward rate constant of nucleation


    KnB=exp(-(dHnB-Tfin*dSB)/(R*Tfin));
    KeB=exp(-(dHeB-Tfin*dSB)/(R*Tfin));
    sigmaB=KnB/KeB;

    aB=1; % ratio of forward rate constants of nucleation and elongation
    kefB=1e8; % forward rate constant of elongation
    knfB=aB*kefB; % forward rate constant of nucleation, determined by a and kef

    kebB=kefB/KeB; % backward rate constant of elongation
    knbB=knfB/KnB; % backward rate constant of nucleation

    par=[knfA;knbA;kefA;kebA;knfB;knbB;kefB;kebB];

    % Dilutions
    dilx = 3.5;
    dil = 1./dilx;

    % Set colorbar ticks
    contours = logspace(-6, 0, 13);

    % Benchmark
    bench = [];

    tdata = cell(l,1);
    ydata = cell(l,1);
    
    %% Perform simulation
    % Cycle over different initial temperatures
    for j=1:l
        fprintf('Progress: %d%%\n', round(100*(j-1)/l))    

        Tinit       = Tfin + Ts(j);

        % Thermodynamic parameters at initial conditions
        KnA_init=exp(-(dHnA-Tinit*dSA)/(R*Tinit));
        KeA_init=exp(-(dHeA-Tinit*dSA)/(R*Tinit));
        sigmaA_init  = KnA_init/KeA_init;

        KnB_init=exp(-(dHnB-Tinit*dSB)/(R*Tinit));
        KeB_init=exp(-(dHeB-Tinit*dSB)/(R*Tinit));
        sigmaB_init  = KnB_init/KeB_init;

        B   = KeB_init/KeA_init;

        %% Using Mass Balance Model
        % Two-pathway model for solving the equilibrium monomer concentration
        x = TwoPathwayTherm(ctot, KnA_init, KeA_init, KnB_init, KeB_init);

        % Get distribution and de-normalize
        y0 = monoToDistribution(x, n, NO, sigmaA_init, sigmaB_init, B) ./ KeA_init;

        t = logspace(-5, 5, 2000);

        % Calculate Energy Diagram
        for mA=2:maxEnerSteps
            if mA <= n
                EnergyScape_A(i,mA) = EnergyScape_A(i,mA-1) - R*Tfin*(log(KnA)+log(ctot*dil));
            elseif mA > n
                EnergyScape_A(i,mA) = EnergyScape_A(i,mA-1) - R*Tfin*(log(KeA)+log(ctot*dil));
            end
        end

        for mB=2:maxEnerSteps
            if mB <= n
                EnergyScape_B(i,mB) = EnergyScape_B(i,mB-1) - R*Tfin*(log(KnB)+log(ctot*dil));
            elseif mB > n
                EnergyScape_B(i,mB) = EnergyScape_B(i,mB-1) - R*Tfin*(log(KeB)+log(ctot*dil));
            end
        end

        %% Perform Kinetic Simulation
        % Apply the dilution
        y0 = y0 .* dil;

        tic;
        [t, y] = gTPPP(2*NO+4, 1e-21, 1e-10, t, [par' n NO], y0);

        % Occasionally, optimization of the convergence tolerances is
        % needed to achieve an accurate solution in a reasonable timeframe.
        if min(max(y,[],2)) == 0 || max(max(isnan(y))) == 1
            t = logspace(-5, 5, 2000);
            [t, y] = gTPPP(2*NO+4, 1e-24, 1e-12, t, [par' n NO], y0);
            if min(max(y,[],2)) == 0 || max(max(isnan(y))) == 1
                t = logspace(-5, 5, 2000);
                [t, y] = gTPPP(2*NO+4, 1e-22, 1e-11, t, [par' n NO], y0);
                if min(max(y,[],2)) == 0 || max(max(isnan(y))) == 1
                    t = logspace(-5, 5, 2000);
                    [t, y] = gTPPP(2*NO+4, 1e-20, 1e-9, t, [par' n NO], y0);
                    if min(max(y,[],2)) == 0 || max(max(isnan(y))) == 1
                        disp('Numerical integration of this experiment did not converge.')
                    end
                end
            end
        end

        bench = [bench toc];

        tdata{j} = t;
        ydata{j} = y;
    end

    figure(1);
    set(gcf,'WindowStyle','docked');
    colormap(interp1(1:9,cbrewer('seq', 'GnBu', 9),1:0.1:9));
    figure(2);
    set(gcf,'WindowStyle','docked');
    colormap(interp1(1:9,cbrewer('seq', 'OrRd', 9),1:0.1:9))
    figure(3);
    set(gcf,'WindowStyle','docked');
    colormap(interp1(1:9,cbrewer('seq', 'GnBu', 9),1:0.1:9));

    % Calculate and plot the molecular distributions over time
    for j=1:l
        Tfin = 20 + Ts(j);

        t = tdata{j};
        y = ydata{j};
        yA= y(:,1:NO+2);
        yB= [y(:,1) y(:,NO+3:2*NO+4)];

        %% Filled contour plot
        figure(1);
        %set(gcf,'WindowStyle','docked');
        pp = floor((j-1)/columns)*(columns) + mod(j-1, columns) + 1;
        subplot(ceil(l/(columns)), columns, pp);
        tnphinucloglogcontourf(t, yA, ctot*dil, NO, n, contours, sprintf('T-Jump %d^{\\circ}C -> 20^{\\circ}C', Tfin), 0);

        figure(2);
        %set(gcf,'WindowStyle','docked');
        pp = floor((j-1)/columns)*(columns) + mod(j-1, columns) + 1;
        subplot(ceil(l/(columns)), columns, pp);
        tnphinucloglogcontourf(t, yB, ctot*dil, NO, n, contours, sprintf('T-Jump %d^{\\circ}C -> 20^{\\circ}C', Tfin), 0);

        %% Fractions Plot
        figure(3);
        %set(gcf,'WindowStyle','docked');
        subplot(ceil(l/columns), columns, j);
        % Calculate fractions
        [t90,t50]=tfracphiloglogplot(t, y, ctot*dil, n, NO, sprintf('T-Jump %d^{\\circ}C -> 20^{\\circ}C', Tfin));
        %set(gca, 'XScale', 'Linear');
        %set(gca, 'YScale', 'Linear');
        %xlim([0 15]);
        t90_vector(i,j)=t90;
        t50_vector(i,j)=t50;
        if (j == 1)
            legend({'monomer', 'path A', 'path B'});
        end
    end

    figure(1);
    cb = colorbar([0.94 0.15 0.02 0.7], 'FontSize',12,...
        'YTick',log10(contours(1:2:end)),'YTickLabel',contours(1:2:end));
    set(get(cb,'ylabel'),'String', '\phi (-)');
    set(get(cb,'ylabel'),'FontAngle', 'italic');
    set(get(cb,'ylabel'),'FontSize', 12);

    figure(2);
    cb = colorbar([0.94 0.15 0.02 0.7], 'FontSize',12,...
        'YTick',log10(contours(1:2:end)),'YTickLabel',contours(1:2:end));
    set(get(cb,'ylabel'),'String', '\phi (-)');
    set(get(cb,'ylabel'),'FontAngle', 'italic');
    set(get(cb,'ylabel'),'FontSize', 12);

    bench

    %% Save images in correct folder
    mkdir(strcat('Concentration_',num2str(ctot)));
    cd(strcat(CurrentDomain,'/Concentration_',num2str(ctot)));
    h1=figure(1);
    savefig(h1,strcat('Figure1_conc',num2str(ctot),'.fig'))
    h2=figure(2);
    savefig(h2,strcat('Figure2_conc',num2str(ctot),'.fig'))
    h3=figure(3);
    savefig(h3,strcat('Figure3_conc',num2str(ctot),'.fig'))
    cd(CurrentDomain);

end
save('t90_vector.txt','t90_vector','-ASCII')
save('t50_vector.txt','t50_vector','-ASCII')

% Select the T-jump initial temperature to display, and plot concentration
% versus t-90 and t-50, and indicate 1/K to compare.
plotKnA=(1/KnA)*ones(4,1); plotKnA_ytemp=logspace(-10,10,4)';
plotKnA=[plotKnA plotKnA_ytemp];
plotKeA=(1/KeA)*ones(4,1); plotKeA_ytemp=logspace(-10,10,4)';
plotKeA=[plotKeA plotKeA_ytemp];

plotKnB=(1/KnB)*ones(4,1); plotKnB_ytemp=logspace(-10,10,4)';
plotKnB=[plotKnB plotKnB_ytemp];
plotKeB=(1/KeB)*ones(4,1); plotKeB_ytemp=logspace(-10,10,4)';
plotKeB=[plotKeB plotKeB_ytemp];

% Plot times to completion
tjump_index=l-1;
figure(4)
cmap_temp=cbrewer('qual', 'Paired', 12);
[ax,p1,p2]=plotyy(conc_vector*dil,t90_vector(:,tjump_index),conc_vector*dil,t50_vector(:,tjump_index),'loglog');
set(ax(1),'FontSize',12); set(ax(2),'FontSize',12);
ylabel(ax(1),'t-90 (s)', 'FontAngle', 'italic','FontSize', 12);
ylabel(ax(2),'t-50 (s)', 'FontAngle', 'italic','FontSize', 12);
xlabel(ax(2),'Concentration (M)', 'FontAngle', 'italic','FontSize', 12);
YL=ylim(ax(1));
ylim(ax(2),YL);
hold on
set(ax,'LineWidth',2)
set(ax(1),'ycolor',cmap_temp(1,:))
set(ax(2),'ycolor',cmap_temp(2,:))
set(p1,'Color',cmap_temp(1,:))
set(p1,'LineWidth',2)
set(p2,'Color',cmap_temp(2,:))
set(p2,'LineWidth',2)
axKnA=loglog(plotKnA(:,1),plotKnA(:,2),'-.','Color',cmap_temp(6,:));
set(axKnA,'LineWidth',2)
axKeA=loglog(plotKeA(:,1),plotKeA(:,2),'-.','Color',cmap_temp(8,:));
set(axKeA,'LineWidth',2)
axKnB=loglog(plotKnB(:,1),plotKnB(:,2),'-','Color',cmap_temp(6,:));
set(axKnB,'LineWidth',2)
axKeB=loglog(plotKeB(:,1),plotKeB(:,2),'-','Color',cmap_temp(8,:));
set(axKeB,'LineWidth',2)
hold off
title('Concentration dependence of reaction completion', 'FontSize', 14, 'FontWeight', 'bold');
savefig(gcf,'Conc-Compl_Graph.fig')

% Plot the energy levels of individual species
figure(5)
LineStyles=cbrewer('div','RdYlBu',N_c);
colormap(LineStyles)
xdata=1:maxEnerSteps;

subplot(1,2,1)
TT_A=zeros(N_c,1);
for g1=1:N_c
    ydata=EnergyScape_A(g1,:);
    TT_A(g1,1)=plot(xdata,ydata,'-.','Color',LineStyles(g1,:),'LineWidth',2);
    hold on
end
ylabel(gca,'DrG0', 'FontAngle', 'italic','FontSize', 12);
xlabel(gca,'Aggregate Size', 'FontAngle', 'italic','FontSize', 12);
title('Energetic Profile of Aggregate Growth, Pathway A', 'FontSize', 14, 'FontWeight', 'bold');
leg=cellfun(@num2str,num2cell(conc_vector*dil),'UniformOutput',false);
legend(TT_A,leg);

subplot(1,2,2)
TT_B=zeros(N_c,1);
for g2=1:N_c
    ydata=EnergyScape_B(g2,:);
    TT_B(g2,1)=plot(xdata,ydata,'Color',LineStyles(g2,:),'LineWidth',2);
    hold on
end
ylabel(gca,'DrG0', 'FontAngle', 'italic','FontSize', 12);
xlabel(gca,'Aggregate Size', 'FontAngle', 'italic','FontSize', 12);
title('Energetic Profile of Aggregate Growth, Pathway A', 'FontSize', 14, 'FontWeight', 'bold');
leg=cellfun(@num2str,num2cell(conc_vector*dil),'UniformOutput',false);
legend(TT_B,leg);




