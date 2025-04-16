% Author: Katarzyna Bień-Barkowska
% This script replicates Figure 5 depicting results of the Monte Carlo Simulation according to the the DB-SPOT (DGP I): 
% "When to Be Discrete: The Importance of Time Formulation
% in the Modeling of Extreme Events in Finance" 
% by Katarzyna Bień-Barkowska and Rodrigo Herrera


% Important: The type of data files (which are to be imported) was changed from the Gauss (APTECH systems) .dat files to the Matlab .mat files using the Stat/TRANSFER software. 


tic;

clc;
clear;



% set the path to the place where the m-file is opened

if(~isdeployed)
  cd(fileparts(matlab.desktop.editor.getActiveFilename));
end

folder=fileparts(matlab.desktop.editor.getActiveFilename);


Nb_of_replications=1000;


% Load intermediate datasets

param_DB_DB_2000=readmatrix(strcat(folder, "/output_data/Simulation/Simulation_from_DBurr_DBurr_estimates_sample_2000.txt"));


param_DB_DB_500=readmatrix(strcat(folder, "/output_data/Simulation/Simulation_from_DBurr_DBurr_estimates_sample_500.txt"));


param_DB_DB_250=readmatrix(strcat(folder, "/output_data/Simulation/Simulation_from_DBurr_DBurr_estimates_sample_250.txt"));


param_DB_B_2000=readmatrix(strcat(folder, "/output_data/Simulation/Simulation_from_DBurr_Burr_estimates_sample_2000.txt"));


param_DB_B_500=readmatrix(strcat(folder, "/output_data/Simulation/Simulation_from_DBurr_Burr_estimates_sample_500.txt"));


param_DB_B_250=readmatrix(strcat(folder, "/output_data/Simulation/Simulation_from_DBurr_Burr_estimates_sample_250.txt"));


param_kappa_DB_2000=param_DB_DB_2000(1:Nb_of_replications, 4);
param_kappa_B_2000=param_DB_B_2000(1:Nb_of_replications, 4);

param_b_DB_2000=param_DB_DB_2000(1:Nb_of_replications, 5);
param_b_B_2000=param_DB_B_2000(1:Nb_of_replications, 5);

param_kappa_DB_500=param_DB_DB_500(1:Nb_of_replications, 4);
param_kappa_B_500=param_DB_B_500(1:Nb_of_replications, 4);

param_b_DB_500=param_DB_DB_500(1:Nb_of_replications, 5);
param_b_B_500=param_DB_B_500(1:Nb_of_replications, 5);

param_kappa_DB_250=param_DB_DB_250(1:Nb_of_replications, 4);
param_kappa_B_250=param_DB_B_250(1:Nb_of_replications, 4);

param_b_DB_250=param_DB_DB_250(1:Nb_of_replications, 5);
param_b_B_250=param_DB_B_250(1:Nb_of_replications, 5);

figure('Name', 'Figure 5, the top row', 'NumberTitle','off') 

tiledlayout(1,2,'TileSpacing','Compact','Padding','Compact');
set(gcf, 'Position',  [400 1 800 200]);
nexttile;

[f, x1]=ksdensity(param_kappa_DB_2000);
[f1, x]=ksdensity(param_kappa_B_2000);

plot(x1,f, 'LineWidth', 2, 'color', [0.4 0.4 0.4] );
hold on
plot(x,f1, '-', 'LineWidth', 2, 'color', [0.7 0.7 0.7]);

hold on
[f, x1]=ksdensity(param_kappa_DB_500);
[f1, x]=ksdensity(param_kappa_B_500);

plot(x1,f, '--', 'LineWidth', 2, 'color', [0.4 0.4 0.4] );
hold on
plot(x,f1, '--', 'LineWidth', 2, 'color', [0.7 0.7 0.7]);

hold on
[f, x1]=ksdensity(param_kappa_DB_250);
[f1, x]=ksdensity(param_kappa_B_250);

plot(x1,f, ':', 'LineWidth', 2, 'color', [0.4 0.4 0.4] );
hold on
plot(x,f1, ':', 'LineWidth', 2, 'color', [0.7 0.7 0.7]);

set(gca,'FontSize',12, 'FontName', 'Times New Roman');
xlabel({'\kappa estimator'}, 'FontSize', 16, 'FontName', 'Times New Roman');
ylabel({'Density'}, 'FontSize', 14, 'FontName', 'Times New Roman');

legend({'$\mathcal{DB}$ distribution', '$\mathcal{B}$ distribution'}, 'location', 'northeast', 'FontSize', 14,  'NumColumns', 1, 'FontName', 'Times New Roman', 'Interpreter','Latex');
legend box off;
xlim([0.5,3]);

hold off


%% Kernel density plots

nexttile;

[f, x1]=ksdensity(param_b_DB_2000);
[f1, x]=ksdensity(param_b_B_2000);

