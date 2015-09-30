% Script designed to draw Figure 6A for the BiPy paper, containing the 
% optimized single-pathway kinetic simulation and experimental data points 
% for a T-Jump experiment.

clear all
% close all
clc

% Load simulated datafile and extract required traces at appropriate
% concentrations (i.e. in the same range as the experimental data). The
% columns in the model output file represent different starting T-jump
% temperatures, rows represent different concentrations. 
XData_Temp=logspace(-7,-3,20)/3.5; XData=XData_Temp(6:end);
t90_fit1_temp=load('t90_vector_1.txt'); t90_fit1=t90_fit1_temp(6:end,5);
t50_fit1_temp=load('t50_vector_1.txt'); t50_fit1=t50_fit1_temp(6:end,5);

conc_sol_vec=[6.80e-7 1.40e-6 2.70e-6 5.40e-6 1.09e-5 2.19e-5 4.38e-5 8.75e-5 1.75e-4 3.5e-4];
dil=1/3.5;
XData_exp=dil*conc_sol_vec;

% Load experimental datafiles
t90_exp=load('t90_vec_exp.txt');
t50_exp=load('t50_vec_exp.txt');

% Initialize figure
h_fig=figure('name','Kinetic Single-Pathway Fit','numbertitle','off');

% Define the color table using cbrewer. 
CT_Grey=cbrewer('seq','Greys',9);
CT_Blue=cbrewer('seq','Blues',9);
CT_Red=cbrewer('seq','Reds',9);
Light_Grey=CT_Grey(5,:); Dark_Grey=CT_Grey(8,:);
Light_Blue=CT_Blue(5,:); Dark_Blue=CT_Blue(8,:);
Color_Red=CT_Red(7,:);

%% Create plot

h_t90_1=loglog(XData,t90_fit1,'Color',Dark_Blue,'LineWidth',1.5,'LineStyle','-');
hold on
% h_t50_1=loglog(XData,t50_fit1,'Color',Light_Blue,'LineWidth',1.5,'LineStyle','-');
h_t90_data=loglog(XData_exp,t90_exp,'o','MarkerEdgeColor',Dark_Blue,'LineWidth',1.5);
% h_t50_data=loglog(XData_exp,t50_exp,'o','MarkerEdgeColor',Light_Blue);

xlabel('Concentration (M)','FontSize',14) 
ylabel('Time to 90% completion','FontSize',14) 
h_legCD=legend([h_t90_1 h_t90_data],{'Simulation t-90','Experimental t-90'},'FontSize',12);
set(gca,'FontSize',12)
legend('boxoff')
axis([3e-7 2e-4 2e0 2e2])

%% Printing the image
print(h_fig,'-depsc','-r300','-tiff','KineticSim1Par')
