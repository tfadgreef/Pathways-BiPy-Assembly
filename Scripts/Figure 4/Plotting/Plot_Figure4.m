% Script designed to draw Figure 4 for the BiPy paper, containing the 
% temperature-dependent fits in CD-,UV- and FL-channels. 

clear all
% close all
clc

% Load datafile and extract required traces (watch column indices with
% higher concentrations, no fluorescence channel)
Datafile=importdata('FitResults-conc1e-05.txt');
Temp=flipud(Datafile.data(:,1));
CD_Data=flipud(Datafile.data(:,2));
UV_Data=flipud(Datafile.data(:,3));
FL_Data=flipud(Datafile.data(:,4));
CD_Fit=flipud(Datafile.data(:,6));
UV_Fit=flipud(Datafile.data(:,9));
FL_Fit=flipud(Datafile.data(:,12));

% Initialize figure
h_fig=figure('name','Thermodynamic Fit','numbertitle','off');
get(h_fig,'Position')
set(h_fig,'Position',[20 450 1800 420])

% Define the color table using cbrewer. 
CT_Grey=cbrewer('seq','Greys',9);
CT_Blue=cbrewer('seq','Blues',9);
Color_Grey=CT_Grey(5,:);
Color_Blue=CT_Blue(8,:);

% Define subplot placement
Pos_CD=[0.1300 0.1100 0.2000 0.2000];
Pos_UV=[0.4108 0.1100 0.2000 0.2000];
Pos_FL=[1.6916 0.1100 0.2000 0.2000];

%% CD
% Create plot
h_sCD=subplot(1,3,1);
% get(h_sCD,'Position')
% set(h_sCD,'Position',Pos_CD)
% axis([250 400 -15 45])
hold on
h_CD_Data=plot(Temp,CD_Data,'Color',Color_Grey,'LineWidth',1.5);
h_CD_Fit=plot(Temp,CD_Fit,'Color',Color_Blue,'LineWidth',1.5);

xlabel('Temperature (K)','FontSize',14)
ylabel('CD-signal (mdeg)','FontSize',14)
h_legCD=legend([h_CD_Data h_CD_Fit],{'Data','Fit'},'FontSize',12);
set(gca,'FontSize',12)
% get(h_legCD,'Position')
% set(h_legCD,'Position',[0.2894 0.7223 0.02 0.06])
legend('boxoff')
% set_legtitleCD=get(h_legCD,'title');
% set(set_legtitleCD,'string','Temperature')

% Plot with patchline

% for j2=1:size(Y_CD,2)
%     highlight_check=find(j2==I_select);
%     if isempty(highlight_check)
%         h_CD=patchline(X_CD,Y_CD(:,j2),'edgecolor',Color_Light,'linewidth',1.5,'edgealpha',0.4);
%     end
% end
% 
% for j2=1:size(Y_CD,2)
%     highlight_check=find(j2==I_select);
%     if ~isempty(highlight_check)
%         h_CD=patchline(X_CD,Y_CD(:,j2),'edgecolor',Color_Dark,'linewidth',1.5,'edgealpha',1);
%     end
% end

% Plain plot

% h_CD=plot(X_CD,Y_CD);
% set(h_CD, {'color'}, num2cell(CT_CD,2), 'LineWidth',1.5)

%% UV
% Create plot
h_sUV=subplot(1,3,2);
% get(h_sUV,'Position')
% set(h_sUV,'Position',Pos_UV)
% axis([300 410 0 0.45])
hold on
h_UV_Data=plot(Temp,UV_Data,'Color',Color_Grey,'LineWidth',1.5);
h_UV_Fit=plot(Temp,UV_Fit,'Color',Color_Blue,'LineWidth',1.5);

xlabel('Temperature (K)','FontSize',14)
ylabel('Absorbance (-)','FontSize',14)
h_legUV=legend([h_UV_Data h_UV_Fit],{'Data','Fit'},'FontSize',12);
set(gca,'FontSize',12)
% get(h_legUV,'Position')
set(h_legUV,'Position',[0.4184 0.8067 0.0472 0.1000])
legend('boxoff')
% set_legtitleUV=get(h_legUV,'title');
% set(set_legtitleUV,'string','Temperature')

%% FL
% Create plot
h_sFL=subplot(1,3,3);
% get(h_sFL,'Position')
% set(h_sFL,'Position',Pos_FL)
% axis([200 420 -0.05 0.50])
hold on
h_FL_Data=plot(Temp,FL_Data,'Color',Color_Grey,'LineWidth',1.5);
h_FL_Fit=plot(Temp,FL_Fit,'Color',Color_Blue,'LineWidth',1.5);

xlabel('Temperature (K)','FontSize',14)
ylabel('Fluorescence Intensity (a.u.)','FontSize',14)
h_legFL=legend([h_FL_Data h_FL_Fit],{'Data','Fit'},'FontSize',12);
set(gca,'FontSize',12)
% get(h_legFL,'Position')
% set(h_legFL,'Position',[0.8910 0.7223 0.02 0.06])
legend('boxoff')
% set_legtitleFL=get(h_legFL,'title');
% set(set_legtitleFL,'string','Temperature')

%% Printing the image
% Print image as .eps
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 1 16 4]);
% set(gcf, 'PaperPosition', [2 1 9 2.25]);

% CurrDom=cd;
% cd('D:\1 Onderzoek\Papers\BiPy Paper\Figure 3')
print(h_fig,'-depsc','-r300','-tiff','Figure 4')
% cd(CurrDom)