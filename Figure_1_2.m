% This script replicates Figure 1 and Figure 2 in the article: 
% "When to Be Discrete: The Importance of Time Formulation
% in the Modeling of Extreme Events in Finance" 
% by Katarzyna Bień-Barkowska and Rodrigo Herrera


tic;
clc;
clear;


% set the path to the place where the m-file is opened

if(~isdeployed)
  cd(fileparts(matlab.desktop.editor.getActiveFilename));
end

path = fileparts(matlab.desktop.editor.getActiveFilename);

K={strcat(path, '\data\DowJones.xlsx'), ...
    strcat(path, '\data\Nasdaq.xlsx'),...
    strcat(path, '\data\SP500.xlsx'), ...
    strcat(path, '\data\Wilshire.xlsx')};

titles={'DowJones', 'NASDAQ', 'SP500', 'Wilshire'}; 

quantile_orders=[0.05 0.07 0.1];

% The loop over the indexes 

for i=1:4


if i==1

figure('Name','Figure 1', 'NumberTitle','off');

tiledlayout(2,1);

set(gcf, 'Position',  [200 	100 1000 400]);

data = readtable(K{i});

dates = (data(:,1));
dates = datetime(dates{:,:});

returns=(data(:,14));
returns=returns{:,:};

prices=data(:,6);
prices=prices{:,:};

A1=timetable(dates, prices, returns, 'rowTimes', dates);

A1.returns=A1.returns*100;


S = timerange('01-Jan-1981','29-Dec-2022');

A2=A1(S,:);
A3=A2(:,:);

q1=quantile(A3.returns, quantile_orders(1));
A3.extremes1= (A3.returns<q1);
A3.peaks1= -(A3.returns<q1).*(A3.returns-q1);

q2=quantile(A3.returns, quantile_orders(2));
A3.extremes2= (A3.returns<q2);
A3.peaks2= -(A3.returns<q2).*(A3.returns-q2);

q3=quantile(A3.returns, quantile_orders(3));
A3.extremes3= (A3.returns<q3);
A3.peaks3= -(A3.returns<q3).*(A3.returns-q3);


nexttile;
plot(A3.dates, -A3.returns, 'Color', 'black', 'LineWidth', 1.2);
title(append('Dow Jones daily negative log returns ($y_t$)'),'FontName', 'Times New Roman', 'FontSize', 14, 'Interpreter', 'Latex');

set(gca,'FontName', 'Times New Roman', 'FontSize', 12);

xticks(datetime('02-Jan-1981') : calyears(2) : datetime('29-Dec-2022'));
xtickformat('yyyy');
box off;
grid on;


nexttile;
plot(A3.dates, A3.peaks1, 'Color', 'black', 'LineWidth', 1.2);
title(append('Times & magnitudes ', 'of the negative returns over the 95th percentile'),'FontName', 'Times New Roman', 'FontSize', 14);
set(gca,'FontName', 'Times New Roman', 'FontSize', 12);

xticks(datetime('02-Jan-1981') : calyears(2) : datetime('31-Dec-2022'));
xtickformat('yyyy');
box off;
% 
hold off;


set(gcf,'PaperPositionMode','auto')
print(strcat(path, '/replicated_results/Figure_1.pdf'), '-dpdf','-bestfit')
end

%end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% constructing & storing threshold exceedance durations for tau=0.05
index_extreme_returns1=find(A3.extremes1==1);

durations_05 = [index_extreme_returns1(1); index_extreme_returns1(2:end)-index_extreme_returns1(1:end-1)];
sizes_05 = A3.peaks1(index_extreme_returns1);

eval([strcat(titles{i},'_sizes_05') '=sizes_05']);
eval([strcat(titles{i},'_durations_05') '=durations_05']);


%% constructing & storing f. histogram for the exceedance durations for tau=0.05

freq_05 = zeros(max(durations_05),1);
means_sizes_05 = zeros(max(durations_05),1);

for j=1:(max(durations_05))

    freq_05(j)=sum(durations_05==j)/length(durations_05);
    means_sizes_05(j)=mean(sizes_05(durations_05==j));
end

eval([strcat(titles{i},'_freq_hist_05') '= freq_05']);
eval([strcat(titles{i},'_means_sizes_05') '= means_sizes_05']);

%% constructing threshold exceedance durations for tau=0.07

index_extreme_returns2=find(A3.extremes2==1);

durations_07 = [index_extreme_returns2(1); index_extreme_returns2(2:end)-index_extreme_returns2(1:end-1)];

sizes_07 = A3.peaks2(index_extreme_returns2);

eval([strcat(titles{i},'_sizes_07') '=sizes_07']);

eval([strcat(titles{i},'_durations_07') '=durations_07']);


%% constructing f. histogram for the exceedance durations for tau=0.05

freq_07 = zeros(max(durations_07),1);
means_sizes_07 = zeros(max(durations_07),1);

for j=1:(max(durations_07))

    freq_07(j)=sum(durations_07==j)/length(durations_07);
    means_sizes_07(j)=mean(sizes_07(durations_07==j));
end

eval([strcat(titles{i},'_freq_hist_07') '= freq_07']);
eval([strcat(titles{i},'_means_sizes_07') '= means_sizes_07']);


%% constructing threshold exceedance durations for tau=0.1
index_extreme_returns3=find(A3.extremes3==1);

