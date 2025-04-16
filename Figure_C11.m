
% This script replicates Figure C.11 (Appendix C) in the article: 
% "When to Be Discrete: The Importance of Time Formulation
% in the Modeling of Extreme Events in Finance" 
% by Katarzyna Bień-Barkowska and Rodrigo Herrera
% Author: Katarzyna Bień-Barkowska


tic
clc;
clear;

path = fileparts(matlab.desktop.editor.getActiveFilename);

for rozklad=1:3


if rozklad==1

figure('Name','Figure C11, panel in row 1, column 1', 'NumberTitle','off');

set(gcf, 'Position',  [800 200 400 300]);


A=[ 0.7 0.9 1 1.7];

linia=1;

while linia<=4

gammaW=A(1,linia);


n=30;

korr=gamma(1+1/gammaW);


dur=0.1:0.01:n;


ksi1=10/korr;

pdf = 	exp((log(gammaW./dur)) + gammaW*log(dur./ksi1) - (dur./ksi1).^gammaW) ;
	

hold on

if linia==1
plot(dur, pdf,'LineWidth',1.5,'LineStyle',':', 'Color', [0 0 0]);
elseif linia==2
plot(dur, pdf,'LineWidth',1.5,'LineStyle','-', 'Color', [0.2 0.2 0.2]);
elseif linia==3
plot(dur, pdf,'LineWidth',1.5,'LineStyle','-', 'Color', [0.5 0.5 0.5]);
elseif linia==4
plot(dur, pdf,'LineWidth',1.5,'LineStyle','-', 'Color', [0.8 0.8 0.8]);
end 

