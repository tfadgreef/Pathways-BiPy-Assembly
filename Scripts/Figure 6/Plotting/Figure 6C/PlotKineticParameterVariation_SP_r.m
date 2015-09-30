% Script designed to draw Figure 6C for the BiPy paper, containing the 
% kinetic simulations investigating the variation of parameter r.

clear all
% close all
clc

% Load simulated datafiles and extract required traces at appropriate
% concentrations (i.e. in the same range as the experimental data). The
% columns in the model output file represent different starting T-jump
% temperatures, rows represent different concentrations. 
XData_Temp=logspace(-7,-3,20)/3.5; XData=XData_Temp(6:end);
t90_var_a_temp=load('t90_vector_a_10e-3.txt'); t90_var_a_1=t90_var_a_temp(6:end,5);
t90_var_a_temp=load('t90_vector_a_19e-3.txt'); t90_var_a_2=t90_var_a_temp(6:end,5);
t90_var_a_temp=load('t90_vector_a_37e-3.txt'); t90_var_a_3=t90_var_a_temp(6:end,5);
t90_var_a_temp=load('t90_vector_a_72e-3.txt'); t90_var_a_4=t90_var_a_temp(6:end,5);
t90_var_a_temp=load('t90_vector_a_14e-2.txt'); t90_var_a_5=t90_var_a_temp(6:end,5);
t90_var_a_temp=load('t90_vector_a_27e-2.txt'); t90_var_a_6=t90_var_a_temp(6:end,5);
t90_var_a_temp=load('t90_vector_a_52e-2.txt'); t90_var_a_7=t90_var_a_temp(6:end,5);
t90_var_a_temp=load('t90_vector_a_10e-1.txt'); t90_var_a_8=t90_var_a_temp(6:end,5);

% Initialize figure
h_fig=figure('name','Variation Parameter a Single-Pathway Fit','numbertitle','off');

% Define the color table using cbrewer. 
CT_Grey=cbrewer('seq','Greys',9);
CT_Blue=cbrewer('seq','Blues',9);
CT_Red=cbrewer('seq','Reds',9);
Light_Grey=CT_Grey(5,:); Dark_Grey=CT_Grey(8,:);
Light_Blue=CT_Blue(5,:); Dark_Blue=CT_Blue(8,:);
Color_Red=CT_Red(7,:);

%% Create plot

h_t90_1=loglog(XData,t90_var_a_1,'Color',Dark_Blue,'LineWidth',1.5,'LineStyle','-');
hold on
h_t90_2=loglog(XData,t90_var_a_2,'Color',Light_Blue,'LineWidth',1.5,'LineStyle','-');
h_t90_3=loglog(XData,t90_var_a_3,'Color',Light_Blue,'LineWidth',1.5,'LineStyle','-');
h_t90_4=loglog(XData,t90_var_a_4,'Color',Light_Blue,'LineWidth',1.5,'LineStyle','-');
h_t90_5=loglog(XData,t90_var_a_5,'Color',Light_Blue,'LineWidth',1.5,'LineStyle','-');
h_t90_6=loglog(XData,t90_var_a_6,'Color',Light_Blue,'LineWidth',1.5,'LineStyle','-');
h_t90_7=loglog(XData,t90_var_a_7,'Color',Light_Blue,'LineWidth',1.5,'LineStyle','-');
h_t90_8=loglog(XData,t90_var_a_8,'Color',Dark_Blue,'LineWidth',1.5,'LineStyle','-');

set(gca,'XTickLabel','')
set(gca,'YTickLabel','')
set(gca,'XTick',[])
set(gca,'YTick',[])

axis([3e-7 2e-4 2e0 2e2])

%% Printing the image
print(h_fig,'-depsc','-r300','-tiff','KineticSimVar_r')