
% This script replicates Figure 7 and Figure 8 in the article: 
% "When to Be Discrete: The Importance of Time Formulation
% in the Modeling of Extreme Events in Finance" 
% by Katarzyna Bień-Barkowska and Rodrigo Herrera
% Author: Katarzyna Bień-Barkowska

tic 

clc;
clear;


% set the path to the place where the m-file is opened

if(~isdeployed)
  cd(fileparts(matlab.desktop.editor.getActiveFilename));
end


path=fileparts(matlab.desktop.editor.getActiveFilename);

% Load the data on financial returns and the estimates (time-varying expectations, hazard functions) which can be generated using the APTECH GAUSS script
% "Estimation_of_final_SPOT_models.gss".

K={strcat(path, '\data\DowJones.xlsx')};
G1={strcat(path, '\output_data\VaR_Burr_DowJones_explanatory_inv_rolling.txt')};
G2={strcat(path, '\output_data\VaR_DBurr_DowJones_explanatory_inv_rolling.txt')};
G3={strcat(path, '\output_data\VaR_GGamma_DowJones_explanatory_inv_rolling.txt')};
G4={strcat(path, '\output_data\VaR_DGGamma_DowJones_explanatory_inv_rolling.txt')};
G5={strcat(path, '\output_data\VaR_Weibull_DowJones_explanatory_inv_rolling.txt')};
G6={strcat(path, '\output_data\VaR_DWeibull_DowJones_explanatory_inv_rolling.txt')};
G7={strcat(path, '\output_data\VaR_BNB_DowJones_explanatory_inv_rolling.txt')};


%%


figure('Name', 'Figure 7', 'NumberTitle','off') ;

t = tiledlayout(4,2,'TileSpacing','Compact','Padding','Compact');

set(gcf, 'Position',  [400 1 700 800]);


data = readmatrix(K{1});


dates = data(:,1);

%%
dates = datetime(dates, 'ConvertFrom', 'excel');

returns=(data(:,14))*100;

% This corresponds to the threshold u for Dow Jones

q=-1.35;

extremes= (returns<q);

prices=data(:,6);

A1=timetable(dates, prices, returns, extremes);

S = timerange('01-Jan-1981','29-Dec-2022');

A2=A1(S,:);

A3=A2(:,:);



data1 = readtable(G1{1});
data2 = readtable(G2{1});
data3 = readtable(G3{1});
data4 = readtable(G4{1});
data5 = readtable(G5{1});
data6 = readtable(G6{1});
data7 = readtable(G7{1});


data1 = readmatrix(G1{1});
data2 = readmatrix(G2{1});
data3 = readmatrix(G3{1});
data4 = readmatrix(G4{1});
data5 = readmatrix(G5{1});
data6 = readmatrix(G6{1});
data7 = readmatrix(G7{1});

intensity1=data1(:,6);

ksi1=data1(:,5);

var1=data1(:,10);

es1=data1(:,11);

intensity2=data2(:,6);

ksi2=data2(:,5);

intensity3=data3(:,6);

ksi3=data3(:,5);

intensity4=data4(:,6);

ksi4=data4(:,5);

intensity5=data5(:,6);

ksi5=data5(:,5);

intensity6=data6(:,6);

ksi6=data6(:,5);

intensity7=data7(:,6);

ksi7=data7(:,5);

sigma7=data2(:,7);

var7=data2(:,10);

es7=data2(:,11);

A4=addvars(A3, ksi1, intensity1, ksi2, intensity2, ksi3, intensity3, ksi4, intensity4, ksi5, intensity5, ...
    sigma7, ksi7, ksi6, intensity6, intensity7, var7, es7, es1, var1);