set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
xlabel('$x_i$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);

ylabel('$g(x_i \mid \mathcal{F}_{i-1})$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);

title('$\mathcal{W}$ distribution', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);


linia=linia+1;

end



 legend({'$\gamma=0.7$', '$\gamma=0.9$', '$\gamma=1$', '$\gamma=1.7$'}, 'location', 'northeast', 'Interpreter', 'Latex',...
     'FontSize', 12);
 

legend box off;
box off;


print(strcat(path, '/replicated_results/Figure_C11_row_1_col_1.pdf'), '-dpdf')

hold off;

% ==================================================================================

figure('Name','Figure C11, row 1, column 2','NumberTitle','off');


set(gcf, 'Position',  [800 200 400 300]);



linia=1;
while linia<=4

gammaW=A(1,linia);

n=30;




dur=1:1:n;

ksi1=9.5/korr;

pdf = 	((exp(-((dur-1)./ksi1).^gammaW)-exp(-((dur)./ksi1).^gammaW)));
	


hold on

if linia==1
scatter(dur, pdf, 'MarkerEdgeColor', [0 0 0]);

elseif linia==2
scatter(dur, pdf, 'filled', 'MarkerFaceColor', [0.2 0.2 0.2]);
elseif linia==3
scatter(dur, pdf, 'filled', 'MarkerFaceColor', [0.5 0.5 0.5]);
elseif linia==4
scatter(dur, pdf, 'filled', 'MarkerFaceColor', [0.8 0.8 0.8]);
end 


set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
xlabel('$x_i$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);
ylabel('$g(x_i \mid \mathcal{F}_{i-1})$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);

title('Right shifted $\mathcal{DW}$ distribution', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);


linia=linia+1;

end

 legend({'$\gamma=0.7$', '$\gamma=0.9$', '$\gamma=1$', '$\gamma=1.7$'}, 'location', 'northeast', 'Interpreter', 'Latex',...
     'FontSize', 12);
 

legend box off;
box off;

print(strcat(path, '/replicated_results/Figure_C11_row_1_col_2.pdf'), '-dpdf')


hold off;


% ============================================================================

elseif rozklad==2


figure('Name','Figure C11, row 2, column 1','NumberTitle','off');

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
	

hold on

if linia==1
plot(dur, pdf,'LineWidth',1.5,'LineStyle',':', 'Color', [0 0 0]);
elseif linia==2
plot(dur, pdf,'LineWidth',1.5,'LineStyle','-', 'Color', [0.2 0.2 0.2]);
elseif linia==3
plot(dur, pdf,'LineWidth',1.5,'LineStyle','-', 'Color', [0.5 0.5 0.5]);
elseif linia==4
plot(dur, pdf,'LineWidth',1.5,'LineStyle','-', 'Color', [0.8 0.8 0.8]);
end 

set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
xlabel('$x_i$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);
ylabel('$g(x_i \mid \mathcal{F}_{i-1})$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);

title('$\mathcal{B}$ distribution', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);


linia=linia+1;

end


 legend({'$\kappa=0.9$, $\zeta=3$', '$\kappa=1.4$, $\zeta=1.3$', '$\kappa=1.8$, $\zeta=0.7$', '$\kappa=1.9$, $\zeta=3$'}, 'location', 'northeast', 'Interpreter', 'Latex',...
     'FontSize', 12);
 

legend box off;
box off;

print(strcat(path, '/replicated_results/Figure_C11_row_2_col_1.pdf'), '-dpdf')

hold off;

% ====================================================================

figure('Name','Figure C11, row 2, column 2','NumberTitle','off');

set(gcf, 'Position',  [800 200 400 300]);



linia=1;
while linia<=4

kappa=A(1,linia);
sigma2=A(2,linia);

n=30;



korr= sigma2*beta(sigma2-1/kappa, 1+1/kappa);


dur=1:1:n;

ksi1=9.5/korr;

pdf = 	((1+((dur-1)./ksi1).^kappa).^(- sigma2))-((1+((dur+1-1)./ksi1).^kappa).^(-sigma2));
	

"średnia:";

x=1:10000;

sr_discrete= sum(((1+((x-1)./ksi1).^kappa).^(-sigma2)-(1+((x)./ksi1).^kappa).^(-sigma2)).*x);
sr_discrete1 = sum(((1+((x-1)./ksi1).^kappa).^(-sigma2)));


hold on

if linia==1
scatter(dur, pdf, 'MarkerEdgeColor', [0 0 0]);

elseif linia==2
scatter(dur, pdf, 'filled', 'MarkerFaceColor', [0.2 0.2 0.2]);
elseif linia==3
scatter(dur, pdf, 'filled', 'MarkerFaceColor', [0.5 0.5 0.5]);
elseif linia==4
scatter(dur, pdf, 'filled', 'MarkerFaceColor', [0.8 0.8 0.8]);
end 


set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
xlabel('$x_i$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);

ylabel('$g(x_i \mid \mathcal{F}_{i-1})$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);

title('Right shifted $\mathcal{DB}$ distribution', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);


linia=linia+1;

end


 legend({'$\kappa=0.9$, $\zeta=3$', '$\kappa=1.4$, $\zeta=1.3$', '$\kappa=1.8$, $\zeta=0.7$', '$\kappa=1.9$, $\zeta=3$'}, 'location', 'northeast', 'Interpreter', 'Latex',...
     'FontSize', 12);
 

legend box off;
box off;

print(strcat(path, '/replicated_results/Figure_C11_row_2_col_2.pdf'), '-dpdf')


hold off;

% ===========================================================================
elseif rozklad==3

figure('Name','Figure C11, row 3, column 1','NumberTitle','off');

set(gcf, 'Position',  [800 200 400 300]);




A=[ 0.35 0.4 0.7 0.9 ;  4 3.5 2 1];

linia=1;

while linia<=4

gammaGG=A(1,linia);
alphaGG=A(2,linia);

n=30;

sr_gam=gamma(alphaGG+1/gammaGG)/gamma(alphaGG);


dur=0.1:0.01:n;

ksi=10;

ksi1=ksi/sr_gam;

pdf = (gammaGG./(gamma(alphaGG)*dur)).*((dur./ksi1).^(alphaGG*gammaGG)).*exp(-((dur./ksi1).^gammaGG));	

hold on

if linia==1
plot(dur, pdf,'LineWidth',1.5,'LineStyle',':', 'Color', [0 0 0]);
elseif linia==2
plot(dur, pdf,'LineWidth',1.5,'LineStyle','-', 'Color', [0.2 0.2 0.2]);
elseif linia==3
plot(dur, pdf,'LineWidth',1.5,'LineStyle','-', 'Color', [0.5 0.5 0.5]);
elseif linia==4
plot(dur, pdf,'LineWidth',1.5,'LineStyle','-', 'Color', [0.8 0.8 0.8]);
end 

set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
xlabel('$x_i$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);

ylabel('$g(x_i \mid \mathcal{F}_{i-1})$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);

title('GGamma distribution', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);
title('$\mathcal{GG}$ distribution', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);

linia=linia+1;

end


 legend({'$\gamma=0.35$, $\nu=4$', '$\gamma=0.4$, $\nu=3.5$', '$\gamma=0.7$, $\nu=2$', '$\gamma=0.9$, $\nu=1$'}, 'location', 'northeast', 'Interpreter', 'Latex',...
     'FontSize', 12);
 

legend box off;
box off;

print(strcat(path, '/replicated_results/Figure_C11_row_3_col_1.pdf'), '-dpdf')

hold off;

% =========================================================================

figure('Name','Figure C11, row 3, column 2','NumberTitle','off');
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


pdf=((1-gammainc(((dur-1)./ksi1).^gammaGG, alphaGG))-(1-gammainc((dur./ksi1).^gammaGG, alphaGG)));



hold on

if linia==1
scatter(dur, pdf, 'MarkerEdgeColor', [0 0 0]);

elseif linia==2
scatter(dur, pdf, 'filled', 'MarkerFaceColor', [0.2 0.2 0.2]);
elseif linia==3
scatter(dur, pdf, 'filled', 'MarkerFaceColor', [0.5 0.5 0.5]);
elseif linia==4
scatter(dur, pdf, 'filled', 'MarkerFaceColor', [0.8 0.8 0.8]);
end 


set(gca,'FontName', 'Times New Roman', 'FontSize', 12);
xlabel('$x_i$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);
%ylim([0 0.3])
ylabel('$g(x_i \mid \mathcal{F}_{i-1})$', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);


title('Right shifted $\mathcal{DGG}$ distribution', 'Interpreter','Latex', 'FontName', 'Times New Roman', 'FontSize', 12);



linia=linia+1;

end


legend({'$\gamma=0.35$, $\nu=4$', '$\gamma=0.4$, $\nu=3.5$', '$\gamma=0.7$, $\nu=2$', '$\gamma=0.9$, $\nu=1$'}, 'location', 'northeast', 'Interpreter', 'Latex',...
     'FontSize', 12);

legend box off;
box off;

print(strcat(path, '/replicated_results/Figure_C11_row_3_col_2.pdf'), '-dpdf')

hold off;



end

end



toc















