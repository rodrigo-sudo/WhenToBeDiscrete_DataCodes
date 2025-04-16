
% This script replicates subpanels in Figure 3 of the manuscript: 
% "When to Be Discrete: The Importance of Time Formulation
% in the Modeling of Extreme Events in Finance" 
% by Katarzyna Bień-Barkowska and Rodrigo Herrera
% Author: Katarzyna Bień-Barkowska

tic;

clc;
clear;
path = fileparts(matlab.desktop.editor.getActiveFilename);



for kj=1:3

rozklad=kj;


if rozklad==1

figure('Name','Figure 3, panel in row 1, column 1', 'NumberTitle','off');

set(gcf, 'Position',  [800 200 400 300]);


A=[ 0.7 0.9 1 1.7];

linia=1;

while linia<=4

gammaW=A(1,linia);


n=30;


korr=gamma(1+1/gammaW);


dur=0.1:0.01:n;


ksi1=10/korr;

	
intensity=(exp(log(gammaW./dur) + (gammaW*log(dur./ksi1)) - (dur./ksi1).^gammaW))./exp(-((1/ksi1.*(dur)).^gammaW));

hold on

if linia==1
plot(dur, intensity,'LineWidth',1.5,'LineStyle',':', 'Color', [0 0 0]);
elseif linia==2
plot(dur, intensity,'LineWidth',1.5,'LineStyle','-', 'Color', [0.2 0.2 0.2]);
elseif linia==3
plot(dur, intensity,'LineWidth',1.5,'LineStyle','-', 'Color', [0.5 0.5 0.5]);
elseif linia==4
plot(dur, intensity,'LineWidth',1.5,'LineStyle','-', 'Color', [0.8 0.8 0.8]);
end 