plot(x1,f, 'LineWidth', 2, 'color', [0.4 0.4 0.4] );
hold on
plot(x,f1, '-', 'LineWidth', 2, 'color', [0.7 0.7 0.7]);


hold on
[f, x1]=ksdensity(param_b_DB_500);
[f1, x]=ksdensity(param_b_B_500);

plot(x1,f, '--', 'LineWidth', 2, 'color', [0.4 0.4 0.4] );
hold on
plot(x,f1, '--', 'LineWidth', 2, 'color', [0.7 0.7 0.7]);

hold on
[f, x1]=ksdensity(param_b_DB_250);
[f1, x]=ksdensity(param_b_B_250);

plot(x1,f, ':', 'LineWidth', 2, 'color', [0.4 0.4 0.4] );
hold on
plot(x,f1, ':', 'LineWidth', 2, 'color', [0.7 0.7 0.7]);

set(gca,'FontSize',12, 'FontName', 'Times New Roman');
xlabel({'\zeta estimator'}, 'FontSize', 16, 'FontName', 'Times New Roman');
ylabel({'Density'}, 'FontSize', 14, 'FontName', 'Times New Roman');

leg=legend({'$\mathcal{DB}$ distribution', '$\mathcal{B}$ distribution'}, 'location', 'northeast', 'FontSize', 14,  'NumColumns', 1, 'FontName', 'Times New Roman', 'Interpreter','Latex');
legend box off;
xlim([0,8]);

print(strcat(folder, '/replicated_results/Figure_5_row_1.pdf'), '-dpdf')
hold off


sr_DB=mean(param_DB_DB_2000);
sr_B=mean(param_DB_B_2000);




%% Comparison of intensity functions


figure('Name', 'Figure 5, the middle row', 'NumberTitle','off') 

t = tiledlayout(1,3,'TileSpacing','Compact','Padding','Compact');
set(gcf, 'Position',  [400 1 800 200]);

nexttile
% resulting hazard 

x=1:50;

ksi=1;

b=sr_B(5); 
k=sr_B(4);


korr= b*beta(b(1)-1/k(1), 1+1/k(1));

ksi1=ksi/korr;


h1 = (k*b*(ksi1^(-k)).*(x.^(k-1)))./(1+(x./ksi1).^k);

plot(x,h1, '-*',  'MarkerSize', 4, 'LineWidth', 2, 'color', [0.7 0.7 0.7] )


ksi=0.1;


hold on

 % 
b=sr_DB(5); 
k=sr_DB(4);

korr= b*beta(b(1)-1/k(1), 1+1/k(1));

ksi1=ksi/korr;



h = ((1+((x-1)./ksi1).^k).^(-b)-(1+((x)./ksi1).^k).^(-b))./(1+((x-1)./ksi1).^k).^(-b);

 
plot(x,h, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.4 0.4 0.4] )


set(gca,'FontSize',12, 'FontName', 'Times New Roman');
xlabel({'$t-t_{i-1}$', ' \bf{E}$(x_i \mid \mathcal{F}_{t_{i-1}})=1$'}, 'FontSize', 16, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
xlabel({'$t-t_{i-1}$'}, 'FontSize', 16, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
title('01', 'FontSize', 16);
title({'\bf{E}$(x_i \mid \mathcal{F}_{i-1})=1$'}, 'FontSize', 16, 'Interpreter', 'Latex');

ylabel({'$h(t \mid \mathcal{F}_{i-1})$'}, 'FontSize', 14, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
legend off;
xlim([0,50]);

hold off





nexttile

x=1:50;


ksi=10;

b=sr_B(5); 
k=sr_B(4);


korr= b*beta(b(1)-1/k(1), 1+1/k(1));

ksi1=ksi/korr;

h1 = (k*b*(ksi1^(-k)).*(x.^(k-1)))./(1+(x./ksi1).^k);


plot(x,h1, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.7 0.7 0.7] )


ksi=9.5;

hold on

 
b=sr_DB(5); 
k=sr_DB(4);

korr= b*beta(b(1)-1/k(1), 1+1/k(1));

ksi1=ksi/korr;


h = ((1+((x-1)./ksi1).^k).^(-b)-(1+((x)./ksi1).^k).^(-b))./(1+((x-1)./ksi1).^k).^(-b);

 
plot(x,h, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.4 0.4 0.4] )


set(gca,'FontSize',12, 'FontName', 'Times New Roman');
xlabel({'$t-t_{i-1}$', '\bf{E}$(x_i \mid \mathcal{F}_{t_{i-1}})=10$'}, 'Interpreter', 'Latex', 'FontSize', 16, 'FontName', 'Times New Roman');
xlabel({'$t-t_{i-1}$'}, 'Interpreter', 'Latex', 'FontSize', 16, 'FontName', 'Times New Roman');
title('02', 'FontSize', 16);
title({'\bf{E}$(x_i \mid \mathcal{F}_{i-1})=10$'}, 'FontSize', 16, 'Interpreter', 'Latex');

ylabel({'$h(t \mid \mathcal{F}_{i-1})$'}, 'FontSize', 14, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');

legend off;
xlim([0,50]);

hold off


nexttile

% resulting hazard 

x=1:50;

ksi=20;

b=sr_B(5); 
k=sr_B(4);


korr= b*beta(b(1)-1/k(1), 1+1/k(1));

ksi1=ksi/korr;

h1 = (k*b*(ksi1^(-k)).*(x.^(k-1)))./(1+(x./ksi1).^k);
h2 = ((1+((x-1)./ksi1).^k).^(-b)-(1+((x)./ksi1).^k).^(-b))./(1+((x-1)./ksi1).^k).^(-b);

plot(x,h1, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.7 0.7 0.7] )


ksi=ksi-0.5;


hold on

 
b=sr_DB(5); 
k=sr_DB(4);

korr= b*beta(b(1)-1/k(1), 1+1/k(1));

ksi1=ksi/korr;



ala=(k*ksi1^k - ksi1^k)^(1/k); 

h = ((1+((x-1)./ksi1).^k).^(-b)-(1+((x)./ksi1).^k).^(-b))./(1+((x-1)./ksi1).^k).^(-b);

 
plot(x,h, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.4 0.4 0.4] )


