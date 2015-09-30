% Script designed to draw Figure 4 for the BiPy paper, containing the CD,
% UV and FL-spectra at different concentrations. 

clear all
% close all
clc

% Initialize figure
h_fig=figure('name','Temperature-Dependent Spectra','numbertitle','off');
get(h_fig,'Position')
set(h_fig,'Position',[20 450 1800 420])

% Load input data
N=7;
Filename=cell(N,1);
Filename{1,1}='FitResults-conc1e-06.txt';
Filename{2,1}='FitResults-conc2.5e-06.txt';
Filename{3,1}='FitResults-conc5e-06.txt';
Filename{4,1}='FitResults-conc1e-05.txt';
Filename{5,1}='FitResults-conc2.5e-05.txt';
Filename{6,1}='FitResults-conc5e-05.txt';
Filename{7,1}='FitResults-conc0.0001.txt';

TempArray=cell(N,1);
CDArray=cell(N,1);
UVArray=cell(N,1);
FLArray=cell(N,1);
CONC=[1e-6 2.5e-6 5e-6 1e-5 2.5e-5 5e-5 1e-4];
for f=1:N
    DataArray_Temp=importdata(Filename{f,1});
    
    % Non-normalized
%     TempArray{f,1}=flipud(DataArray_Temp.data(:,1));
%     CDArray{f,1}=flipud(DataArray_Temp.data(:,2))/(32982*CONC(f)*1); % Conversion from mdeg to 1/(M*cm)
%     UVArray{f,1}=flipud(DataArray_Temp.data(:,3))/(CONC(f)*1); % Conversion from AU to 1/(M*cm)
%     if f <= 5
%         FLArray{f,1}=flipud(DataArray_Temp.data(:,4))/(CONC(f)*1); % Conversion from AU to 1/(M*cm)
%     end
%     
    % Normalized
    M=3; % Size of averaging frame for normalization
    TempArray{f,1}=flipud(DataArray_Temp.data(:,1));
    
    if f <= 5
        CDArray_Tempor=flipud(DataArray_Temp.data(:,6));
        [MinCD,MinIndCD]=min(CDArray_Tempor); 
        if MinIndCD <= M
            MinMeanCD=mean(CDArray_Tempor(MinIndCD:MinIndCD+2*M));
        elseif MinIndCD >= length(CDArray_Tempor)-M
            MinMeanCD=mean(CDArray_Tempor(MinIndCD-2*M:MinIndCD));
        else
            MinMeanCD=mean(CDArray_Tempor(MinIndCD-M:MinIndCD+M));
        end
        [MaxCD,MaxIndCD]=max(CDArray_Tempor-MinMeanCD); 
        if MaxIndCD <= M
            MaxMeanCD=mean(CDArray_Tempor(MaxIndCD:MaxIndCD+2*M)-MinMeanCD);
        elseif MaxIndCD >= length(CDArray_Tempor)-M
            MaxMeanCD=mean(CDArray_Tempor(MaxIndCD-2*M:MaxIndCD)-MinMeanCD);
        else
            MaxMeanCD=mean(CDArray_Tempor(MaxIndCD-M:MaxIndCD+M)-MinMeanCD);
        end
        CDArray{f,1}=(CDArray_Tempor-MinMeanCD)/MaxMeanCD;

        UVArray_Tempor=flipud(DataArray_Temp.data(:,9));
        [MinUV,MinIndUV]=min(UVArray_Tempor); 
        if MinIndUV <= M
            MinMeanUV=mean(UVArray_Tempor(MinIndUV:MinIndUV+2*M));
        elseif MinIndUV >= length(UVArray_Tempor)-M
            MinMeanUV=mean(UVArray_Tempor(MinIndUV-2*M:MinIndUV));
        else
            MinMeanUV=mean(UVArray_Tempor(MinIndUV-M:MinIndUV+M));
        end
        [MaxUV,MaxIndUV]=max(UVArray_Tempor-MinMeanUV); 
        if MaxIndUV <= M
            MaxMeanUV=mean(UVArray_Tempor(MaxIndUV:MaxIndUV+2*M)-MinMeanUV);
        elseif MaxIndUV >= length(UVArray_Tempor)-M
            MaxMeanUV=mean(UVArray_Tempor(MaxIndUV-2*M:MaxIndUV)-MinMeanUV);
        else
            MaxMeanUV=mean(UVArray_Tempor(MaxIndUV-M:MaxIndUV+M)-MinMeanUV);
        end
        UVArray{f,1}=(UVArray_Tempor-MinMeanUV)/MaxMeanUV;

        FLArray_Tempor=flipud(DataArray_Temp.data(:,12));
        [MinFL,MinIndFL]=min(FLArray_Tempor); 
        if MinIndFL <= M
            MinMeanFL=mean(FLArray_Tempor(MinIndFL:MinIndFL+2*M));
        elseif MinIndFL >= length(FLArray_Tempor)-M
            MinMeanFL=mean(FLArray_Tempor(MinIndFL-2*M:MinIndFL));
        else
            MinMeanFL=mean(FLArray_Tempor(MinIndFL-M:MinIndFL+M));
        end
        [MaxFL,MaxIndFL]=max(FLArray_Tempor); 
        if MaxIndFL <= M
            MaxMeanFL=mean(FLArray_Tempor(MaxIndFL:MaxIndFL+2*M)-MinMeanFL);
        elseif MaxIndFL >= length(FLArray_Tempor)-M
            MaxMeanFL=mean(FLArray_Tempor(MaxIndFL-2*M:MaxIndFL)-MinMeanFL);
        else
            MaxMeanFL=mean(FLArray_Tempor(MaxIndFL-M:MaxIndFL+M)-MinMeanFL);
        end
        FLArray{f,1}=(FLArray_Tempor-MinMeanFL)/MaxMeanFL;
    else
        CDArray_Tempor=flipud(DataArray_Temp.data(:,5));
        [MinCD,MinIndCD]=min(CDArray_Tempor); 
        if MinIndCD <= M
            MinMeanCD=mean(CDArray_Tempor(MinIndCD:MinIndCD+2*M));
        elseif MinIndCD >= length(CDArray_Tempor)-M
            MinMeanCD=mean(CDArray_Tempor(MinIndCD-2*M:MinIndCD));
        else
            MinMeanCD=mean(CDArray_Tempor(MinIndCD-M:MinIndCD+M));
        end
        [MaxCD,MaxIndCD]=max(CDArray_Tempor-MinMeanCD); 
        if MaxIndCD <= M
            MaxMeanCD=mean(CDArray_Tempor(MaxIndCD:MaxIndCD+2*M)-MinMeanCD);
        elseif MaxIndCD >= length(CDArray_Tempor)-M
            MaxMeanCD=mean(CDArray_Tempor(MaxIndCD-2*M:MaxIndCD)-MinMeanCD);
        else
            MaxMeanCD=mean(CDArray_Tempor(MaxIndCD-M:MaxIndCD+M)-MinMeanCD);
        end
        CDArray{f,1}=(CDArray_Tempor-MinMeanCD)/MaxMeanCD;

        UVArray_Tempor=flipud(DataArray_Temp.data(:,8));
        [MinUV,MinIndUV]=min(UVArray_Tempor); 
        if MinIndUV <= M
            MinMeanUV=mean(UVArray_Tempor(MinIndUV:MinIndUV+2*M));
        elseif MinIndUV >= length(UVArray_Tempor)-M
            MinMeanUV=mean(UVArray_Tempor(MinIndUV-2*M:MinIndUV));
        else
            MinMeanUV=mean(UVArray_Tempor(MinIndUV-M:MinIndUV+M));
        end
        [MaxUV,MaxIndUV]=max(UVArray_Tempor-MinMeanUV); 
        if MaxIndUV <= M
            MaxMeanUV=mean(UVArray_Tempor(MaxIndUV:MaxIndUV+2*M)-MinMeanUV);
        elseif MaxIndUV >= length(UVArray_Tempor)-M
            MaxMeanUV=mean(UVArray_Tempor(MaxIndUV-2*M:MaxIndUV)-MinMeanUV);
        else
            MaxMeanUV=mean(UVArray_Tempor(MaxIndUV-M:MaxIndUV+M)-MinMeanUV);
        end
        UVArray{f,1}=(UVArray_Tempor-MinMeanUV)/MaxMeanUV;
    end
