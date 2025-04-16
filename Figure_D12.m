% Author: Katarzyna Bień-Barkowska
% This script replicates Figures depicting results of the Monte Carlo Simulation according to the the DB-SPOT (DGP I) or DGG-SPOT (DGP II) in the article: 
% "When to Be Discrete: The Importance of Time Formulation
% in the Modeling of Extreme Events in Finance" 
% by Katarzyna Bień-Barkowska and Rodrigo Herrera


% Important: The type of data files (which are to be imported) was changed from the Gauss (APTECH systems) .dat files to the Matlab .mat files using the Stat/TRANSFER software. 

clc;
clear;

 
tic

% set the path to the place where the m-file is opened

if(~isdeployed)
  cd(fileparts(matlab.desktop.editor.getActiveFilename));
end

folder=fileparts(matlab.desktop.editor.getActiveFilename);


Nb_of_replications=1000;




param_DGG_DGG_2000=load(strcat(folder, "/output_data/Simulation/Simulation_from_DGGamma_DGGamma_estimates_sample_2000.txt"));

%param_DGG_DGG_2000=data;

param_DGG_DGG_500=load(strcat(folder, "/output_data/Simulation/Simulation_from_DGGamma_DGGamma_estimates_sample_500.txt"));

%param_DGG_DGG_500=data;

param_DGG_DGG_250=load(strcat(folder, "/output_data/Simulation/Simulation_from_DGGamma_DGGamma_estimates_sample_250.txt"));

%param_DGG_DGG_250=data;

param_DGG_GG_2000=load(strcat(folder, "/output_data/Simulation/Simulation_from_DGGamma_GGamma_estimates_sample_2000.txt"));

%param_DGG_GG_2000=data;

param_DGG_GG_500=load(strcat(folder, "/output_data/Simulation/Simulation_from_DGGamma_GGamma_estimates_sample_500.txt"));

%param_DGG_GG_500=data;

param_DGG_GG_250=load(strcat(folder, "/output_data/Simulation/Simulation_from_DGGamma_GGamma_estimates_sample_250.txt"));

%param_DGG_GG_250=data;

param_alpha_DGG_2000=param_DGG_DGG_2000(1:Nb_of_replications, 4);
param_alpha_GG_2000=param_DGG_GG_2000(1:Nb_of_replications, 4);

param_gamma_DGG_2000=param_DGG_DGG_2000(1:Nb_of_replications, 5);
param_gamma_GG_2000=param_DGG_GG_2000(1:Nb_of_replications, 5);

param_alpha_DGG_500=param_DGG_DGG_500(1:Nb_of_replications, 4);
param_alpha_GG_500=param_DGG_GG_500(1:Nb_of_replications, 4);

param_gamma_DGG_500=param_DGG_DGG_500(1:Nb_of_replications, 5);
param_gamma_GG_500=param_DGG_GG_500(1:Nb_of_replications, 5);

param_alpha_DGG_250=param_DGG_DGG_250(1:Nb_of_replications, 4);
param_alpha_GG_250=param_DGG_GG_250(1:Nb_of_replications, 4);

param_gamma_DGG_250=param_DGG_DGG_250(1:Nb_of_replications, 5);
param_gamma_GG_250=param_DGG_GG_250(1:Nb_of_replications, 5);




%% Kernel density plots

figure('Name', 'Figure D12, the upper row', 'NumberTitle','off') 
tiledlayout(1,2,'TileSpacing','Compact','Padding','Compact');
set(gcf, 'Position',  [400 1 800 200]);
nexttile;


bandwidth=1.06*std(param_alpha_DGG_2000)*length(param_alpha_DGG_2000)^(-1/5);

[f, x1]=ksdensity(param_alpha_DGG_2000, 'Bandwidth', bandwidth);


bandwidth=1.06*std(param_alpha_GG_2000)*length(param_alpha_GG_2000)^(-1/5);

[f1, x]=ksdensity(param_alpha_GG_2000, 'Bandwidth', bandwidth);

plot(x1,f, 'LineWidth', 2, 'color', [0.4 0.4 0.4] );
hold on
plot(x,f1, '-', 'LineWidth', 2, 'color', [0.7 0.7 0.7]);

hold on

bandwidth=1.06*std(param_alpha_DGG_500)*length(param_alpha_DGG_500)^(-1/5);