set(gca,'FontSize',12, 'FontName', 'Times New Roman');

xlabel({'$t-t_{i-1}$', '$(x_i \mid \mathcal{F}_{i-1})=20$'}, 'FontSize', 16, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
xlabel({'$t-t_{i-1}$'}, 'FontSize', 16, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
title('03', 'FontSize', 16);
title({'\bf{E}$(x_i \mid \mathcal{F}_{i-1})=20$'}, 'FontSize', 16, 'Interpreter', 'Latex');

ylabel({'$h(t \mid \mathcal{F}_{i-1})$'}, 'FontSize', 14, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');

legend off;
xlim([0,50]);
print(strcat(folder, '/replicated_results/Figure_5_row_2.pdf'), '-dpdf')

hold off



%% Comparison of two trajectories DB-SPOT intensity versus B-SPOT intensity


load(strcat(folder, "/output_data/Simulation/Simulation_trajectory_DBurr_intensity_true"));

intensity_true=data;

load(strcat(folder, "/output_data/Simulation/Simulation_trajectory_Burr_intensity_est"));

intensity_est=data;

load(strcat(folder, "/output_data/Simulation/Simulation_trajectory_DBurr_expectation_true"));

expectation_est=data;



duration =[17; 1; 20; 7; 2; 4; 4; 4; 3; 1; 3; 1; 4];
cum_duration=cumsum(duration);


b=sr_DB(5); 
k=sr_DB(4);



figure('Name', 'Figure 5, the bottom row', 'NumberTitle','off') 


set(gcf, 'Position',  [400 1 800 200]);
yyaxis left


end1=80;

  
intensity_1_t=[intensity_true(1:duration(1)); NaN(end1-24,1)];

intensity_2_t=[NaN(17,1); intensity_true(duration(1)+1:duration(1)+duration(2)); NaN(end1-25,1)];

intensity_3_t=[NaN(18,1); intensity_true(cum_duration(2)+1:cum_duration(3)); NaN(end1-45,1)];

intensity_4_t=[NaN(38,1); intensity_true(cum_duration(3)+1:cum_duration(4)); NaN(end1-52,1)];

intensity_5_t=[NaN(45,1); intensity_true(cum_duration(4)+1:cum_duration(5)); NaN(end1-54,1)];

intensity_6_t=[NaN(47,1); intensity_true(cum_duration(5)+1:cum_duration(6)); NaN(end1-58,1)];

intensity_7_t=[NaN(51,1); intensity_true(cum_duration(6)+1:cum_duration(7)); NaN(end1-62,1)];

intensity_8_t=[NaN(55,1); intensity_true(cum_duration(7)+1:cum_duration(8)); NaN(end1-66,1)];

intensity_9_t=[NaN(59,1); intensity_true(cum_duration(8)+1:cum_duration(9)); NaN(end1-69,1)];

intensity_10_t=[NaN(62,1); intensity_true(cum_duration(9)+1:cum_duration(10)); NaN(end1-70,1)];

intensity_11_t=[NaN(63,1); intensity_true(cum_duration(10)+1:cum_duration(11)); NaN(end1-73,1)];

intensity_12_t=[NaN(66,1); intensity_true(cum_duration(11)+1:cum_duration(12)); NaN(end1-74,1)];

intensity_13_t=[NaN(67,1); intensity_true(cum_duration(12)+1:cum_duration(13)); NaN(end1-78,1)];

plot(intensity_1_t, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.4 0.4 0.4]);
hold on;
plot(intensity_2_t, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.4 0.4 0.4]);
hold on;
plot(intensity_3_t, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.4 0.4 0.4]);
hold on;
plot(intensity_4_t, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.4 0.4 0.4]);
hold on;
plot(intensity_5_t, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.4 0.4 0.4]);
hold on;
plot(intensity_6_t, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.4 0.4 0.4]);
hold on;
plot(intensity_7_t, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.4 0.4 0.4]);
hold on;
plot(intensity_8_t, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.4 0.4 0.4]);
hold on;
plot(intensity_9_t, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.4 0.4 0.4]);
hold on;
plot(intensity_10_t, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.4 0.4 0.4]);
hold on;
plot(intensity_11_t, '-*', 'LineWidth', 2, 'color', [0.4 0.4 0.4]);
hold on;
plot(intensity_12_t, '-*', 'LineWidth', 2, 'color', [0.4 0.4 0.4]);
hold on;
plot(intensity_13_t, '-*', 'LineWidth', 2, 'color', [0.4 0.4 0.4]);