end

% Define the color table using cbrewer. 
CT=cbrewer('div','RdYlBu',7);
% Color_Light=CT(3,:);
% Color_Dark=CT(8,:);
CT2=interp1(0:6,CT,0:0.05:6);
colormap(CT2);

% Define subplot placement
Pos_CD=[0.0800 0.1300 0.2134 0.8150];
Pos_UV=[0.3608 0.1300 0.2134 0.8150];
Pos_FL=[0.6416 0.1300 0.2134 0.8150];

%% CD
% Create plot
h_sCD=subplot(1,3,1);
get(h_sCD,'Position')
set(h_sCD,'Position',Pos_CD)
axis([260 380 -0.2 1.2])
hold on
h_CD=zeros(N,1);
for j2=1:N
    h_CD(j2)=plot(TempArray{j2,1},CDArray{j2,1},'Color',CT(j2,:),'LineWidth',1.5);
end

xlabel('Temperature (K)','FontSize',14)
ylabel('Normalized Circular Dichroism','FontSize',14)
set(gca,'FontSize',12)
% h_legCD=legend(h_CD(I_select),{'268 K','303 K','353 K'});
% get(h_legCD,'Position')
% set(h_legCD,'Position',[0.2894 0.7223 0.02 0.06])
% legend('boxoff')
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
get(h_sUV,'Position')
set(h_sUV,'Position',Pos_UV)
axis([260 380 -0.2 1.2])
hold on
h_UV=zeros(N,1);
for j2=1:N
    h_UV(j2)=plot(TempArray{j2,1},UVArray{j2,1},'Color',CT(j2,:),'LineWidth',1.5);
