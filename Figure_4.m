% This script replicates Figure 4 in the article: 
% "When to Be Discrete: The Importance of Time Formulation
% in the Modeling of Extreme Events in Finance" 
% by Katarzyna Bień-Barkowska and Rodrigo Herrera
% Author: Katarzyna Bień-Barkowska

tic;

clc;
clear;

path = fileparts(matlab.desktop.editor.getActiveFilename);


% Set the mean value for the threshold exceedance time

ksi=10;


figure(4);

set(gcf, 'Position',  [400 1 900 500]);

t = tiledlayout(2,2, 'TileSpacing','Compact');


nexttile;

%% The panel (1,1) on the common figure corresponds to the Dweibull/Weibull distribution

x=1:60;


% set the parameter values for the Dweibull/Weibull distribution

alphagg=[1 1 1];
gammagg=[0.3 0.8 1];


for i=1:3

korr= gamma(1+1/gammagg(i));


ksi1=(ksi-0.5)/korr;

score1=...
    (1./(-gammainc(((x-1)./ksi1).^gammagg(i), alphagg(i)) + gammainc( (x./ksi1).^gammagg(i), alphagg(i)))).*...
	((1/gamma(alphagg(i))).*(((x-1)./ksi1).^(gammagg(i).*(alphagg(i)-1))).*exp(-((x-1)./ksi1).^gammagg(i)).*((x-1).^gammagg(i)).*gammagg(i).*(ksi1).^(-gammagg(i))...
	-(1/gamma(alphagg(i))).*((x./ksi1).^(gammagg(i).*(alphagg(i)-1))).*exp(-(x./ksi1).^gammagg(i)).*(x.^gammagg(i)).*gammagg(i).*(ksi1).^(-gammagg(i)));


y=1:100000;



sr_discrete =sum(((1-gammainc(((y-1)./ksi1).^gammagg(i), alphagg(i)))-(1-gammainc(((y)./ksi1).^gammagg(i), alphagg(i)))).*y);


ksi1=(ksi)/korr;

score2= -alphagg(i)*gammagg(i) +gammagg(i)*(x./ksi1).^gammagg(i);


hold on 
if i==1
scatter(x, score1, 4, 'filled', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'black')
hold on        
plot(x, score2, 'black')
end

if i==2
scatter(x, score1, 4, 'filled', 'MarkerEdgeColor', [0.4 .4 .4], 'MarkerFaceColor', [0.4 .4 .4])
hold on        
plot(x, score2, 'color', [0.4 .4 .4])
end


if i==3
scatter(x, score1, 4, 'filled', 'MarkerEdgeColor', [0.7 .7 .7], 'MarkerFaceColor', [0.7 .7 .7])
hold on        
plot(x, score2, 'color', [0.7 .7 .7])
end

end

set(gca,'FontSize',12, 'FontName', 'Times New Roman');

title({'$\mathcal{W}$ and $\mathcal{DW}$ distribution'}, 'FontSize', 14, 'FontName', 'Times New Roman', 'Interpreter','Latex');

xlabel({'Threshold exceedance duration ($x_i$)'}, 'FontSize', 14, 'FontName', 'Times New Roman', 'Interpreter','Latex');
ylabel({'Score ($s_i$)'}, 'FontSize', 14, 'FontName', 'Times New Roman','Interpreter','Latex');

legend({'\gamma=0.3', '', '\gamma=0.8', '', '\gamma=1', ''}, 'location', 'northwest', 'FontSize', 12,  'NumColumns', 1, 'FontName', 'Times New Roman');
legend box off;




nexttile;

%% The panel (1,2) for the DBurr/Burr distribution

% set the parameter values for the DBurr/Burr distribution

kappa=[1.1 0.9 1.2];
sigma2=[1.2 4  7];


for i=1:3

korr= sigma2(i)*beta(sigma2(i)-1/kappa(i), 1+1/kappa(i));

ksi1=(ksi-0.5)/korr;