set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
ylabel('$h(t \mid \mathcal{F}_{t_{i-1}})$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);
xlabel('$t - t_{i-1}$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);
title('$\mathcal{W}$ distribution', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);


linia=linia+1;

end


 legend({'$\gamma=0.7$', '$\gamma=0.9$', '$\gamma=1$', '$\gamma=1.7$'}, 'location', 'northwest', 'Interpreter', 'Latex',...
     'FontSize', 12);
 

legend box off;
box off;


set(gcf,'PaperPositionMode','auto')
print(strcat(path, '/replicated_results/Figure_3_row_1_col_1.pdf'), '-dpdf')

hold off;
% ===================================================================== %


figure('Name','Figure 3, panel in row 1, column 2', 'NumberTitle','off');

set(gcf, 'Position',  [800 200 400 300]);
linia=1;
while linia<=4

gammaW=A(1,linia);

n=30;


ksi1=10/korr;


dur=1:1:n;

ksi1=9.5/korr;

	
intensity=(exp(-((1/ksi1.*(dur-1)).^gammaW))-exp(-((1/ksi1.*(dur-1+1)).^gammaW)))./exp(-((1/ksi1.*(dur-1)).^gammaW));


hold on

if linia==1
scatter(dur, intensity, 'MarkerEdgeColor', [0 0 0]);

elseif linia==2
scatter(dur, intensity, 'filled', 'MarkerFaceColor', [0.2 0.2 0.2]);
elseif linia==3
scatter(dur, intensity, 'filled', 'MarkerFaceColor', [0.5 0.5 0.5]);
elseif linia==4
scatter(dur, intensity, 'filled', 'MarkerFaceColor', [0.8 0.8 0.8]);
end 


set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
ylabel('$h(t \mid \mathcal{F}_{t_{i-1}})$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);
xlabel('$t - t_{i-1}$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);
title('Right shifted $\mathcal{DW}$ distribution', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);


linia=linia+1;

end

 legend({'$\gamma=0.7$', '$\gamma=0.9$', '$\gamma=1$', '$\gamma=1.7$'}, 'location', 'northwest', 'Interpreter', 'Latex',...
     'FontSize', 12);
 

legend box off;
box off;



set(gcf,'PaperPositionMode','auto')
print(strcat(path, '/replicated_results/Figure_3_row_1_col_2.pdf'), '-dpdf')
hold off;
% ===================================================================== %


elseif rozklad==2

figure('Name','Figure 3, panel in row 2, column 1', 'NumberTitle','off');

set(gcf, 'Position',  [800 200 400 300]);


A=[ 0.9 1.4 1.8 1.9 ;  3 1.3 0.7 3 ];

linia=1;

while linia<=4

kappa=A(1,linia);
sigma2=A(2,linia);

n=30;


korr= sigma2*beta(sigma2-1/kappa, 1+1/kappa);


dur=0.1:0.01:n;


ksi1=10/korr;

pdf = 	exp(log(kappa) + log(sigma2)-log(ksi1) + (kappa-1)*log(dur./ksi1)...
  - (sigma2+1)*log(1+(dur./ksi1).^kappa));
	

intensity = ((kappa*sigma2./ksi1).*(dur./ksi1).^(kappa-1))./(1+((dur./ksi1).^kappa));


hold on

if linia==1
plot(dur, intensity,'LineWidth',1.5,'LineStyle',':', 'Color', [0 0 0]);
elseif linia==2
plot(dur, intensity,'LineWidth',1.5,'LineStyle','-', 'Color', [0.2 0.2 0.2]);
elseif linia==3
plot(dur, intensity,'LineWidth',1.5,'LineStyle','-', 'Color', [0.5 0.5 0.5]);
elseif linia==4
plot(dur, intensity,'LineWidth',1.5,'LineStyle','-', 'Color', [0.8 0.8 0.8]);
end 

set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
ylabel('$h(t \mid \mathcal{F}_{t_{i-1}})$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);
xlabel('$t - t_{i-1}$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);
title('$\mathcal{B}$ distribution', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);


linia=linia+1;

end


 legend({'$\kappa=0.9$, $\zeta=3$', '$\kappa=1.4$, $\zeta=1.3$', '$\kappa=1.8$, $\zeta=0.7$', '$\kappa=1.9$, $\zeta=3$'}, 'location', 'best', 'Interpreter', 'Latex',...
     'FontSize', 12);
 

legend box off;
box off;



set(gcf,'PaperPositionMode','auto')
print(strcat(path, '/replicated_results/Figure_3_row_2_col_1.pdf'), '-dpdf')
hold off;
% ===================================================================== %

figure('Name','Figure 3, panel in row 2, column 2', 'NumberTitle','off');

set(gcf, 'Position',  [800 200 400 300]);

linia=1;
while linia<=4

kappa=A(1,linia);
sigma2=A(2,linia);

n=30;



korr= sigma2*beta(sigma2-1/kappa, 1+1/kappa);


dur=1:1:n;

ksi1=9.5/korr;

	
intensity= (((1+((dur-1)./ksi1).^kappa).^(-sigma2))-((1+((dur+1-1)./ksi1).^kappa).^(-sigma2)))./((1+((dur-1)./ksi1).^kappa).^(-sigma2));	

"średnia:";

x=1:10000;

sr_discrete= sum(((1+((x-1)./ksi1).^kappa).^(-sigma2)-(1+((x)./ksi1).^kappa).^(-sigma2)).*x);
sr_discrete1 = sum(((1+((x-1)./ksi1).^kappa).^(-sigma2)));


hold on

if linia==1
scatter(dur, intensity, 'MarkerEdgeColor', [0 0 0]);

elseif linia==2
scatter(dur, intensity, 'filled', 'MarkerFaceColor', [0.2 0.2 0.2]);
elseif linia==3
scatter(dur, intensity, 'filled', 'MarkerFaceColor', [0.5 0.5 0.5]);
elseif linia==4
scatter(dur, intensity, 'filled', 'MarkerFaceColor', [0.8 0.8 0.8]);
end 

set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
ylabel('$h(t \mid \mathcal{F}_{t_{i-1}})$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);
xlabel('$t - t_{i-1}$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);
ylim([0 0.3])
title('Right shifted $\mathcal{DB}$ distribution', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);


linia=linia+1;

end


 legend({'$\kappa=0.9$, $\zeta=3$', '$\kappa=1.4$, $\zeta=1.3$', '$\kappa=1.8$, $\zeta=0.7$', '$\kappa=1.9$, $\zeta=3$'}, 'location', 'best', 'Interpreter', 'Latex',...
     'FontSize', 12);
 

legend box off;
box off;




set(gcf,'PaperPositionMode','auto')
print(strcat(path, '/replicated_results/Figure_3_row_2_col_2.pdf'), '-dpdf')
hold off;
% ===================================================================== %


elseif rozklad==3

figure('Name','Figure 3, panel in row 3, column 1', 'NumberTitle','off');

set(gcf, 'Position',  [800 200 400 300]);

A=[ 0.35 0.4 0.7 0.9 ;  4 3.5 2 1 ];

linia=1;

while linia<=4

gammaGG=A(1,linia);
alphaGG=A(2,linia);

n=30;

sr_gam=gamma(alphaGG+1/gammaGG)/gamma(alphaGG);


dur=0.1:0.01:n;

ksi=10;

ksi1=ksi/sr_gam;



intensity=(gammaGG/gamma(alphaGG))*(ksi1^(-1)).*((dur./ksi1).^(gammaGG*alphaGG-1)).*exp(-(dur./ksi1).^gammaGG)./(1-gammainc((dur./ksi1).^gammaGG, alphaGG));

hold on

if linia==1
plot(dur, intensity,'LineWidth',1.5,'LineStyle',':', 'Color', [0 0 0]);
elseif linia==2
plot(dur, intensity,'LineWidth',1.5,'LineStyle','-', 'Color', [0.2 0.2 0.2]);
elseif linia==3
plot(dur, intensity,'LineWidth',1.5,'LineStyle','-', 'Color', [0.5 0.5 0.5]);
elseif linia==4
plot(dur, intensity,'LineWidth',1.5,'LineStyle','-', 'Color', [0.8 0.8 0.8]);
end 

set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
ylabel('$h(t \mid \mathcal{F}_{t_{i-1}})$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);
xlabel('$t - t_{i-1}$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);
title('$\mathcal{GG}$ distribution', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);


linia=linia+1;

end


 legend({'$\gamma=0.35$, $\nu=4$', '$\gamma=0.4$, $\nu=3.5$', '$\gamma=0.7$, $\nu=2$', '$\gamma=0.9$, $\nu=1$'}, 'location', 'best', 'Interpreter', 'Latex',...
     'FontSize', 12);
 

legend box off;
box off;


set(gcf,'PaperPositionMode','auto')
print(strcat(path, '/replicated_results/Figure_3_row_3_col_1.pdf'), '-dpdf')
hold off;

% ===================================================================== %


figure('Name','Figure 3, panel in row 3, column 2', 'NumberTitle','off');

set(gcf, 'Position',  [800 200 400 300]);
linia=1;
while linia<=4
 
gammaGG=A(1,linia);
alphaGG=A(2,linia);

n=30;

sr_gam=gamma(alphaGG+1/gammaGG)/gamma(alphaGG);


dur=1:1:30;

ksi=10;

ksi1=(ksi-0.5)/sr_gam;


intensity=((1-gammainc(((dur-1)./ksi1).^gammaGG, alphaGG))-(1-gammainc((dur./ksi1).^gammaGG, alphaGG)))./(1-gammainc(((dur-1)./ksi1).^gammaGG, alphaGG));


hold on

if linia==1
scatter(dur, intensity, 'MarkerEdgeColor', [0 0 0]);

elseif linia==2
scatter(dur, intensity, 'filled', 'MarkerFaceColor', [0.2 0.2 0.2]);
elseif linia==3
scatter(dur, intensity, 'filled', 'MarkerFaceColor', [0.5 0.5 0.5]);
elseif linia==4
scatter(dur, intensity, 'filled', 'MarkerFaceColor', [0.8 0.8 0.8]);
end 


set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
ylabel('$h(t \mid \mathcal{F}_{t_{i-1}})$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);
xlabel('$t - t_{i-1}$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);

title('Right shifted $\mathcal{DGG}$ distribution', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);



linia=linia+1;

end


legend({'$\gamma=0.35$, $\nu=4$', '$\gamma=0.4$, $\nu=3.5$', '$\gamma=0.7$, $\nu=2$', '$\gamma=0.9$, $\nu=1$'}, 'location', 'best', 'Interpreter', 'Latex',...
     'FontSize', 12);

legend box off;
box off;



print(strcat(path, '/replicated_results/Figure_3_row_3_col_2.pdf'), '-dpdf')
hold off;

% ===================================================================== %


end



end




toc