[f, x1]=ksdensity(param_alpha_DGG_500, 'Bandwidth', bandwidth);

bandwidth=1.06*std(param_alpha_GG_500)*length(param_alpha_GG_500)^(-1/5);

[f1, x]=ksdensity(param_alpha_GG_500, 'Bandwidth', bandwidth);

plot(x1,f, '--', 'LineWidth', 2, 'color', [0.4 0.4 0.4] );
hold on
plot(x,f1, '--', 'LineWidth', 2, 'color', [0.7 0.7 0.7]);

hold on

bandwidth=1.06*std(param_alpha_DGG_250)*length(param_alpha_DGG_250)^(-1/5);

[f, x1]=ksdensity(param_alpha_DGG_250, 'Bandwidth', bandwidth);

bandwidth=1.06*std(param_alpha_GG_250)*length(param_alpha_GG_250)^(-1/5);

[f1, x]=ksdensity(param_alpha_GG_250, 'Bandwidth', bandwidth);

plot(x1,f, ':', 'LineWidth', 2, 'color', [0.4 0.4 0.4] );
hold on
plot(x,f1, ':', 'LineWidth', 2, 'color', [0.7 0.7 0.7]);

set(gca,'FontSize',12, 'FontName', 'Times New Roman');
xlabel({'\nu estimator'}, 'FontSize', 14, 'FontName', 'Times New Roman');
ylabel({'Density'}, 'FontSize', 14, 'FontName', 'Times New Roman');

legend({'$\mathcal{DGG}$ distribution', '$\mathcal{GG}$ distribution'}, 'location', 'northeast', 'FontSize', 14,  'NumColumns', 1, 'FontName', 'Times New Roman', 'Interpreter','Latex');

legend box off;
xlim([2,5]);
hold off


nexttile;

[f, x1]=ksdensity(param_gamma_DGG_2000);
[f1, x]=ksdensity(param_gamma_GG_2000);

plot(x1,f, 'LineWidth', 2, 'color', [0.4 0.4 0.4] );
hold on
plot(x,f1, '-', 'LineWidth', 2, 'color', [0.7 0.7 0.7]);


hold on
[f, x1]=ksdensity(param_gamma_DGG_500);
[f1, x]=ksdensity(param_gamma_GG_500);

plot(x1,f, '--', 'LineWidth', 2, 'color', [0.4 0.4 0.4] );
hold on
plot(x,f1, '--', 'LineWidth', 2, 'color', [0.7 0.7 0.7]);

hold on

bandwidth=1.06*std(param_gamma_DGG_250)*length(param_gamma_DGG_250)^(-1/5);

[f, x1]=ksdensity(param_gamma_DGG_250, 'Bandwidth', bandwidth);

bandwidth=1.06*std(param_gamma_GG_250)*length(param_gamma_GG_250)^(-1/5);

[f1, x]=ksdensity(param_gamma_GG_250, 'Bandwidth', bandwidth);

plot(x1,f, ':', 'LineWidth', 2, 'color', [0.4 0.4 0.4] );
hold on
plot(x,f1, ':', 'LineWidth', 2, 'color', [0.7 0.7 0.7]);

set(gca,'FontSize',12, 'FontName', 'Times New Roman');
xlabel({'\gamma estimator'}, 'FontSize', 14, 'FontName', 'Times New Roman');
ylabel({'Density'}, 'FontSize', 14, 'FontName', 'Times New Roman');

leg=legend({'$\mathcal{DGG}$ distribution', '$\mathcal{GG}$ distribution'}, ...
    'location', 'northeast', 'FontSize', 14,  'NumColumns', 1, 'FontName', 'Times New Roman', 'Interpreter','Latex');
legend box off;
xlim([0.4,0.8]);

print(strcat(folder, '/replicated_results/Figure_D12_row_1.pdf'), '-dpdf')


hold off


sr_DGG=mean(param_DGG_DGG_2000);
sr_GG=mean(param_DGG_GG_2000);

%% Comparison of intensity functions

figure('Name', 'Figure D12, the middle row', 'NumberTitle','off') 

t = tiledlayout(1,3,'TileSpacing','Compact','Padding','Compact');
set(gcf, 'Position',  [400 1 800 200]);

nexttile
% resulting hazard 

x=1:1:50;

ksi=1;

alpha=sr_GG(4); 
gamm=sr_GG(5);