hold on;

end1=80;


intensity_1=[intensity_est(1:duration(1)); NaN(end1-24,1)];

intensity_2=[NaN(17,1); intensity_est(duration(1)+1:duration(1)+duration(2)); NaN(end1-25,1)];

intensity_3=[NaN(18,1); intensity_est(cum_duration(2)+1:cum_duration(3)); NaN(end1-45,1)];

intensity_4=[NaN(38,1); intensity_est(cum_duration(3)+1:cum_duration(4)); NaN(end1-52,1)];

intensity_5=[NaN(45,1); intensity_est(cum_duration(4)+1:cum_duration(5)); NaN(end1-54,1)];
intensity_6=[NaN(47,1); intensity_est(cum_duration(5)+1:cum_duration(6)); NaN(end1-58,1)];
intensity_7=[NaN(51,1); intensity_est(cum_duration(6)+1:cum_duration(7)); NaN(end1-62,1)];
intensity_8=[NaN(55,1); intensity_est(cum_duration(7)+1:cum_duration(8)); NaN(end1-66,1)];
intensity_9=[NaN(59,1); intensity_est(cum_duration(8)+1:cum_duration(9)); NaN(end1-69,1)];
intensity_10=[NaN(62,1); intensity_est(cum_duration(9)+1:cum_duration(10)); NaN(end1-70,1)];
intensity_11=[NaN(63,1); intensity_est(cum_duration(10)+1:cum_duration(11)); NaN(end1-73,1)];
intensity_12=[NaN(66,1); intensity_est(cum_duration(11)+1:cum_duration(12)); NaN(end1-74,1)];
intensity_13=[NaN(67,1); intensity_est(cum_duration(12)+1:cum_duration(13)); NaN(end1-78,1)];


plot(intensity_1, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.7 0.7 0.7]);
hold on;
plot(intensity_2, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.7 0.7 0.7]);
hold on;
plot(intensity_3, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.7 0.7 0.7]);
hold on;
plot(intensity_4, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.7 0.7 0.7]);
hold on;
plot(intensity_5, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.7 0.7 0.7]);
hold on;
plot(intensity_6, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.7 0.7 0.7]);
hold on;
plot(intensity_7, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.7 0.7 0.7]);
hold on;
plot(intensity_8, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.7 0.7 0.7]);
hold on;
plot(intensity_9, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.7 0.7 0.7]);
hold on;
plot(intensity_10, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.7 0.7 0.7]);
hold on;
plot(intensity_11, '-*', 'MarkerSize', 4, 'LineWidth', 2, 'color', [0.7 0.7 0.7]);
hold on;
plot(intensity_12, '-*', 'LineWidth', 2, 'color', [0.7 0.7 0.7]);
hold on;
plot(intensity_13, '-*', 'LineWidth', 2, 'color', [0.7 0.7 0.7]);



set(gca,'FontSize',12, 'FontName', 'Times New Roman');

xlabel('$t$', 'FontSize', 16, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
ylabel({'$h(t \mid \mathcal{F}_{i-1})$'}, 'FontSize', 14, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
ax = gca;
ax.YAxis(1).Color = [0.4 0.4 0.4];
ax.YAxis(2).Color = 'black';

yyaxis right


scatter(1:71, expectation_est(1:71), 6, 'filled', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'black')
ylabel({'\bf{E}$(x_i \mid \mathcal{F}_{i-1})$'}, 'FontSize', 14, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
% ylabel({'0 1 2 3 4'}, 'FontName', 'Arial Narrow', 'FontSize', 12 );

xlim([0,71]);

print(strcat(folder, '/replicated_results/Figure_5_row_3.pdf'), '-dpdf')
hold off


toc;