y=1:100000;

sr_discrete = sum(((1+((y-1)./ksi1).^kappa(i)).^(-sigma2(i))-(1+((y)./ksi1).^kappa(i)).^(-sigma2(i))).*y);



tail_index=kappa(i)*sigma2(i);

score1=((1./(((1+((x-1)./ksi1).^kappa(i)).^(-sigma2(i)))-((1+(x./ksi1).^kappa(i)).^(-sigma2(i)))))...
.*((sigma2(i)*kappa(i)*(1+((x-1)./ksi1).^kappa(i)).^(-sigma2(i)-1)).*((x-1)./ksi1).^kappa(i)...
	- (sigma2(i)*kappa(i)*(1+((x)./ksi1).^kappa(i)).^(-sigma2(i)-1)).*((x)./ksi1).^kappa(i)));


ksi1=(ksi)/korr;
score2= -(kappa(i) - kappa(i)*sigma2(i)*(x./ksi1).^kappa(i))./((x/ksi1).^kappa(i) + 1);

hold on 
if i==1
scatter(x, score1, 4, 'filled', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'black')
hold on        
plot(x, score2, 'black')
end

if i==2
scatter(x, score1, 4, 'filled', 'MarkerEdgeColor', [0.4 .4 .4], 'MarkerFaceColor', [0.4 .4 .4])
hold on        
plot(x, score2, 'color', [0.4 .4 .4])
end


if i==3
scatter(x, score1, 4, 'filled', 'MarkerEdgeColor', [0.7 .7 .7], 'MarkerFaceColor', [0.7 .7 .7])
hold on        
plot(x, score2, 'color', [0.7 .7 .7])
end

end

set(gca,'FontSize',12, 'FontName', 'Times New Roman');

title({'$\mathcal{B}$ and $\mathcal{DB}$ distribution'}, 'FontSize', 14, 'FontName', 'Times New Roman', 'Interpreter','Latex');

xlabel({'Threshold exceedance duration ($x_i$)'}, 'FontSize', 14, 'FontName', 'Times New Roman', 'Interpreter','Latex');
ylabel({'Score ($s_i$)'}, 'FontSize', 14, 'FontName', 'Times New Roman','Interpreter','Latex');

legend({'\kappa=1.1; \zeta=1.2', '', '\kappa=0.9;  \zeta=4', '', '\kappa=1.2;  \zeta=7', ''}, 'location', 'southeast', 'FontSize', 12,  'NumColumns', 1, 'FontName', 'Times New Roman');
legend box off;




nexttile;

%% The panel (2,1) for the DGGamma/Gamma distribution

x=1:60;
%

ksi=10;


% set the parameter values for the DGGamma/GGamma distribution

alphagg=[4 4 4];
gammagg=[0.3 0.7 1];

for i=1:3


korr= gamma(alphagg(i)+1/gammagg(i))./gamma(alphagg(i));

ksi1=(ksi-0.5)/korr;

score1=...
    (1./(-gammainc(((x-1)./ksi1).^gammagg(i), alphagg(i)) + gammainc( (x./ksi1).^gammagg(i), alphagg(i)))).*...
	((1/gamma(alphagg(i))).*(((x-1)./ksi1).^(gammagg(i).*(alphagg(i)-1))).*exp(-((x-1)./ksi1).^gammagg(i)).*((x-1).^gammagg(i)).*gammagg(i).*(ksi1).^(-gammagg(i))...
	-(1/gamma(alphagg(i))).*((x./ksi1).^(gammagg(i).*(alphagg(i)-1))).*exp(-(x./ksi1).^gammagg(i)).*(x.^gammagg(i)).*gammagg(i).*(ksi1).^(-gammagg(i)));

ksi1=(ksi)/korr;

score2= -alphagg(i)*gammagg(i) +gammagg(i)*(x./ksi1).^gammagg(i);

hold on 
if i==1
scatter(x, score1, 4, 'filled', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'black')
hold on        
plot(x, score2, 'black')
end

