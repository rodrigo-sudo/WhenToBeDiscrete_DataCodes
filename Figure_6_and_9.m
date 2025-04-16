
% This script replicates Figure 6 and Figure 9 in the article: 
% "When to Be Discrete: The Importance of Time Formulation
% in the Modeling of Extreme Events in Finance" 
% by Katarzyna Bień-Barkowska and Rodrigo Herrera
% Author: Katarzyna Bień-Barkowska

tic 

clear; 
clc; 


% set the path to the place where the m-file is opened


if(~isdeployed)
  cd(fileparts(matlab.desktop.editor.getActiveFilename));
end


folder=fileparts(matlab.desktop.editor.getActiveFilename);

% names of the indexes
instr0='DowJones';
instr1='NASDAQ';
instr2='SP500';
instr3='Wilshire';


data={instr0, instr1, instr2, instr3};

data1={'Dow Jones', 'NASDAQ', 'S&P 500', 'Wilshire 5000'};


kik=126;


figure('Name', 'Figure 6', 'NumberTitle','off') 

set(gcf, 'Position',  [400 1 800 500]);

kol=10;
kik0=1;

tiledlayout(2,2, 'TileSpacing','Compact');

for i=1:4

instrument1= data{i};


tit=strcat(folder, "/output_data/Scores_rolling_GAS_type_explanatory_inv_z_korr__cont_Burr_", instrument1, '.txt');
cont_Burr=readmatrix(tit);

tit=strcat(folder, "/output_data/Scores_rolling_GAS_type_explanatory_inv_z_korr__BNB_", instrument1, '.txt');
BNB=readmatrix(tit);


tit=strcat(folder, "/output_data/Scores_rolling_GAS_type_explanatory_inv_z_korr__cont_Weibull_", instrument1, '.txt');
cont_Weibull=readmatrix(tit);


tit=strcat(folder, "/output_data/Scores_rolling_GAS_type_explanatory_inv_z_korr__DWeibull_", instrument1, '.txt');
DWeibull=readmatrix(tit);


tit=strcat(folder, "/output_data/Scores_rolling_GAS_type_explanatory_inv_z_korr__DBurr_", instrument1, '.txt');
DBurr=readmatrix(tit);


tit=strcat(folder, "/output_data/Scores_rolling_GAS_type_explanatory_inv_z_korr__GammaGG_", instrument1, '.txt');
cont_GGamma=readmatrix(tit);


tit=strcat(folder, "/output_data/Scores_rolling_GAS_type_explanatory_inv_z_korr__DGammaGG_", instrument1, '.txt');
DGGamma=readmatrix(tit);


threshold=2.5:0.1:15;

nexttile;



plot(threshold(1:kik), cont_Burr(1:kik,kol), '-', 'LineWidth', 1.5, 'color', [0.5 0.5 0.5]);
hold on 
plot(threshold(1:kik), cont_GGamma(1:kik,kol), ':', 'LineWidth', 1.5, 'color', [0.5 0.5 0.5]);
hold on 
plot(threshold(1:kik), cont_Weibull(1:kik,kol), '--', 'LineWidth', 1.5, 'color', [0.5 0.5 0.5]);
hold on 
plot(threshold(kik0:kik), BNB(kik0:kik,kol), '-', 'LineWidth', 1.5, 'color', 'black');
hold on 
plot(threshold(kik0:kik), DBurr(kik0:kik,kol), ':', 'LineWidth', 1.5, 'color', 'black');
hold on 
plot(threshold(kik0:kik), DGGamma(kik0:kik,kol), '--', 'LineWidth', 1.5, 'color', 'black');
hold on 
plot(threshold(kik0:kik), DWeibull(kik0:kik,kol), '-.', 'LineWidth', 1.5, 'color', 'black');