durations_1 = [index_extreme_returns3(1); index_extreme_returns3(2:end)-index_extreme_returns3(1:end-1)];
sizes_1 = A3.peaks3(index_extreme_returns3);

eval([strcat(titles{i},'_sizes_1') '=sizes_1']);


eval([strcat(titles{i},'_durations_1') '=durations_1']);

%% constructing f. histogram for the exceedance durations for tau=0.05

freq_1 = zeros(max(durations_1),1);
means_sizes_1 = zeros(max(durations_1),1);

for j=1:(max(durations_1))

    freq_1(j)=sum(durations_1==j)/length(durations_1);
    means_sizes_1(j)=mean(sizes_1(durations_1==j));
end

eval([strcat(titles{i},'_freq_hist_1') '= freq_1']);
eval([strcat(titles{i},'_means_sizes_1') '= means_sizes_1']);


end 
% end of i loop




%% 3-D Figure for the threshold exceedance durations 



figure('Name','Figure 2, left panel', 'NumberTitle','off');

set(gcf, 'Position',  [400 1 800 500]);

maxim=40; % set the maximum value for the y (durations)
tiledlayout(1,1);

N=[DowJones_freq_hist_05(1:maxim)'; DowJones_freq_hist_07(1:maxim)'; DowJones_freq_hist_1(1:maxim)'; ...
   NASDAQ_freq_hist_05(1:maxim)'; NASDAQ_freq_hist_07(1:maxim)'; NASDAQ_freq_hist_1(1:maxim)';...
   SP500_freq_hist_05(1:maxim)'; SP500_freq_hist_07(1:maxim)'; SP500_freq_hist_1(1:maxim)';...
   Wilshire_freq_hist_05(1:maxim)'; Wilshire_freq_hist_07(1:maxim)'; Wilshire_freq_hist_1(1:maxim)'];

N=N*100;

h =bar3(N', 0.3);

hh = get(h(3),'parent');
set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
set(gca,'xtick',1:1:12,'ytick',1:10:maxim);
set(hh,'xticklabel',{'Dow Jones 5%'; 'Dow Jones 7%'; 'Dow Jones 10%'; 'NASDAQ 5%'; 'NASDAQ 7%'; 'NASDAQ 10%';...
    'S&P 500 5%'; 'S&P 500 7%'; 'S&P 500 10%'; 'Wilshire 5000 5%'; 'Wilshire 5000 7%'; 'Wilshire 5000 10%'});


pbaspect([0.8903 0.6903 0.3903]) ;
 

set(gca, 'YLim', [0 maxim+1]);

ylabel({'Inter-exceedance time'}, 'FontName', 'Times New Roman', 'FontSize', 12);  
zlabel("Frequency (%)", 'FontName', 'Times New Roman', 'FontSize', 12);

colormap(gray);
pos = get(gca, 'Position');
   pos(1) = 0.05;
   pos(3) = 0.95;
   set(gca, 'Position', pos);

v = [1.5 -2 2];
 [caz,cel] = view(v);

set(gcf,'PaperPositionMode','auto')
print(strcat(path, '/replicated_results/Figure_2_left_panel.pdf'), '-dpdf','-bestfit')

%% 3-D Figure for the average threshold exceedance sizes

figure('Name','Figure 2, right panel', 'NumberTitle','off');
maxim=15;
tiledlayout(1,1);

N=[DowJones_means_sizes_05(1:maxim)'; DowJones_means_sizes_07(1:maxim)'; DowJones_means_sizes_1(1:maxim)'; ...
   NASDAQ_means_sizes_05(1:maxim)'; NASDAQ_means_sizes_07(1:maxim)'; DowJones_means_sizes_1(1:maxim)';...
   SP500_means_sizes_05(1:maxim)'; SP500_means_sizes_07(1:maxim)'; SP500_means_sizes_1(1:maxim)';...
   Wilshire_means_sizes_05(1:maxim)'; Wilshire_means_sizes_07(1:maxim)'; Wilshire_means_sizes_1(1:maxim)'];



set(gcf, 'Position',  [400 1 800 500]);


h =bar3(N', 0.3);

hh = get(h(3),'parent');
set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
set(gca,'xtick',1:1:12,'ytick',1:5:maxim);
set(hh,'xticklabel',{'Dow Jones 5%'; 'Dow Jones 7%'; 'Dow Jones 10%'; 'NASDAQ 5%'; 'NASDAQ 7%'; 'NASDAQ 10%';...
    'S&P 500 5%'; 'S&P 500 7%'; 'S&P 500 10%'; 'Wilshire 5000 5%'; 'Wilshire 5000 7%'; 'Wilshire 5000 10%'});

colormap(gray);
pbaspect([0.8903 0.6903 0.3903]) ;


set(gca, 'YLim', [0 maxim+1]);

label_h = ylabel({'   Inter-exceedance time'}, 'FontName', 'Times New Roman', 'FontSize', 12);  
label_h.Position(2);



zlabel({'Average magnitude' 'of a threshold exceedance'}, 'FontName', 'Times New Roman', 'FontSize', 12);


pos = get(gca, 'Position');
   pos(1) = 0.05;
   pos(3) = 0.95;
   set(gca, 'Position', pos);

v = [1.5 -2 2];
 [caz,cel] = view(v);

set(gcf,'PaperPositionMode','auto')
print(strcat(path, '/replicated_results/Figure_2_right_panel.pdf'), '-dpdf','-bestfit')

toc;