if i==2
scatter(x, score1, 4, 'filled', 'MarkerEdgeColor', [0.4 .4 .4], 'MarkerFaceColor', [0.4 .4 .4])
hold on        
plot(x, score2, 'color', [0.4 .4 .4])
end


if i==3
scatter(x, score1, 4, 'filled', 'MarkerEdgeColor', [0.7 .7 .7], 'MarkerFaceColor', [0.7 .7 .7])
hold on        
plot(x, score2, 'color', [0.7 .7 .7])
end

end

set(gca,'FontSize',12, 'FontName', 'Times New Roman');

title({'$ \mathcal{GG}$ and $ \mathcal{DGG} $ distribution'}, 'FontSize', 14, 'FontName', 'Times New Roman', 'Interpreter','Latex');

xlabel({'Threshold exceedance duration ($x_i$)'}, 'FontSize', 14, 'FontName', 'Times New Roman', 'Interpreter','Latex');
ylabel({'Score ($s_i$)'}, 'FontSize', 14, 'FontName', 'Times New Roman','Interpreter','Latex');

legend({'\nu=4; \gamma=0.3', '', '\nu=4;  \gamma=0.7', '', '\nu=4;  \gamma=1', ''}, 'location', 'northwest', 'FontSize', 12,  'NumColumns', 1, 'FontName', 'Times New Roman');
legend box off;





nexttile;

%% The panel (2,2) for the BNB distribution

x=1:60;
%
ksi=9;


% set the parameter values for the BNB distribution

alpha=[1.5 3.6 200];
r=[0.8 0.8 0.8];

for i=1:3

korr=1;

ksi1=ksi/korr;

gammaBNB=(alpha(i)-1)/r(i);

score1=...
gammaBNB*ksi1*(psi(gammaBNB*ksi1+x-1)+psi(gammaBNB*ksi1+alpha(i))+...
	       - psi(gammaBNB*ksi1+alpha(i)+r(i)+x-1)-psi(gammaBNB*ksi1));

y=1:100;





g=(gamma(y-1+r(i))./(gamma(y).*gamma(r(i)))) ...
    .*(beta(alpha(i)+r(i), ((alpha(i)-1)*ksi/r(i))+y-1)./beta(alpha(i), (alpha(i)-1)*ksi/r(i)));

discrete_sum=sum(((gamma(y-1+r(i))./(gamma(y)*gamma(r(i)))) ...
    .*(beta(alpha(i)+r(i), ((alpha(i)-1)*ksi/r(i))+y-1)./beta(alpha(i), (alpha(i)-1)*ksi/r(i)))).*y);



hold on 
if i==1
scatter(x, score1, 4, 'filled', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'black')

end

if i==2
scatter(x, score1, 4, 'filled', 'MarkerEdgeColor', [0.4 .4 .4], 'MarkerFaceColor', [0.4 .4 .4])

end


if i==3
scatter(x, score1, 4, 'filled', 'MarkerEdgeColor', [0.7 .7 .7], 'MarkerFaceColor', [0.7 .7 .7])

end

end

set(gca,'FontSize',12, 'FontName', 'Times New Roman');

title({'$\mathcal{BNB}$ distribution'}, 'FontSize', 14, 'FontName', 'Times New Roman', 'Interpreter', 'Latex');

xlabel({'Threshold exceedance duration ($x_i$)'}, 'FontSize', 14, 'FontName', 'Times New Roman', 'Interpreter','Latex');
ylabel({'Score ($s_i$)'}, 'FontSize', 14, 'FontName', 'Times New Roman','Interpreter','Latex');

leg=legend({'\tau=1.5; r=0.8', '\tau=3.6; r=0.8', '\tau=200; r=0.8'}, 'location', 'northwest', 'FontSize', 12,  'NumColumns', 1, 'FontName', 'Times New Roman');
legend box off;


print(strcat(path, '/replicated_results/Figure_4.pdf'), '-dpdf')

toc