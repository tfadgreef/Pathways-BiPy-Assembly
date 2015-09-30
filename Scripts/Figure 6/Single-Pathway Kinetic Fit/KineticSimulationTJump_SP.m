% KineticSimulationTJump_SP
% This script simulates a T-Jump experiment using coupled ODE-equations to
% describe the rate of change in the concentration of individual species.
% Here, a single-pathway model is used, in which aggregates change size by
% monomer transfer, as described by for example Powers&Powers or Zhao&Moore. 
% The system of ODEs is solved using PPODESUITE, requiring kinetic
% parameters as input and yielding the time-dependent concentration
% changes in the system as output. Optionally, thermodynamic parameters can
% be used as constraints. This script is specifically designed to simulate
% the behavior of compound BiPy-1.

%% Build the model in Fortran using PPODESUITE
PPODE_translate('gPM', 'AnaJac', 1);
PPODE_build('gPM.F', 'gPMPP', 'Solver', 'AUTO', 'MaxSteps', 50000,...
   'InputNNZ', 0, 'Debug', 0);

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
EnergyScape=zeros(N_c,maxEnerSteps);

% Cycle over different concentrations
for i=1:N_c
    ctot = conc_vector(i);
    
    %% Set the parameters
    % Thermodynamic Parameters (from thermodynamic fit, n=8, j=129)
    dHn     = -9.9411e4;
    dSn     = -2.1799e2;
    dHe     = -2.4647e5;
    dSe     = -7.1048e2;

    Tfin    = 20 + 273;

    R       = 8.3144621;

    % Simulation properties
    np=8;
    nrodes=1000;

    % Molecular properties
    Kn=exp(-(dHn-Tfin*dSn)/(R*Tfin));
    Ke=exp(-(dHe-Tfin*dSe)/(R*Tfin));
    sigma=Kn/Ke;

    a=1; % ratio of forward rate constants of nucleation and elongation
    kef=1e8; % forward rate constant of elongation
    knf=a*kef; % forward rate constant of nucleation, determined by a and kef

    keb=kef/Ke; % backward rate constant of elongation
    knb=knf/Kn; % backward rate constant of nucleation

    par=[knf;knb;kef;keb];

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
        Kn_init=exp(-(dHn-Tinit*dSn)/(R*Tinit));
        Ke_init=exp(-(dHe-Tinit*dSe)/(R*Tinit));
        sigma_init  = Kn_init/Ke_init;

        %% Using Goldstein Stryer to calculate initial species
        x = GoldsteinStryer(ctot, Ke_init, sigma_init, np);

        % Get distribution and de-normalize
        y0 = monoToDistribution(x, np, nrodes, sigma_init) ./ Ke_init;

        t = logspace(-5, 5, 2000);

        % Calculate Energy Diagram
        for m=2:maxEnerSteps
            if m <= np
                EnergyScape(i,m) = EnergyScape(i,m-1) - R*Tfin*(log(Kn)+log(ctot*dil));
            elseif m > np
                EnergyScape(i,m) = EnergyScape(i,m-1) - R*Tfin*(log(Ke)+log(ctot*dil));
            end
        end

        %% Perform Kinetic Simulation
        % Apply the dilution
        y0 = y0 .* dil;

        tic;
        [t, y] = gPMPP(nrodes+2, 1e-26, 1e-14, t, [par' np nrodes], y0);

        % Occasionally, optimization of the convergence tolerances is
        % needed to achieve an accurate solution in a reasonable timeframe.
        if max(max(y)) == 0 || max(max(isnan(y))) == 1
            t = logspace(-5, 5, 2000);
            [t, y] = gPMPP(nrodes+2, 1e-25, 1e-13, t, [par' np nrodes], y0);
            if max(max(y)) == 0 || max(max(isnan(y))) == 1
                t = logspace(-5, 5, 2000);
                [t, y] = gPMPP(nrodes+2, 1e-24, 1e-13, t, [par' np nrodes], y0);
                if max(max(y)) == 0 || max(max(isnan(y))) == 1
                    t = logspace(-5, 5, 2000);
                    [t, y] = gPMPP(nrodes+2, 1e-22, 1e-12, t, [par' np nrodes], y0);
                    if max(max(y)) == 0 || max(max(isnan(y))) == 1
                        t = logspace(-5, 5, 2000);
                        [t, y] = gPMPP(nrodes+2, 1e-20, 1e-10, t, [par' np nrodes], y0);
                        if max(max(y)) == 0 || max(max(isnan(y))) == 1
                            t = logspace(-5, 5, 2000);
                            [t, y] = gPMPP(nrodes+2, 1e-18, 1e-8, t, [par' np nrodes], y0);
                            if max(max(y)) == 0 || max(max(isnan(y))) == 1
                                disp('Numerical integration of this experiment did not converge.')
                            end
                            disp('Numerical integration of this experiment did not converge.')
                        end
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
    colormap(interp1(1:9,cbrewer('seq', 'GnBu', 9),1:0.1:9));

    % Calculate and plot the molecular distributions over time
    for j=1:l
        Tfin = 20 + Ts(j);

        t = tdata{j};
        y = ydata{j};

        %% Filled contour plot
        figure(1);
        %set(gcf,'WindowStyle','docked');
        pp = floor((j-1)/columns)*(columns) + mod(j-1, columns) + 1;
        subplot(ceil(l/(columns)), columns, pp);
        tnphinucloglogcontourf(t, y, ctot*dil, nrodes, np, contours, sprintf('T-Jump %d^{\\circ}C -> 20^{\\circ}C', Tfin), 0);

        %% Fractions Plot
        figure(2);
        %set(gcf,'WindowStyle','docked');
        subplot(ceil(l/columns), columns, j);
        % Calculate fractions
        [t90,t50]=tfracphiloglogplot(t, y, ctot*dil, np, nrodes, sprintf('T-Jump %d^{\\circ}C -> 20^{\\circ}C', Tfin));
        %set(gca, 'XScale', 'Linear');
        %set(gca, 'YScale', 'Linear');
        %xlim([0 15]);
        t90_vector(i,j)=t90;
        t50_vector(i,j)=t50;
        if (j == 1)
            legend({'monomer', 'pre-nucleus', 'fibres'});
        end
    end

    figure(1);
    cb = colorbar([0.94 0.15 0.02 0.7], 'FontSize',12,...
        'YTick',log10(contours(1:2:end)),'YTickLabel',contours(1:2:end));
    set(get(cb,'ylabel'),'String', '\phi (-)');
    set(get(cb,'ylabel'),'FontAngle', 'italic');
    set(get(cb,'ylabel'),'FontSize', 12);

    bench

    %% Save images in correct folder
    mkdir(strcat('Initial_Concentration_',num2str(ctot)));
    cd(strcat(CurrentDomain,'/Initial_Concentration_',num2str(ctot)));
    h1=figure(1);
    savefig(h1,strcat('Figure1_conc',num2str(ctot*dil),'.fig'))
    h2=figure(2);
    savefig(h2,strcat('Figure2_conc',num2str(ctot*dil),'.fig'))
    cd(CurrentDomain);
end

save('t90_vector.txt','t90_vector','-ASCII')
save('t50_vector.txt','t50_vector','-ASCII')

% Select the T-jump initial temperature to display, and plot concentration
% versus t-90 and t-50, and indicate 1/Kn to compare.
plotKn=(1/Kn)*ones(4,1); plotKn_ytemp=logspace(-10,10,4)';
plotKn=[plotKn plotKn_ytemp];
plotKe=(1/Ke)*ones(4,1); plotKe_ytemp=logspace(-10,10,4)';
plotKe=[plotKe plotKe_ytemp];

% Plot times to completion
tjump_index=l-1;
figure(3);
cmap_temp=cbrewer('qual', 'Paired', 12);
[ax,p1,p2]=plotyy(conc_vector*dil,t90_vector(:,tjump_index),conc_vector*dil,t50_vector(:,tjump_index),'loglog');
set(ax(1), 'FontSize', 12); set(ax(2), 'FontSize', 12);
ylabel(ax(1),'t-90 (s)', 'FontAngle', 'italic','FontSize', 12);
ylabel(ax(2),'t-50 (s)', 'FontAngle', 'italic','FontSize', 12);
xlabel(ax(2),'Concentration (M)', 'FontAngle', 'italic','FontSize', 12);
YL=ylim(ax(1));
ylim(ax(2),YL);
% xlim(ax(1),[1e-7 1e-3]);xlim(ax(2),[1e-7 1e-3]);
set(ax,'LineWidth',2)
set(ax(1),'ycolor',cmap_temp(1,:))
set(ax(2),'ycolor',cmap_temp(2,:))
set(p1,'Color',cmap_temp(1,:))
set(p1,'LineWidth',2)
set(p2,'Color',cmap_temp(2,:))
set(p2,'LineWidth',2)
hold on
axKn=loglog(plotKn(:,1),plotKn(:,2),'-','Color',cmap_temp(6,:));
set(axKn,'LineWidth',2)
axKe=loglog(plotKe(:,1),plotKe(:,2),'-','Color',cmap_temp(8,:));
set(axKe,'LineWidth',2)
hold off
title('Concentration dependence of reaction completion', 'FontSize', 14, 'FontWeight', 'bold');
savefig(gcf,'Conc-Compl_Graph.fig')

% Plot the energy levels of individual species
figure(4)
LineStyles=cbrewer('div', 'RdYlBu', size(EnergyScape,1));
colormap(LineStyles)
xdata=1:maxEnerSteps;
TT=zeros(size(EnergyScape,1),1);
for g=1:size(EnergyScape,1)
    ydata=EnergyScape(g,:);
    TT(g,1)=plot(xdata,ydata,'Color',LineStyles(g,:),'LineWidth',2);
    hold on
end
ylabel(gca,'DrG0', 'FontAngle', 'italic','FontSize', 12);
xlabel(gca,'Aggregate Size', 'FontAngle', 'italic','FontSize', 12);
title('Energetic Profile of Aggregate Growth', 'FontSize', 14, 'FontWeight', 'bold');
leg=cellfun(@num2str,num2cell(conc_vector*dil),'UniformOutput',false);
legend(TT,leg);
savefig(gcf,'EnergyScape.fig')