korr=gamma(alpha+1/gamm)/gamma(alpha);

ksi1=ksi/korr;

h=(gamm/gamma(alpha))*(ksi1^(-1)).*((x./ksi1).^(gamm*alpha-1)).*exp(-(x./ksi1).^gamm)./(1-gammainc((x./ksi1).^gamm, alpha));

plot(x,h, 'LineWidth', 2, 'color', [0.7 0.7 0.7] )


ksi=ksi-0.7;


hold on

 
alpha=sr_DGG(4); 
gamm=sr_DGG(5);

korr=gamma(alpha+1/gamm)/gamma(alpha);

ksi1=ksi/korr;

h=((1-gammainc(((x-1)./ksi1).^gamm, alpha))-(1-gammainc(((x)./ksi1).^gamm, alpha)))./(1-gammainc(((x-1)./ksi1).^gamm, alpha));

 
plot(x,h, 'LineWidth', 2, 'color', [0.4 0.4 0.4] )


set(gca,'FontSize',12, 'FontName', 'Times New Roman');
title('01', 'FontSize', 16);
title('$\bf{E}(x_i \mid \mathcal{F}_{i-1})=1$', 'FontSize', 16, 'Interpreter', 'Latex');

xlabel({'$t-t_{i-1}$'}, 'FontSize', 16, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
ylabel({'$h(t \mid \mathcal{F}_{i-1})$'}, 'FontSize', 14, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
legend off;

xlim([0,50]);
hold off



nexttile

x=1:100;

ksi=10;

alpha=sr_GG(4); 
gamm=sr_GG(5);

korr=gamma(alpha+1/gamm)/gamma(alpha);

ksi1=ksi/korr;

h=(gamm/gamma(alpha))*(ksi1^(-1)).*((x./ksi1).^(gamm*alpha-1)).*exp(-(x./ksi1).^gamm)./(1-gammainc((x./ksi1).^gamm, alpha));


plot(x,h, 'LineWidth', 2, 'color', [0.7 0.7 0.7] )


ksi=ksi-0.5;


hold on

 
alpha=sr_DGG(4); 
gamm=sr_DGG(5);

korr=gamma(alpha+1/gamm)/gamma(alpha);

ksi1=ksi/korr;



h=((1-gammainc(((x-1)./ksi1).^gamm, alpha))-(1-gammainc(((x)./ksi1).^gamm, alpha)))./(1-gammainc(((x-1)./ksi1).^gamm, alpha));

 
plot(x,h, 'LineWidth', 2, 'color', [0.4 0.4 0.4] )


set(gca,'FontSize',12, 'FontName', 'Times New Roman');
title('02', 'FontSize', 16);
title('$\bf{E}(x_i \mid \mathcal{F}_{i-1})=10$', 'FontSize', 16, 'Interpreter', 'Latex');
xlabel({'$t-t_{i-1}$'}, 'FontSize', 16, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
ylabel({'$h(t \mid \mathcal{F}_{i-1})$'}, 'FontSize', 14, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
legend off;

hold off


nexttile

x=1:100;

ksi=20;

alpha=sr_GG(4); 
gamm=sr_GG(5);

korr=gamma(alpha+1/gamm)/gamma(alpha);

ksi1=ksi/korr;

h=(gamm/gamma(alpha))*(ksi1^(-1)).*((x./ksi1).^(gamm*alpha-1)).*exp(-(x./ksi1).^gamm)./(1-gammainc((x./ksi1).^gamm, alpha));

plot(x,h, 'LineWidth', 2, 'color', [0.7 0.7 0.7] )


ksi=ksi-0.5;


hold on

 
alpha=sr_DGG(4); 
gamm=sr_DGG(5);

korr=gamma(alpha+1/gamm)/gamma(alpha);

ksi1=ksi/korr;


h=((1-gammainc(((x-1)./ksi1).^gamm, alpha))-(1-gammainc(((x)./ksi1).^gamm, alpha)))./(1-gammainc(((x-1)./ksi1).^gamm, alpha));
 
plot(x,h, 'LineWidth', 2, 'color', [0.4 0.4 0.4] )


set(gca,'FontSize',12, 'FontName', 'Times New Roman');

title('$\bf{E}(x_i \mid \mathcal{F}_{i-1})=20$', 'FontSize', 16, 'Interpreter', 'Latex');


xlabel({'$t-t_{i-1}$'}, 'FontSize', 16, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
ylabel({'$h(t \mid \mathcal{F}_{i-1})$'}, 'FontSize', 14, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
legend off;

print(strcat(folder, '/replicated_results/Figure_D12_row_2.pdf'), '-dpdf')

hold off


%% Comparison of two trajectories DGG-SPOT intensity versus GG-SPOT intensity



load(strcat(folder, "/output_data/Simulation/Simulation_trajectory_DGGamma_intensity_true"));

intensity_true=data;

load(strcat(folder, "/output_data/Simulation/Simulation_trajectory_GGamma_intensity_est"));

intensity_est=data;


load(strcat(folder, "/output_data/Simulation/Simulation_trajectory_DGGamma_expectation_true"));

expectation_est=data;



duration =[4; 6; 9; 6; 12; 28; 22; 3; 8];

cum_duration=cumsum(duration);


figure('Name', 'Figure D12, the bottom row', 'NumberTitle','off') 


set(gcf, 'Position',  [400 1 800 200]);
yyaxis left

end1=98;

intensity_1_t=[intensity_true(1:duration(1)); NaN(end1-4,1)]; 
intensity_2_t=[NaN(4,1); intensity_true(duration(1)+1:duration(1)+duration(2)); NaN(end1-10,1)];
intensity_3_t=[NaN(10,1); intensity_true(cum_duration(2)+1:cum_duration(3)); NaN(end1-19,1)];
intensity_4_t=[NaN(19,1); intensity_true(cum_duration(3)+1:cum_duration(4)); NaN(end1-25,1)];
intensity_5_t=[NaN(25,1); intensity_true(cum_duration(4)+1:cum_duration(5)); NaN(end1-37,1)];
intensity_6_t=[NaN(37,1); intensity_true(cum_duration(5)+1:cum_duration(6)); NaN(end1-65,1)];
intensity_7_t=[NaN(65,1); intensity_true(cum_duration(6)+1:cum_duration(7)); NaN(end1-87,1)];
intensity_8_t=[NaN(87,1); intensity_true(cum_duration(7)+1:cum_duration(8)); NaN(end1-90,1)];
intensity_9_t=[NaN(90,1); intensity_true(cum_duration(8)+1:cum_duration(9)); NaN(end1-98,1)];

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

end1=98;

intensity_1=[intensity_est(1:duration(1)); NaN(end1-4,1)];
intensity_2=[NaN(4,1); intensity_est(duration(1)+1:duration(1)+duration(2)); NaN(end1-10,1)];
intensity_3=[NaN(10,1); intensity_est(cum_duration(2)+1:cum_duration(3)); NaN(end1-19,1)];
intensity_4=[NaN(19,1); intensity_est(cum_duration(3)+1:cum_duration(4)); NaN(end1-25,1)];
intensity_5=[NaN(25,1); intensity_est(cum_duration(4)+1:cum_duration(5)); NaN(end1-37,1)];
intensity_6=[NaN(37,1); intensity_est(cum_duration(5)+1:cum_duration(6)); NaN(end1-65,1)];
intensity_7=[NaN(65,1); intensity_est(cum_duration(6)+1:cum_duration(7)); NaN(end1-87,1)];
intensity_8=[NaN(87,1); intensity_est(cum_duration(7)+1:cum_duration(8)); NaN(end1-90,1)];
intensity_9=[NaN(90,1); intensity_est(cum_duration(8)+1:cum_duration(9)); NaN(end1-98,1)];



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



set(gca,'FontSize',12, 'FontName', 'Times New Roman');

xlabel('$t$', 'FontSize', 16, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
ylabel({'$h(t \mid \mathcal{F}_{i-1})$'}, 'FontSize', 14, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
ax = gca;
ax.YAxis(1).Color = [0.4 0.4 0.4];
ax.YAxis(2).Color = 'black';

yyaxis right

scatter(1:98, expectation_est(1:98), 6, 'filled', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'black')

ylabel({'\bf{E}$(x_i \mid \mathcal{F}_{i-1})$'}, 'FontSize', 14, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');

% ylabel({'0 1 2 3 4'}, 'FontName', 'Arial Narrow', 'FontSize', 12 );

print(strcat(folder, '/replicated_results/Figure_D12_row_3.pdf'), '-dpdf')

hold off




toc


