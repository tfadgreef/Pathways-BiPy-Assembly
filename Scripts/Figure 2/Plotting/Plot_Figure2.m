% Script designed to draw Figure 2 for the BiPy paper, containing the CD,
% UV and FL-spectra at different temperatures. 

clear all
close all
clc

% Initialize figure
h_fig=figure('name','Temperature-Dependent Spectra','numbertitle','off');
get(h_fig,'Position')
set(h_fig,'Position',[20 450 1800 420])

% Further input data
Temp_Vec=[80 75 70 65 60 55 50 45 40 38 36 34 32 30 28 26 24 22 20 18 16 14 12 10 5 0 -5];
Temp_Vec_inv=fliplr(Temp_Vec);

% Select the temperatures to be highlighted (ie most characteristic for a
% particular state). The max number of highlights is currently 8, limited
% by the LineStyle cycles.
T_select=[-5 30 80];
nT_sel=length(T_select);
I_select=zeros(size(T_select));
for i=1:nT_sel
    I_select(i)=find(Temp_Vec_inv==T_select(i));
end
Linespec_Vec={'-' '--' ':' '-.'};

% Define the color table using cbrewer. 
CT=cbrewer('seq','Greys',9);
Color_Light=CT(3,:);
Color_Dark=CT(8,:);

% Define subplot placement
Pos_CD=[0.1300 0.1100 0.2000 0.2000];
Pos_UV=[0.4108 0.1100 0.2000 0.2000];
Pos_FL=[1.6916 0.1100 0.2000 0.2000];

%% CD
% Load dataset
CD_Data=load('VTVW_DZ001_CD_C1e-5_MatLab.txt');
X_CD=CD_Data(:,1);
Y_CD=CD_Data(:,end:-1:2);
CD_Data_inv=[X_CD Y_CD];

% Set colortable to display highlights
CT_CD=repmat(Color_Light,length(Temp_Vec),1);
for j=1:nT_sel
    CT_CD(I_select(j),:)=Color_Dark;
end

% Create plot
h_sCD=subplot(1,3,1);
% get(h_sCD,'Position')
% set(h_sCD,'Position',Pos_CD)
axis([250 400 -15 45])
hold on
h_CD=zeros(size(Y_CD,2),1);
for j2=1:size(Y_CD,2)
    highlight_check=find(j2==I_select);
    if isempty(highlight_check)
        h_CD(j2)=plot(X_CD,Y_CD(:,j2),'Color',Color_Light,'LineWidth',1.5);
    end
end

for j2=1:size(Y_CD,2)
    highlight_check=find(j2==I_select);
    if ~isempty(highlight_check)
        h_CD(j2)=plot(X_CD,Y_CD(:,j2),'Color',Color_Dark,'LineWidth',1.5,'LineStyle',Linespec_Vec{highlight_check});
    end
end

xlabel('Wavelength (nm)')
ylabel('CD-signal (mdeg)')
h_legCD=legend(h_CD(I_select),{'268 K','303 K','353 K'});
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
% Load dataset
UV_Data=load('VTVW_DZ001_UV_C1e-5_MatLab.txt');
X_UV=UV_Data(:,1);
Y_UV=UV_Data(:,end:-1:2);
UV_Data_inv=[X_UV Y_UV];

% Set colortable to display highlights
CT_UV=repmat(Color_Light,length(Temp_Vec),1);
for j=1:nT_sel
    CT_UV(I_select(j),:)=Color_Dark;
end

% Create plot
h_sUV=subplot(1,3,2);
% get(h_sUV,'Position')
% set(h_sUV,'Position',Pos_UV)
axis([300 410 0 0.45])
hold on
h_UV=zeros(size(Y_UV,2),1);
for j2=1:size(Y_UV,2)
    highlight_check=find(j2==I_select);
    if isempty(highlight_check)
        h_UV(j2)=plot(X_UV,Y_UV(:,j2),'Color',Color_Light,'LineWidth',1.5);
    end
end

for j2=1:size(Y_UV,2)
    highlight_check=find(j2==I_select);
    if ~isempty(highlight_check)
        h_UV(j2)=plot(X_UV,Y_UV(:,j2),'Color',Color_Dark,'LineWidth',1.5,'LineStyle',Linespec_Vec{highlight_check});
    end
end

xlabel('Wavelength (nm)')
ylabel('Absorbance (-)')
h_legUV=legend(h_UV(I_select),{'268 K','303 K','353 K'});
% get(h_legUV,'Position')
% set(h_legUV,'Position',[0.5705 0.7223 0.02 0.06])
legend('boxoff')
% set_legtitleUV=get(h_legUV,'title');
% set(set_legtitleUV,'string','Temperature')

%% FL
% Load dataset
FL_Data=load('VTVW_DZ001_FL_C1e-5_MatLab.txt');
X_FL=FL_Data(:,1);
Y_FL=FL_Data(:,end:-1:2);
FL_Data_inv=[X_FL Y_FL];

% Set colortable to display highlights
CT_FL=repmat(Color_Light,length(Temp_Vec),1);
for j=1:nT_sel
    CT_FL(I_select(j),:)=Color_Dark;
end

% Create plot
h_sFL=subplot(1,3,3);
% get(h_sFL,'Position')
% set(h_sFL,'Position',Pos_FL)
axis([200 420 -0.05 0.50])
hold on
h_FL=zeros(size(Y_FL,2),1);
for j2=1:size(Y_FL,2)
    highlight_check=find(j2==I_select);
    if isempty(highlight_check)
        h_FL(j2)=plot(X_FL,Y_FL(:,j2),'Color',Color_Light,'LineWidth',1.5);
    end
end

for j2=1:size(Y_FL,2)
    highlight_check=find(j2==I_select);
    if ~isempty(highlight_check)
        h_FL(j2)=plot(X_FL,Y_FL(:,j2),'Color',Color_Dark,'LineWidth',1.5,'LineStyle',Linespec_Vec{highlight_check});
    end
end

xlabel('Wavelength (nm)')
ylabel('Fluorescence Intensity (a.u.)')
h_legFL=legend(h_FL(I_select),{'268 K','303 K','353 K'});
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

CurrDom=cd;
% cd('D:\1 Onderzoek\Papers\BiPy Paper\Figure 2')
print(h_fig,'-depsc','-r300','-tiff','Figure 2')
% cd(CurrDom)