end

xlabel('Temperature (K)','FontSize',14)
ylabel('Normalized Absorption','FontSize',14)
set(gca,'FontSize',12)
% h_legUV=legend(h_UV(I_select),{'268 K','303 K','353 K'});
% get(h_legUV,'Position')
% set(h_legUV,'Position',[0.5705 0.7223 0.02 0.06])
% legend('boxoff')
% set_legtitleUV=get(h_legUV,'title');
% set(set_legtitleUV,'string','Temperature')

%% FL
% Create plot
h_sFL=subplot(1,3,3);
get(h_sFL,'Position')
set(h_sFL,'Position',Pos_FL)
axis([260 380 -0.2 1.2])
hold on
h_FL=zeros(5,1);
for j2=1:5
    h_FL(j2)=plot(TempArray{j2,1},FLArray{j2,1},'Color',CT(j2,:),'LineWidth',1.5);
end

xlabel('Temperature (K)','FontSize',14)
ylabel('Normalized Fluorescence Intensity','FontSize',14)
set(gca,'FontSize',12)
% h_legFL=legend(h_FL(I_select),{'268 K','303 K','353 K'});
% get(h_legFL,'Position')
% set(h_legFL,'Position',[0.8910 0.7223 0.02 0.06])
% legend('boxoff')
% set_legtitleFL=get(h_legFL,'title');
% set(set_legtitleFL,'string','Temperature')

%% Create colorbar
set(gca, 'CLim', [min(log10(CONC)) max(log10(CONC))]);

% colorbar
% h_colbar=colorbar('FontSize',12,'YTick',log10(CONC),'YTickLabel',CONC);
% h_colbar=colorbar([0.92 0.15 0.02 0.7],'FontSize',12,'YTick',log10(logspace(-6,-4,3)),'YTickLabel',logspace(-6,-4,3));
h_colbar=colorbar('FontSize',12,'YTick',log10(logspace(-6,-4,3)),'YTickLabel',{'1.0e-06','1.0e-05','1.0e-04'},'Position',[0.8700 0.1310 0.0148 0.8143]);
get(h_colbar,'Position')

set(get(h_colbar,'ylabel'),'String', 'Concentration (M)');
set(get(h_colbar,'ylabel'),'FontAngle', 'italic');
% set(get(h_colbar,'ylabel'),'FontSize', 12);

%% Printing the image
% Print image as .eps
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 1 16 4]);
% set(gcf, 'PaperPosition', [2 1 9 2.25]);

% CurrDom=cd;
% cd('D:\1 Onderzoek\Papers\BiPy Paper\Figure 3')
print(h_fig,'-depsc','-r300','-tiff','Figure 4b')
% cd(CurrDom)