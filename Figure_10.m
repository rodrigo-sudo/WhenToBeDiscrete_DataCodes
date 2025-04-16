
% This script replicates Figure 10 in the article: 
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


folder = fileparts(matlab.desktop.editor.getActiveFilename);


instr0='DowJones';
instr1='NASDAQ';
instr2='SP500';
instr3='Wilshire';
instr4='FTSE';

data={instr0, instr1, instr2, instr3, instr4};

figure(6);
% 
set(gcf, 'Position',  [50 10 1600  800]);

t = tiledlayout(3,4, 'TileSpacing', 'compact');

for i=1:4


nexttile;

instrument1= data{i};

G={strcat(folder, '/output_data/FZ0_Loss_095_', instrument1, '_rolling_long.txt')};
clear data1;
data1 = readtable(G{1});
data1=table2array(data1);

data1=[data1(:,1:14) data1(:,16) data1(:,18)];




minimum=min(mean(data1));


schodki = (mean(data1)-minimum);


b=bar(schodki);
set(gca,'FontSize',12);

if i==1
title(["Dow Jones", "\alpha = 0.975"],'FontSize', 12)
end
if i==2
title(["NASDAQ", "\alpha = 0.975"],'FontSize', 12)
end
if i==3
title(["S&P 500", "\alpha = 0.975"],'FontSize', 12)
end
if i==4
title(["Wilshire 5000", "\alpha = 0.975"],'FontSize', 12)
end

xlabel("",'FontSize', 12)
b.FaceColor = [0.7 0.7 0.7];

[B, I]=sort(schodki);
K=[schodki;B;I;1:16];
K=sortrows(K',3)';
tytuly=K(4,:);

text(1:16, schodki, num2cell(tytuly), 'HorizontalAlignment','center', 'VerticalAlignment','bottom',...
    'FontSize', 12, 'FontName', 'Times New Roman', 'Color', 'black')


xtickangle(90)

set(gca, 'Xticklabel',[], 'FontName', 'Times New Roman', 'FontSize', 12);
box off;

end


for i=1:4

nexttile;

instrument1= data{i};


G={strcat(folder, '/output_data/FZ0_Loss_0975_', instrument1, '_rolling_long.txt')};

clear data1;
data1 = readtable(G{1});
data1=table2array(data1);

data1=[data1(:,1:14) data1(:,16) data1(:,18)];


minimum=min(mean(data1));


schodki = (mean(data1)-minimum);


b=bar(schodki);
set(gca,'FontSize',12);

if i==1
title(["Dow Jones", "\alpha = 0.975"],'FontSize', 12)
end
if i==2
title(["NASDAQ", "\alpha = 0.975"],'FontSize', 12)
end
if i==3
title(["S&P 500", "\alpha = 0.975"],'FontSize', 12)
end
if i==4
title(["Wilshire 5000", "\alpha = 0.975"],'FontSize', 12)
end

xlabel("",'FontSize', 12)
if i==1
ylabel("Score difference",'FontSize', 12)
end
b.FaceColor = [0.7 0.7 0.7];


[B, I]=sort(schodki);
K=[schodki;B;I;1:16];
K=sortrows(K',3)';
tytuly=K(4,:);
text(1:16, schodki, num2cell(tytuly), 'HorizontalAlignment','center', 'VerticalAlignment','bottom',...
    'FontSize', 12, 'FontName', 'Times New Roman', 'Color', 'black')


xtickangle(90)

set(gca, 'Xticklabel',[], 'FontName', 'Times New Roman', 'FontSize', 12);
box off;

end
 
%%

for i=1:4

nexttile;

instrument1= data{i};

G={strcat(folder, '/output_data/FZ0_Loss_099_', instrument1, '_rolling_long.txt')};

clear data1;
data1 = readtable(G{1});
data1=table2array(data1);

data1=[data1(:,1:14) data1(:,16) data1(:,18)];


minimum=min(mean(data1));


schodki = (mean(data1)-minimum);

b=bar(schodki);
set(gca,'FontSize',12);

if i==1
title(["Dow Jones", "\alpha = 0.975"],'FontSize', 12)
end
if i==2
title(["NASDAQ", "\alpha = 0.975"],'FontSize', 12)
end
if i==3
title(["S&P 500", "\alpha = 0.975"],'FontSize', 12)
end
if i==4
title(["Wilshire 5000", "\alpha = 0.975"],'FontSize', 12)
end

xlabel("",'FontSize', 12)
b.FaceColor = [0.7 0.7 0.7];

[B, I]=sort(schodki);
K=[schodki;B;I;1:16];
K=sortrows(K',3)';
tytuly=K(4,:);
text(1:16, schodki, num2cell(tytuly), 'HorizontalAlignment','center', 'VerticalAlignment','bottom',...
    'FontSize', 12, 'FontName', 'Times New Roman', 'Color', 'black')



set(gca, 'XTick', [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 ])
xtickangle(90)
set(gca, 'XTickLabel', {'$\mathcal{B}$-RSPOT' '$\mathcal{B}$-SPOT' '$\mathcal{GG}$-RSPOT' ...
    '$\mathcal{GG}$-SPOT' ...
    '$\mathcal{W}$-RSPOT' '$\mathcal{W}$-SPOT' ...
    '$\mathcal{DB}$-RSPOT' '$\mathcal{DB}$-SPOT' ...
    '$\mathcal{DGG}$-RSPOT' '$\mathcal{DGG}$-SPOT'...
    '$\mathcal{DW}$-RSPOT' '$\mathcal{DW}$-SPOT' '$\mathcal{BNB}$-RSPOT' '$\mathcal{BNB}$-SPOT' 'Gaussian GARCH' 'Skew t GARCH'}, ...
    'TickLabelInterpreter', 'Latex')
set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
box off;

end
% 
set(gcf,'PaperPositionMode','auto', 'PaperOrientation', 'landscape')
print(strcat(folder, '/replicated_results/Figure_10.pdf'), '-dpdf', '-bestfit')

toc