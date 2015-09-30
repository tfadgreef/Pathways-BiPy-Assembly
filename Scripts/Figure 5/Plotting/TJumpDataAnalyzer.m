% TJumpDataAnalyzer
% This script loads and averages T-Jump datafiles, and extracts the t-90
% and t-50. Additionally, it plots the time-dependent traces and the
% concentration-dependent completion times. 

% clear all
close all
clc

% Enter experimental parameters
conc_sol_vec=[6.80e-7 1.40e-6 2.70e-6 5.40e-6 1.09e-5 2.19e-5 4.38e-5 8.75e-5 1.75e-4 3.5e-4];
dil=1/3.5;
conc_vec=dil*conc_sol_vec;

% Select the traces for particular concentrations
trace_cell=cell(length(conc_vec),1);

trace_cell{1,1}=[99:104]';
trace_cell{2,1}=[113:118]';
trace_cell{3,1}=[127:132]';
trace_cell{4,1}=[141:146]';
trace_cell{5,1}=[7:11]';
trace_cell{6,1}=[22:27]';
trace_cell{7,1}=[36:41]';
trace_cell{8,1}=[50:55]';
trace_cell{9,1}=[64:69]';
trace_cell{10,1}=[78:83]'; %#ok<*NBRAK>

% Initiate storage structures
kin_data_plot=cell(length(conc_vec),1);
t90_vector=zeros(length(conc_vec),1);
t50_vector=zeros(length(conc_vec),1);
kin_in_vec=zeros(length(conc_vec),1);
kin_fin_vec=zeros(length(conc_vec),1);

% Process the experimental files
for i=1:size(trace_cell,1)
    % Average traces for particular measurement
    kin_data_mat=[];
    for j=1:size(trace_cell{i,1},1)
        kin_data_temp=importdata(strcat('bipybufl_ch1_',sprintf('%03.0f',trace_cell{i,1}(j,1)),'.bka'),'\t',19);
        kin_data_mat=[kin_data_mat kin_data_temp.data(:,2)];
        kin_data_tvec=kin_data_temp.data(:,1);
    end
    kin_data_avg=mean(kin_data_mat,2);
    kin_data_plot{i,1}=[kin_data_tvec kin_data_avg];
    
    % Smooth average dataset
    if i == 1
        kin_data_smooth=csaps(kin_data_tvec,kin_data_avg,0.7,kin_data_tvec);
    else
        kin_data_smooth=RunAvg(kin_data_tvec,kin_data_avg,10);
    end
    kin_initial_value=max(kin_data_smooth);
    kin_final_value=mean(kin_data_smooth(end-200:end));

    % Extract t50 and t90
    a90=0;h90=0;
    a50=0;h50=0;
    nT=length(kin_data_smooth);
    for k=1:nT
        if 9*abs(kin_data_smooth(nT+1-k)-kin_final_value) > abs(kin_initial_value-kin_data_smooth(nT+1-k)) && a90 == 0
            a90=1;
            t90=kin_data_tvec(nT+1-k);
            h90=kin_data_smooth(nT+1-k);
        end
        if abs(kin_data_smooth(nT+1-k)-kin_final_value) > abs(kin_initial_value-kin_data_smooth(nT+1-k)) && a50 == 0
            a50=1;
            t50=kin_data_tvec(nT+1-k);
            h50=kin_data_smooth(nT+1-k);
        end
    end
    t90_vector(i,1)=t90;
    t50_vector(i,1)=t50;
    
    % Visualize t50 and t90 on averaged trace
    k_in_plot=[kin_data_tvec(1) kin_initial_value;kin_data_tvec(end) kin_initial_value];
    k_fin_plot=[kin_data_tvec(1) kin_final_value;kin_data_tvec(end) kin_final_value];
    figure(3)
    plot(kin_data_tvec,kin_data_avg,'b-',kin_data_tvec,kin_data_smooth,'r-',...
        k_in_plot(:,1),k_in_plot(:,2),'k-',k_fin_plot(:,1),k_fin_plot(:,2),'k-',...
        t90,h90,'ro',t50,h50,'yo')
    kin_in_vec(i)=kin_initial_value;
    kin_fin_vec(i)=kin_final_value;
end

% Plot kinetic traces
CT=cbrewer('div','RdYlBu',10);
CT2=interp1(0:9,CT,0:0.05:9);

h_kin=zeros(size(trace_cell,1),1);
h_fig=figure(1);
hold all
for i2=1:size(trace_cell,1)
    h_kin(i2)=plot(kin_data_plot{i2,1}(:,1),(kin_data_plot{i2,1}(:,2)-kin_fin_vec(i2))/(kin_in_vec(i2)-kin_fin_vec(i2)),'Color',CT(i2,:),'LineWidth',1.5);
end
axis([0 50 -0.2 1.2])
xlabel('Time (s)','FontSize',14)
ylabel('Fluorescence Intensity','FontSize',14)
set(gca,'FontSize',12)
colormap(CT2);
set(gca, 'CLim', [min(log10(conc_vec)) max(log10(conc_vec))]);
h_colbar=colorbar('FontSize',12,'YTick',log10(logspace(-7,-4,4)),'YTickLabel',{'1.0e-07','1.0e-06','1.0e-05','1.0e-04'});

set(get(h_colbar,'ylabel'),'String', 'Concentration (M)');
set(get(h_colbar,'ylabel'),'FontAngle', 'italic');
print(h_fig,'-depsc','-r300','-tiff','KinTraces')

% Plot concentration-dependent completion times
h_fig2=figure(2);
loglog(conc_vec,t90_vector,'o',conc_vec,t50_vector,'+','MarkerSize',12)
legend('t-90','t-50')
xlabel('Concentration (M)')
ylabel('Time to completion (s)')
xlim([1e-7 3e-4])
print(h_fig2,'-depsc','-r300','-tiff','KinTracesTimes')

save('conc_vec_exp.txt','conc_vec','-ascii')
save('t90_vec_exp.txt','t90_vector','-ascii')
save('t50_vec_exp.txt','t50_vector','-ascii')