najmn=min((min([cont_Burr(kik0:kik,kol),  cont_GGamma(kik0:kik,kol), cont_Weibull(kik0:kik,kol), BNB(kik0:kik,kol), DGGamma(kik0:kik,kol), DBurr(kik0:kik,kol),  DWeibull(kik0:kik,kol)]))');
najw=max((max([cont_Burr(kik0:kik,kol), cont_GGamma(kik0:kik,kol), cont_Weibull(kik0:kik,kol), BNB(kik0:kik,kol), DGGamma(kik0:kik,kol), DBurr(kik0:kik,kol), DWeibull(kik0:kik,kol)]))');


 axis([2.5 15.0 najmn-0.0005 najw+0.0001]);
 
 
 if i==1
     annotation('textarrow',[0.262 0.262],[0.69 0.5],'LineWidth', 0.5,...
     'String',{'$u$ = 1.35'}, 'FontSize', 12, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
  end
 if i==2
     annotation('textarrow',[0.727 0.727],[0.69 0.5],'LineWidth', 0.5,...
     'String',{'$u$ = 1.61'}, 'FontSize', 12, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
  end
 if i==3
 
     annotation('textarrow',[0.215 0.215],[0.32 0.15],'LineWidth', 0.5,...
     'String',{'$u$ = 1.60'}, 'FontSize', 12, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
 end 

 if i==4
     annotation('textarrow',[0.638 0.638],[0.307 0.15],'LineWidth', 0.5,...
     'String',{'$u$ = 1.60'}, 'FontSize', 12, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
  end 


set(gca,'FontSize',12);

title(strcat(data1{i}, ''), 'FontSize', 14, 'FontName', 'Times New Roman');

a=data1{i};

title(a, 'FontSize', 14, 'FontName', 'Times New Roman');

xtickformat('percentage')



set(gca,'FontSize',12, 'FontName', 'Times New Roman');
if i==3 || i==4
xlabel({'Percentage of negative returns', 'classified as threshold exceedances'}, 'FontSize', 12, 'FontName', 'Times New Roman');
end
ylabel('$S_{QCRPS}^u$ ', 'FontSize', 12, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');

box off 
hold off


end

lh =legend({'$\mathcal{B}$-SPOT', '$\mathcal{GG}$-SPOT', '$\mathcal{W}$-SPOT', '$\mathcal{BNB}$-SPOT', ...
    '$\mathcal{DB}$-SPOT', '$\mathcal{DGG}$-SPOT', '$\mathcal{DW}$-SPOT'},'Location','NorthOutside','Orientation','Horizontal', 'FontSize', 12,  'NumColumns', 2, 'FontName', 'Times New Roman', 'Interpreter','Latex');
lh.Layout.Tile = 'North'; % <----- relative to tiledlayout
legend box off;

print(strcat(folder, '/replicated_results/Figure_6.pdf'), '-dpdf')



%%

% Plot for FZGL 0.99 out of sample 
%

figure('Name', 'Figure 9', 'NumberTitle','off') 

set(gcf, 'Position',  [400 1 800 500]);


kol=31;


tiledlayout(2,2);

for i=1:4

instrument1= data{i};

tit=strcat(folder, "/output_data/Scores_rolling_GAS_type_explanatory_inv_z_korr__cont_Burr_", instrument1, '.txt');
cont_Burr=readmatrix(tit);


tit=strcat(folder, "/output_data/Scores_rolling_GAS_type_explanatory_inv_z_korr__BNB_", instrument1, '.txt');
BNB=readmatrix(tit);

tit=strcat(folder, "/output_data/Scores_rolling_GAS_type_explanatory_inv_z_korr__cont_Weibull_", instrument1, '.txt');
cont_Weibull=readmatrix(tit);


tit=strcat(folder, "/output_data/Scores_rolling_GAS_type_explanatory_inv_z_korr__DWeibull_", instrument1, '.txt');
DWeibull=readmatrix(tit);


tit=strcat(folder, "/output_data/Scores_rolling_GAS_type_explanatory_inv_z_korr__DBurr_", instrument1, '.txt');
DBurr=readmatrix(tit);

tit=strcat(folder, "/output_data/Scores_rolling_GAS_type_explanatory_inv_z_korr__GammaGG_", instrument1, '.txt');
cont_GGamma=readmatrix(tit);

tit=strcat(folder, "/output_data/Scores_rolling_GAS_type_explanatory_inv_z_korr__DGammaGG_", instrument1, '.txt');
DGGamma=readmatrix(tit);


threshold=2.5:0.1:15;
% 
% 

nexttile;


 plot(threshold(1:kik), cont_Burr(1:kik,kol), '-', 'LineWidth', 1.5, 'color', [0.5 0.5 0.5]);
 hold on 
 plot(threshold(1:kik), cont_GGamma(1:kik,kol), ':', 'LineWidth', 1.5, 'color', [0.5 0.5 0.5]);
 hold on 
 plot(threshold(1:kik), cont_Weibull(1:kik,kol), '--', 'LineWidth', 1.5, 'color', [0.5 0.5 0.5]);
hold on 
plot(threshold(kik0:kik), BNB(kik0:kik,kol), '-', 'LineWidth', 1.5, 'color', 'black');
 hold on 
plot(threshold(kik0:kik), DBurr(kik0:kik,kol), ':', 'LineWidth', 1.5, 'color', 'black');
hold on 
plot(threshold(kik0:kik), DGGamma(kik0:kik,kol), '--', 'LineWidth', 1.5, 'color', 'black');
hold on 
plot(threshold(kik0:kik), DWeibull(kik0:kik,kol), '-.', 'LineWidth', 1.5, 'color', 'black');


najmn=min((min([cont_Burr(kik0:kik,kol),  cont_GGamma(kik0:kik,kol), cont_Weibull(kik0:kik,kol), BNB(kik0:kik,kol), DGGamma(kik0:kik,kol), DBurr(kik0:kik,kol),  DWeibull(kik0:kik,kol)]))');
najw=max((max([cont_Burr(kik0:kik,kol), cont_GGamma(kik0:kik,kol), cont_Weibull(kik0:kik,kol), BNB(kik0:kik,kol), DGGamma(kik0:kik,kol), DBurr(kik0:kik,kol), DWeibull(kik0:kik,kol)]))');


 axis([2.5 15.0 najmn-0.0009 najw+0.0007]);

 if i==1
     annotation('textarrow',[0.254 0.254],[0.69 0.52],'LineWidth', 0.5,...
     'String',{'$u$ = 1.35'}, 'FontSize', 12, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
  end
 if i==2
     annotation('textarrow',[0.738 0.738],[0.69 0.52],'LineWidth', 0.5,...
     'String',{'$u$ = 1.61'}, 'FontSize', 12, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
  end
 if i==3
 
     annotation('textarrow',[0.205 0.205],[0.32 0.16],'LineWidth', 0.5,...
     'String',{'$u$ = 1.60'}, 'FontSize', 12, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
 end 

 if i==4
     annotation('textarrow',[0.662 0.662],[0.307 0.16],'LineWidth', 0.5,...
     'String',{'$u$ = 1.60'}, 'FontSize', 12, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');
  end 

set(gca,'FontSize',12);

title(strcat(data1{i}, ''), 'FontSize', 14, 'FontName', 'Times New Roman');

xtickformat('percentage')



set(gca,'FontSize',12, 'FontName', 'Times New Roman');
if i==3 || i==4
xlabel({'Percentage of negative returns', 'classified as threshold exceedances'}, 'FontSize', 12, 'FontName', 'Times New Roman');
end
ylabel('$\overline{FZ0L}^{0.99}$', 'FontSize', 12, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');

box off 

hold off




title(strcat(data1{i}, ''), 'FontSize', 14, 'FontName', 'Times New Roman');

xtickformat('percentage')

set(gca,'FontSize',12, 'FontName', 'Times New Roman');


box off 


hold off

box off 


end

lh =legend({'$\mathcal{B}$-SPOT', '$\mathcal{GG}$-SPOT', '$\mathcal{W}$-SPOT', '$\mathcal{BNB}$-SPOT', ...
    '$\mathcal{DB}$-SPOT', '$\mathcal{DGG}$-SPOT', '$\mathcal{DW}$-SPOT'},'Location','NorthOutside','Orientation','Horizontal', 'FontSize', 12,  'NumColumns', 2, 'FontName', 'Times New Roman', 'Interpreter','Latex');
lh.Layout.Tile = 'North'; % <----- relative to tiledlayout

legend box off;

print(strcat(folder, '/replicated_results/Figure_9.pdf'), '-dpdf')

toc