S1 = timerange('1-Jan-2022','01-May-2022');
A4=A4(S1,:);
A4 = timetable2table(A4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nexttile(3)

plot(A4.intensity1, 'LineWidth', 2, 'Color', 'black');  

hold on
scatter(1:length(A4.intensity2), A4.intensity2, 6, 'filled', 'MarkerEdgeColor', [0.5 0.5 0.5], 'MarkerFaceColor', [0.5 0.5 0.5]);
y1 = ylim;
hold on;
h=stem(A4.extremes*1/8*max(A4.intensity2), 'LineStyle','-', 'Color', 'black', 'LineWidth', 1);
set(h, 'Marker', 'none');

ylabel('$\hat{h}(t|\mathcal{F}_{i-1})$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);

set(gca,'FontName', 'Times New Roman', 'FontSize', 12);

set(gca,'xTick',[1 21 40 63 83], 'TickDir','out');
set(gca,'xTickLabel', {'3 Jan', '1 Feb', '1 Mar', '1 Apr', '1 May'});
legend({'$\mathcal{B}$-SPOT', '$\mathcal{DB}$-SPOT'}, 'Interpreter', 'Latex', 'location', 'northeast');
ylim([0,0.3]);
xlim([0,82]);

legend box off;
box off;

nexttile(1)

% Estimated parameters for the Burr distribution (see Table 3)

b=1.419; 
k=1.257;

sr=b*beta(b-1/k, 1+1/k);

A4.ksi1=A4.ksi1*sr;

scatter(1:length(A4.ksi1), A4.ksi1, 6, 'filled', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'black');  


% Estimated parameters for the discrete Burr distribution (see Table 3)

k=0.948; 
b=3.591;
% 

x=1:10000;
sr_discrete=ones(length(A4.ksi2),1);
sr_discrete1=ones(length(A4.ksi2),1);


for kik=1:length(A4.ksi2)
sr_discrete(kik) = sum(((1+((x-1)./A4.ksi2(kik)).^k).^(-b)-(1+((x)./A4.ksi2(kik)).^k).^(-b)).*x);
sr_discrete1(kik) = sum(((1+((x-1)./A4.ksi2(kik)).^k).^(-b)));
end


hold on
scatter(1:length(A4.ksi2), sr_discrete, 6, 'filled', 'MarkerEdgeColor', [0.5 0.5 0.5], 'MarkerFaceColor', [0.5 0.5 0.5]);

hold on;
h=stem(A4.extremes*1/8*max(sr_discrete), 'LineStyle','-', 'Color', 'black', 'LineWidth', 1);
set(h, 'Marker', 'none');




set(gca,'xTick',[1 21 40 63 83], 'TickDir','out');
set(gca,'xTickLabel', {'3 Jan', '1 Feb', '1 Mar', '1 Apr', '1 May'});
legend({'$\mathcal{B}$-SPOT', '$\mathcal{DB}$-SPOT'}, 'Interpreter', 'Latex', 'location', 'northeast');
set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
xlim([0,82]);
%ylabel('0 1 2 3', 'FontSize', 12, 'FontName', 'Arial Narrow');
ylabel('$\hat{E}(x_i|\mathcal{F}_{i-1})$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);


box off;
legend box off;
hold off;



nexttile(4)
plot(A4.intensity3, 'LineWidth', 2, 'Color', 'black'); 

hold on
scatter(1:length(A4.intensity4), A4.intensity4, 6, 'filled', 'MarkerEdgeColor', [0.5 0.5 0.5], 'MarkerFaceColor', [0.5 0.5 0.5]);
y2 = ylim;
hold on;
h=stem(A4.extremes*1/8*max(A4.intensity4), 'Color', 'black', 'LineWidth', 1);
set(h, 'Marker', 'none');
ylabel('$\hat{h}(t|\mathcal{F}_{i-1})$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);

set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
set(gca,'xTick',[1 21 40 63 83], 'TickDir','out');
set(gca,'xTickLabel', {'3 Jan', '1 Feb', '1 Mar', '1 Apr', '1 May'});
legend({'$\mathcal{GG}$-SPOT', '$\mathcal{DGG}$-SPOT'}, 'Interpreter', 'Latex', 'location', 'northeast');
ylim([0,0.3]);
xlim([0,82]);


legend box off;
box off;
hold off;


nexttile(2)

% parameters Generalized Gamma (see Table 3)

alpha=3.462;
gamm=0.481;

sr_gam=gamma(alpha+1/gamm)/gamma(alpha);

A4.ksi3=A4.ksi3*sr_gam;

% parameters Discrete Generalized Gamma (see Table 3)
alpha=2.957;
gamm=0.444;

x=1:10000;
sr_discrete=ones(length(A4.ksi4),1);


for kik=1:length(A4.ksi4)
sr_discrete(kik) = sum(((1-gammainc(((x-1)./A4.ksi4(kik)).^gamm, alpha))-(1-gammainc(((x)./A4.ksi4(kik)).^gamm, alpha))).*x);
end


scatter(1:length(A4.ksi1), A4.ksi3, 6, 'filled', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'black');  

hold on
scatter(1:length(A4.ksi2), sr_discrete, 6, 'filled', 'MarkerEdgeColor', [0.5 0.5 0.5], 'MarkerFaceColor', [0.5 0.5 0.5]);

hold on;
h=stem(A4.extremes*1/8*max(sr_discrete), 'LineStyle','-', 'Color', 'black', 'LineWidth', 1);
set(h, 'Marker', 'none');


%ylabel('0 1 2 3', 'FontName', 'Arial Narrow', 'FontSize', 12);

set(gca,'xTick',[1 21 40 63 83], 'TickDir','out');
set(gca,'xTickLabel', {'3 Jan', '1 Feb', '1 Mar', '1 Apr', '1 May'});
legend({'$\mathcal{GG}$-SPOT', '$\mathcal{DGG}$-SPOT'}, 'Interpreter', 'Latex', 'location', 'northeast');
set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
xlim([0,82]);
% ylabel('0 1 2 3', 'FontSize', 12, 'FontName', 'Arial Narrow');
ylabel('$\hat{E}(x_i|\mathcal{F}_{i-1})$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);


box off;
legend box off;
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nexttile(7)

plot(A4.intensity5, 'LineWidth', 2, 'Color', 'black'); 

hold on
scatter(1:length(A4.intensity6), A4.intensity6, 6, 'filled', 'MarkerEdgeColor', [0.5 0.5 0.5], 'MarkerFaceColor', [0.5 0.5 0.5]);

hold on;
h=stem(A4.extremes*1/8*max(A4.intensity6), 'Color', 'black', 'LineWidth', 1);
set(h, 'Marker', 'none');
ylabel('$\hat{h}(t|\mathcal{F}_{i-1})$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);
set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
set(gca,'xTick',[1 21 40 63 83], 'TickDir','out');
set(gca,'xTickLabel', {'3 Jan', '1 Feb', '1 Mar', '1 Apr', '1 May'});
legend({'$\mathcal{W}$-SPOT', '$\mathcal{DW}$-SPOT'}, 'Interpreter', 'Latex', 'location', 'northeast');
ylim([0,0.3]);
xlim([0,82]);


box off;
legend box off;
hold off;


nexttile(5)


sr=gamma(1+1/0.901);

A4.ksi5=A4.ksi5*sr;


x=1:10000;
sr_discrete=ones(length(A4.ksi6),1);

ksi1=10;

for kik=1:length(A4.ksi6)
sr_discrete(kik) = sum((exp(-((x-1)./A4.ksi6(kik)).^0.782)-exp(-((x)./A4.ksi6(kik)).^0.782)).*x);
end

scatter(1:length(A4.ksi5), A4.ksi5, 6, 'filled', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'black');  

hold on
scatter(1:length(A4.ksi6), sr_discrete, 6, 'filled', 'MarkerEdgeColor', [0.5 0.5 0.5], 'MarkerFaceColor', [0.5 0.5 0.5]);

hold on;
h=stem(A4.extremes*1/8*max(sr_discrete), 'LineStyle','-', 'Color', 'black', 'LineWidth', 1);
set(h, 'Marker', 'none');



set(gca,'xTick',[1 21 40 63 83], 'TickDir','out');
set(gca,'xTickLabel', {'3 Jan', '1 Feb', '1 Mar', '1 Apr', '1 May'});
legend({'$\mathcal{W}$-SPOT', '$\mathcal{DW}$-SPOT'}, 'Interpreter', 'Latex', 'location', 'northeast');
set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
xlim([0,82]);
ylim([0,20]);

% ylabel('0 1 2 3', 'FontSize', 12, 'FontName', 'Arial Narrow');
ylabel('$\hat{E}(x_{i}|\mathcal{F}_{i-1})$', 'Interpreter','Latex', 'FontName', 'Courier', 'FontSize', 12);

box off;
legend box off;
hold off;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nexttile(8)


scatter(1:length(A4.intensity7), A4.intensity7, 6, 'filled', 'MarkerEdgeColor', [0.5 0.5 0.5], 'MarkerFaceColor', [0.5 0.5 0.5]);
y4 = ylim;
hold on;
h=stem(A4.extremes*1/8*max(A4.intensity7), 'Color', 'black', 'LineWidth', 1);
set(h, 'Marker', 'none');
ylabel('$\hat{h}(t|\mathcal{F}_{i-1})$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);
%title('[B]','FontName', 'Times New Roman', 'FontSize', 18);
set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
set(gca,'xTick',[1 21 40 63 83], 'TickDir','out');
set(gca,'xTickLabel', {'3 Jan', '1 Feb', '1 Mar', '1 Apr', '1 May'});
legend({'$\mathcal{BNB}$-SPOT'}, 'Interpreter', 'Latex', 'location', 'northeast');
ylim([0,0.3]);
xlim([0,82]);


legend box off;
hold off


nexttile(6)

scatter(1:length(A4.ksi7), (A4.ksi7+1), 6, 'filled', 'MarkerEdgeColor', [0.5 0.5 0.5], 'MarkerFaceColor', [0.5 0.5 0.5]);  


hold on;
h=stem(A4.extremes*1/8*max(A4.ksi6), 'LineStyle','-', 'Color', 'black', 'LineWidth', 1);
set(h, 'Marker', 'none');


set(gca,'xTick',[1 21 40 63 83], 'TickDir','out');
set(gca,'xTickLabel', {'3 Jan', '1 Feb', '1 Mar', '1 Apr', '1 May'});


legend({'$\mathcal{BNB}$-SPOT'}, 'Interpreter', 'Latex', 'location', 'northeast');
set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
xlim([0,82]);
%ylabel('0 1 2 3', 'FontSize', 12, 'FontName', 'Arial Narrow');
ylabel('$\hat{E}(x_i|\mathcal{F}_{i-1}$)', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);


box off;
legend box off;
print(strcat(path, '/replicated_results/Figure_7.pdf'), '-dpdf')

hold off;

%%

figure('Name', 'Figure 8 (top row)', 'NumberTitle','off') 

tiledlayout(1,1,'TileSpacing','Compact','Padding','Compact');

set(gcf, 'Position',  [400 1 700 200]);


nexttile(1)

plot(A4.sigma7, 'LineWidth', 2, 'Color', 'black'); 


hold on;
h=stem(A4.extremes*1/8*max(A4.sigma7), 'Color', 'black', 'LineWidth', 1);
set(h, 'Marker', 'none');
ylabel('$ \hat{\sigma}_t $', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);

set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
set(gca,'xTick',[1 21 40 63 83], 'TickDir','out');
set(gca,'xTickLabel', {'3 Jan', '1 Feb', '1 Mar', '1 Apr', '1 May'});

xlim([0,82]);
box off;


print(strcat(path, '/replicated_results/Figure_8_top.pdf'), '-dpdf')



hold off;


%% 
figure('Name', 'Figure 8 (bottom row)', 'NumberTitle','off') 

T = tiledlayout(1,1,'TileSpacing','Compact','Padding','Compact');

set(gcf, 'Position',  [400 1 700 350]);
nexttile(1)

scatter(1:length(A4.var7), A4.var7, 15, 'filled', 'MarkerEdgeColor', [0.5 0.5 0.5], 'MarkerFaceColor', [0.5 0.5 0.5]);

hold on
y3 = ylim;

ylabel('$y_t$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);

scatter(1:length(A4.var1), A4.var1, 15, 'filled', 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0]);

returns1=A4.returns;
ex_ret=A4.returns.*A4.extremes;
ff= ex_ret~=0;
returns1(ff)=nan;

scatter(1:length(A4.returns), -returns1, 15, 'MarkerEdgeColor', 'black', 'MarkerFaceColor', [1 1 1]);


ex_ret=A4.returns.*A4.extremes;
ff= find(ex_ret==0);
ex_ret(ff)=nan;

scatter(1:length(A4.returns), -ex_ret, 40, '*', 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0]);

h=stem(A4.extremes*1/8*max(A4.es7), 'Color', 'black', 'LineWidth', 1);
set(h, 'Marker', 'none');

set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
set(gca,'xTick',[1 21 40 63 83], 'TickDir','out');
set(gca,'xTickLabel', {'3 Jan', '1 Feb', '1 Mar', '1 Apr', '1 May'});
leg=legend({'$\mathcal{DB}$-SPOT 97.5\% VaR', '$\mathcal{B}$-SPOT 97.5\% VaR', 'negative returns', 'extreme events', ''}, 'location', 'south', 'Interpreter', 'Latex');
box off;


xlim([0,82]);

print(strcat(path, '/replicated_results/Figure_8_bottom.pdf'), '-dpdf')

hold off;


toc
