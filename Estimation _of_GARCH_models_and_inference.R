
# The GARCH models are estimated (the corresponding VaR & ES and F0L are computed).
# This script replicates the results in Tables 4-5, and Table G7 in the article
# "When to Be Discrete: The Importance of Time Formulation
# in the Modeling of Extreme Events in Finance" 
# by Katarzyna Bień-Barkowska and Rodrigo Herrera


rm(list=ls())

stat <- function(a, v, e){
  
  dep= (1/a)*as.matrix(ret<=v)*ret/e-1
  
  dep_op=c(0,dep[1:(length(dep)-1)])
  
  multi.fit = lm(dep~dep_op+e)
  
  vcov = as.matrix(vcovHAC.default(multi.fit))
  R=diag(3)
  
  b=(as.vector(multi.fit$coefficients))
  
  stat=t(R %*% b) %*% solve(R  %*% vcov  %*% R) %*% (R %*% b)
 
}

start_time <- Sys.time()


install.packages("this.path")
install.packages("rugarch")
install.packages("esback")
install.packages("readxl")

library(this.path)
library(rugarch)
library(esback)
library(readxl)

setwd(this.path::here())

significance = c(0.0025, 0.005, 0.00625, 0.0075, 0.01, 0.0125, 0.01875, 0.025, 0.0375, 0.05);


for (stock in c("DowJones", "NASDAQ", "SP500", "Wilshire")){ 
  for (typ in c("apARCH", "sGARCH")){
    for (rozklad in c("norm", "sstd")){

  
  for (iter in c(1,2,3,4,5,6,7)){
  

  path2 <- paste("data\\", stock, ".xlsx", sep="");
  
  df <- read_excel(path2);
  
  df <- cbind(df[,1], df[,13], df[,14])
  
  # Express returns in percentages
  
  df[,3]<-df[,3]*100

  spec = ugarchspec(variance.model = list(model = typ, garchOrder = c(1, 1)), mean.model = list(armaOrder = c(0, 0), 
  include.mean = TRUE), distribution.model = rozklad)
  
  
  df <- df[which(df[,2]>19810101), ]
  
  NegReturn <- -df[,3];
  
  
  # Rolling window for the models backtesting
  
  if (iter==1){
  backtesting = 20110101;
  df =df[which(df[,2]< 20130101),]}
  if(iter==2){
  backtesting = 20130101;
  df =df[which(df[,2]< 20150101),]};
  if(iter==3){
  backtesting = 20150101;
  df =df[which(df[,2]< 20170101),]};
  if(iter==4){
  backtesting = 20170101;
  df =df[which(df[,2]< 20190101),]};
  if(iter==5){
  backtesting = 20190101;
  df =df[which(df[,2]< 20210101),]};
  if(iter==6){
  backtesting = 20210101;
  
  df =df[which(df[,2]< 20221229),]};
  
  df_estimation <- df[which(df[,2]<backtesting), ];
  
  df_backtesting <- df[which(df[,2]>=backtesting ), ];
  
  
  
  garch.fit = ugarchfit(spec = spec, data = df_estimation[,3]);
  show(garch.fit);
  
  
  spec = ugarchspec(variance.model = list(model = typ, garchOrder = c(1,1)), 
                    mean.model = list(armaOrder = c(0,0), include.mean = TRUE), 
                    distribution.model = rozklad, fixed.pars = as.list(coef(garch.fit)));
  
  garch.filter = ugarchfilter(data = df[,3], spec = spec);
  
  actual = df[,3];
  
  table1= cbind(df[,2], df[,3], fitted(garch.filter), sigma(garch.filter), residuals(garch.filter));
  table2= cbind(df[,2], df[,3]);
  table3= cbind(df[,2], df[,3]);
  table_ES= cbind(df[,2], df[,3]);
  
  for (i in significance){
    
   
    
    VaR_new <- as.numeric(quantile(garch.filter, probs = i))
    table2= cbind(table2, VaR_new);
    
    # calculate ES
    
    if (rozklad=="sstd"){ 
    f = function(x) qdist("sstd", p=x, mu = 0, sigma = 1, 
                          skew  = coef(garch.filter)["skew"], shape=coef(garch.filter)["shape"])
    ES = fitted(garch.filter) + sigma(garch.filter)*integrate(f, 0, i)$value/i
    }
    if (rozklad=="norm"){
    f = function(x) qdist("norm", p=x, mu = 0, sigma = 1)
    ES = fitted(garch.filter) + sigma(garch.filter)*integrate(f, 0, i)$value/i
    }

    
    table_ES <- cbind(table_ES, ES);
    
  }
  
  if (iter==1){
  table_ES_rolling<- table_ES
  table2_rolling<-table2;
  }
  if (iter>1 & iter<7){
    table_ES_rolling<- rbind(table_ES_rolling, table_ES[which(table_ES[,1]>backtesting),]);
    table2_rolling<-rbind(table2_rolling, table2[which(table2[,1]>backtesting),]);
  } 
  
  if(iter==7){
    backtesting = 20110101;
    end_date = 20230101;
    df =df[which(df[,2]< 20230101),]};
    table_ES<-table_ES_rolling;
    table2<-table2_rolling;
    
  if (backtesting==20110101){
    okres="pierwszy"
  }
  if (backtesting==20190101){
    okres="drugi"
  }
  }
  
  ES_099 = table_ES[which(table_ES[,1]>backtesting & table_ES[,1]<end_date),7]
  VaR_099 = table2[which(table2[,1]>backtesting & table2[,1]<end_date),7]
  
 
  assign(paste("ES_099_", typ, "_", rozklad, sep = ""), table_ES[which(table_ES[,1]>backtesting & table_ES[,1]<end_date),7]);
  assign(paste("VaR_099_", typ, "_", rozklad, sep = ""), table2[which(table2[,1]>backtesting & table2[,1]<end_date),7]);
  
  ES_0975 = table_ES[which(table_ES[,1]>backtesting & table_ES[,1]<end_date),10]
  VaR_0975 = table2[which(table2[,1]>backtesting & table2[,1]<end_date),10]
  
  assign(paste("ES_0975_", typ, "_", rozklad, sep = ""), table_ES[which(table_ES[,1]>backtesting & table_ES[,1]<end_date),10])
  assign(paste("VaR_0975_", typ, "_", rozklad, sep = ""), table2[which(table2[,1]>backtesting & table2[,1]<end_date),10])
  
  ES_095 = table_ES[which(table_ES[,1]>backtesting),12]
  VaR_095 = table2[which(table2[,1]>backtesting),12]
  
  assign(paste("ES_095_", typ, "_", rozklad, sep = ""), table_ES[which(table_ES[,1]>backtesting & table_ES[,1]<end_date),12]);
  assign(paste("VaR_095_", typ, "_", rozklad, sep = ""), table2[which(table2[,1]>backtesting & table2[,1]<end_date),12]);
  
  
  returns = table2[which(table2[,1]>backtesting & table2[,1]<end_date),2];
  
 
  excerd_099 = as.matrix(returns<=VaR_099);
  excerd_0975 = as.matrix(returns<=VaR_0975);
  excerd_095 = as.matrix(returns<=VaR_095);
  
  
  AL_099=-log((0.01-1)/(ES_099))-(returns-(VaR_099))*(0.01-excerd_099)/(0.01*(ES_099)) + returns/(ES_099);
  
  assign(paste("AL_099_", typ, "_", rozklad, sep = ""), AL_099);
  
 
  FZG_099=((excerd_099-0.01)*(VaR_099)-excerd_099*returns + (1/0.01)*exp(ES_099)/(1+exp(ES_099))*excerd_099*(VaR_099-returns) +(ES_099-VaR_099)*exp(ES_099)/(1+exp(ES_099))+log(2/(1+exp(ES_099))));
  
  assign(paste("FZG_099_", typ, "_", rozklad, sep = ""), FZG_099);

  
  FZ0_099= -(1/(0.01*(ES_099)))*excerd_099*(VaR_099-returns) + VaR_099/ES_099+log(-ES_099)-1;
  assign(paste("FZ0_099_", typ, "_", rozklad, sep = ""), FZ0_099);
  
  
  AL_0975=-log((0.025-1)/(ES_0975))-(returns-(VaR_0975))*(0.025-excerd_0975)/(0.025*(ES_0975)) + returns/(ES_0975);
  
  assign(paste("AL_0975_", typ, "_", rozklad, sep = ""), AL_0975);
  
  FZG_0975=(excerd_0975-0.025)*(VaR_0975)-excerd_0975*returns + (1/0.025)*exp(ES_0975)/(1+exp(ES_0975))*excerd_0975*(VaR_0975-returns) +(ES_0975-VaR_0975)*exp(ES_0975)/(1+exp(ES_0975))+log(2/(1+exp(ES_0975)));
  
  assign(paste("FZG_0975_", typ, "_", rozklad, sep = ""), FZG_0975);
  
  FZ0_0975= -(1/(0.025*(ES_0975)))*excerd_0975*(VaR_0975-returns) + VaR_0975/ES_0975+log(-ES_0975)-1;
  
  assign(paste("FZ0_0975_", typ, "_", rozklad, sep = ""), FZ0_0975);
  
  AL_095=-log((0.05-1)/(ES_095))-(returns-(VaR_095))*(0.05-excerd_095)/(0.05*(ES_095)) + returns/(ES_095);
  
  FZG_095=((excerd_095-0.05)*(VaR_095)-excerd_095*returns + (1/0.05)*exp(ES_095)/(1+exp(ES_095))*excerd_095*(VaR_095-returns) +(ES_095-VaR_095)*exp(ES_095)/(1+exp(ES_095))+log(2/(1+exp(ES_095))));
  
  FZ0_095= -(1/(0.05*(ES_095)))*excerd_095*(VaR_095-returns) + VaR_095/ES_095+log(-ES_095)-1;
  
  assign(paste("FZ0_095_", typ, "_", rozklad, sep = ""), FZ0_095);
  
  assign(paste("AL_095_", typ, "_", rozklad, sep = ""), AL_095);
  
  assign(paste("FZG_095_", typ, "_", rozklad, sep = ""), FZG_095);
  
  
  
}
}
  
  
c=matrix(0, 3, 11)
d=matrix(0, 3, 11)
e=matrix(0, 3, 11)
f=matrix(0, 3, 11)
g=matrix(0, 3, 11)

library(sandwich)

  path2 <- paste("output_data\\VaR_BNB_", stock, "_explanatory_inv_rolling.txt", sep="");
  
  dane <- read.table(path2, header = FALSE, row.names = NULL);
  
  ret <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 2])
  
  
  
  POT_ES_095_BNB_expl <- - as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 22])
  POT_VaR_095_BNB_expl <- - as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 21])
  
  
  
  POT_ES_0975_BNB_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 11])
  POT_VaR_0975_BNB_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 10])
  
  
  
  POT_ES_099_BNB_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 9])
  POT_VaR_099_BNB_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 8])
  
  
  
 c[1,7]<-stat(0.05, POT_VaR_095_BNB_expl, POT_ES_095_BNB_expl)
 c[2,7]<-stat(0.025, POT_VaR_0975_BNB_expl, POT_ES_0975_BNB_expl)
 c[3,7]<-stat(0.01, POT_VaR_099_BNB_expl, POT_ES_099_BNB_expl) 
  
 excerd= as.matrix(ret<POT_VaR_095_BNB_expl);
 d[1,7]<- sum((-ret*excerd)/(nrow(excerd)*0.05*POT_ES_095_BNB_expl))+1;
 excerd= as.matrix(ret<POT_VaR_0975_BNB_expl);
 d[2,7]<- sum((-ret*excerd)/(nrow(excerd)*0.025*POT_ES_0975_BNB_expl))+1; 
 excerd= as.matrix(ret<POT_VaR_099_BNB_expl);
 d[3,7]<- sum((-ret*excerd)/(nrow(excerd)*0.01*POT_ES_099_BNB_expl))+1; 
 
 k = esr_backtest(r = ret, q = POT_VaR_095_BNB_expl, e = POT_ES_095_BNB_expl, alpha = 0.05, version = 3)
 e[1,7]<-k$pvalue_onesided_asymptotic
 k = esr_backtest(r = ret, q = POT_VaR_0975_BNB_expl, e = POT_ES_0975_BNB_expl, alpha = 0.025, version = 3)
 e[2,7]<-k$pvalue_onesided_asymptotic
 k = esr_backtest(r = ret, q = POT_VaR_099_BNB_expl, e = POT_ES_099_BNB_expl, alpha = 0.01, version = 3)
 e[3,7]<-k$pvalue_onesided_asymptotic
 
 
 k = esr_backtest(r = ret, q = POT_VaR_095_BNB_expl, e = POT_ES_095_BNB_expl, alpha = 0.05, version = 2)
 f[1,7]<-k$pvalue_twosided_asymptotic
 k = esr_backtest(r = ret, q = POT_VaR_0975_BNB_expl, e = POT_ES_0975_BNB_expl, alpha = 0.025, version = 2)
 f[2,7]<-k$pvalue_twosided_asymptotic
 k = esr_backtest(r = ret, q = POT_VaR_099_BNB_expl, e = POT_ES_099_BNB_expl, alpha = 0.01, version = 2)
 f[3,7]<-k$pvalue_twosided_asymptotic
 
 k = esr_backtest(r = ret, q = POT_VaR_095_BNB_expl, e = POT_ES_095_BNB_expl, alpha = 0.05, version = 1)
 g[1,7]<-k$pvalue_twosided_asymptotic
 k = esr_backtest(r = ret, q = POT_VaR_0975_BNB_expl, e = POT_ES_0975_BNB_expl, alpha = 0.025, version = 1)
 g[2,7]<-k$pvalue_twosided_asymptotic
 k = esr_backtest(r = ret, q = POT_VaR_099_BNB_expl, e = POT_ES_099_BNB_expl, alpha = 0.01, version = 1)
 g[3,7]<-k$pvalue_twosided_asymptotic
 
  
  POT_FZ0_loss_095_BNB_expl  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 18])
  POT_FZ0_loss_0975_BNB_expl  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 19])
  POT_FZ0_loss_099_BNB_expl  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 20])
 
  
  path2 <- paste("output_data\\VaR_BNB_", stock, "_explanatory_none_rolling.txt", sep="");
  
  dane <- read.table(path2);
  
  ret <- dane[which(dane[,1]>backtesting & dane[,1]<end_date), 2]
 
  
  
  POT_FZ0_loss_095_BNB_none  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 18])
  POT_FZ0_loss_0975_BNB_none  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 19])
  POT_FZ0_loss_099_BNB_none  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 20])
  
  
  path2 <- paste("output_data\\VaR_Burr_", stock, "_explanatory_inv_rolling.txt", sep="");
  
  dane <- read.table(path2);
  ret <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 2])
  
  POT_ES_095_Burr_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 22])
  POT_VaR_095_Burr_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 21])
  
  POT_ES_0975_Burr_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 11])
  POT_VaR_0975_Burr_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 10])
  
  
  POT_ES_099_Burr_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 9])
  POT_VaR_099_Burr_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 8])
  
  
  c[1,1]<-stat(0.05, POT_VaR_095_Burr_expl, POT_ES_095_Burr_expl)
  c[2,1]<-stat(0.025, POT_VaR_0975_Burr_expl, POT_ES_0975_Burr_expl)
  c[3,1]<-stat(0.01, POT_VaR_099_Burr_expl, POT_ES_099_Burr_expl) 
  
  
  excerd= as.matrix(ret<POT_VaR_095_Burr_expl);
  d[1,1]<- sum((-ret*excerd)/(nrow(excerd)*0.05*POT_ES_095_Burr_expl))+1;
  excerd= as.matrix(ret<POT_VaR_0975_Burr_expl);
  d[2,1]<- sum((-ret*excerd)/(nrow(excerd)*0.025*POT_ES_0975_Burr_expl))+1; 
  excerd= as.matrix(ret<POT_VaR_099_Burr_expl);
  d[3,1]<- sum((-ret*excerd)/(nrow(excerd)*0.01*POT_ES_099_Burr_expl))+1; 
  
  
  k = esr_backtest(r = ret, q = POT_VaR_095_Burr_expl, e = POT_ES_095_Burr_expl, alpha = 0.05, version = 3)
  e[1,1]<-k$pvalue_onesided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_0975_Burr_expl, e = POT_ES_0975_Burr_expl, alpha = 0.025, version = 3)
  e[2,1]<-k$pvalue_onesided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_099_Burr_expl, e = POT_ES_099_Burr_expl, alpha = 0.01, version = 3)
  e[3,1]<-k$pvalue_onesided_asymptotic

  k = esr_backtest(r = ret, q = POT_VaR_095_Burr_expl, e = POT_ES_095_Burr_expl, alpha = 0.05, version = 2)
  f[1,1]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_0975_Burr_expl, e = POT_ES_0975_Burr_expl, alpha = 0.025, version = 2)
  f[2,1]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_099_Burr_expl, e = POT_ES_099_Burr_expl, alpha = 0.01, version = 2)
  f[3,1]<-k$pvalue_twosided_asymptotic
  
  k = esr_backtest(r = ret, q = POT_VaR_095_Burr_expl, e = POT_ES_095_Burr_expl, alpha = 0.05, version = 1)
  g[1,1]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_0975_Burr_expl, e = POT_ES_0975_Burr_expl, alpha = 0.025, version = 1)
  g[2,1]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_099_Burr_expl, e = POT_ES_099_Burr_expl, alpha = 0.01, version = 1)
  g[3,1]<-k$pvalue_twosided_asymptotic
  
 
  POT_FZ0_loss_095_Burr_expl  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 18]) 
  POT_FZ0_loss_0975_Burr_expl  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 19])
  POT_FZ0_loss_099_Burr_expl  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 20])
  
  path2 <- paste("output_data\\VaR_Burr_", stock, "_explanatory_none_rolling.txt", sep="");
  
  dane <- read.table(path2);
  ret <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 2])
  

  POT_FZ0_loss_095_Burr_none  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 18]) 
  POT_FZ0_loss_0975_Burr_none  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 19])
  POT_FZ0_loss_099_Burr_none  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 20])
  
  
  path2 <- paste("output_data\\VaR_DBurr_", stock, "_explanatory_inv_rolling.txt", sep="");
  
  dane <- read.table(path2);
  ret <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 2])
  
  POT_ES_095_DBurr_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 22])
  POT_VaR_095_DBurr_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 21])
  
  POT_ES_0975_DBurr_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 11])
  POT_VaR_0975_DBurr_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 10])
  
  
  POT_ES_099_DBurr_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 9])
  POT_VaR_099_DBurr_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 8])
  
  c[1,2]<-stat(0.05, POT_VaR_095_DBurr_expl, POT_ES_095_DBurr_expl)
  c[2,2]<-stat(0.025, POT_VaR_0975_DBurr_expl, POT_ES_0975_DBurr_expl)
  c[3,2]<-stat(0.01, POT_VaR_099_DBurr_expl, POT_ES_099_DBurr_expl) 
  
  excerd= as.matrix(ret<POT_VaR_095_DBurr_expl);
  d[1,2]<- sum((-ret*excerd)/(nrow(excerd)*0.05*POT_ES_095_DBurr_expl))+1;
  excerd= as.matrix(ret<POT_VaR_0975_DBurr_expl);
  d[2,2]<- sum((-ret*excerd)/(nrow(excerd)*0.025*POT_ES_0975_DBurr_expl))+1; 
  excerd= as.matrix(ret<POT_VaR_099_DBurr_expl);
  d[3,2]<- sum((-ret*excerd)/(nrow(excerd)*0.01*POT_ES_099_DBurr_expl))+1; 
  
  k = esr_backtest(r = ret, q = POT_VaR_095_DBurr_expl, e = POT_ES_095_DBurr_expl, alpha = 0.05, version = 3)
  e[1,2]<-k$pvalue_onesided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_0975_DBurr_expl, e = POT_ES_0975_DBurr_expl, alpha = 0.025, version = 3)
  e[2,2]<-k$pvalue_onesided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_099_DBurr_expl, e = POT_ES_099_DBurr_expl, alpha = 0.01, version = 3)
  e[3,2]<-k$pvalue_onesided_asymptotic
  
  
  k = esr_backtest(r = ret, q = POT_VaR_095_DBurr_expl, e = POT_ES_095_DBurr_expl, alpha = 0.05, version = 2)
  f[1,2]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_0975_DBurr_expl, e = POT_ES_0975_DBurr_expl, alpha = 0.025, version = 2)
  f[2,2]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_099_DBurr_expl, e = POT_ES_099_DBurr_expl, alpha = 0.01, version = 2)
  f[3,2]<-k$pvalue_twosided_asymptotic
  
  k = esr_backtest(r = ret, q = POT_VaR_095_DBurr_expl, e = POT_ES_095_DBurr_expl, alpha = 0.05, version = 1)
  g[1,2]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_0975_DBurr_expl, e = POT_ES_0975_DBurr_expl, alpha = 0.025, version = 1)
  g[2,2]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_099_DBurr_expl, e = POT_ES_099_DBurr_expl, alpha = 0.01, version = 1)
  g[3,2]<-k$pvalue_twosided_asymptotic
  
 
  POT_FZ0_loss_095_DBurr_expl  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 18]) 
  POT_FZ0_loss_0975_DBurr_expl  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 19])
  POT_FZ0_loss_099_DBurr_expl  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 20])
  
  
  path2 <- paste("output_data\\VaR_DBurr_", stock, "_explanatory_none_rolling.txt", sep="");
  
  dane <- read.table(path2);
  
  
  
  POT_FZ0_loss_095_DBurr_none  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 18]) 
  POT_FZ0_loss_0975_DBurr_none  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 19])
  POT_FZ0_loss_099_DBurr_none  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 20])
  
  
  
  path2 <- paste("output_data\\VaR_Weibull_", stock, "_explanatory_inv_rolling.txt", sep="");
  
  dane <- read.table(path2);
  ret <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 2])
  
  POT_ES_095_Weibull_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 22])
  POT_VaR_095_Weibull_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 21])
  
  POT_ES_0975_Weibull_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 11])
  POT_VaR_0975_Weibull_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 10])
  
  POT_ES_099_Weibull_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 9])
  POT_VaR_099_Weibull_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 8])
  
  c[1,5]<-stat(0.05, POT_VaR_095_Weibull_expl, POT_ES_095_Weibull_expl)
  c[2,5]<-stat(0.025, POT_VaR_0975_Weibull_expl, POT_ES_0975_Weibull_expl)
  c[3,5]<-stat(0.01, POT_VaR_099_Weibull_expl, POT_ES_099_Weibull_expl) 
  
  excerd= as.matrix(ret<POT_VaR_095_Weibull_expl);
  d[1,5]<- sum((-ret*excerd)/(nrow(excerd)*0.05*POT_ES_095_Weibull_expl))+1;
  excerd= as.matrix(ret<POT_VaR_0975_Weibull_expl);
  d[2,5]<- sum((-ret*excerd)/(nrow(excerd)*0.025*POT_ES_0975_Weibull_expl))+1; 
  excerd= as.matrix(ret<POT_VaR_099_Weibull_expl);
  d[3,5]<- sum((-ret*excerd)/(nrow(excerd)*0.01*POT_ES_099_Weibull_expl))+1; 
  
  
  k = esr_backtest(r = ret, q = POT_VaR_095_Weibull_expl, e = POT_ES_095_Weibull_expl, alpha = 0.05, version = 3)
  e[1,5]<-k$pvalue_onesided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_0975_Weibull_expl, e = POT_ES_0975_Weibull_expl, alpha = 0.025, version = 3)
  e[2,5]<-k$pvalue_onesided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_099_Weibull_expl, e = POT_ES_099_Weibull_expl, alpha = 0.01, version = 3)
  e[3,5]<-k$pvalue_onesided_asymptotic
  
  k = esr_backtest(r = ret, q = POT_VaR_095_Weibull_expl, e = POT_ES_095_Weibull_expl, alpha = 0.05, version = 2)
  f[1,5]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_0975_Weibull_expl, e = POT_ES_0975_Weibull_expl, alpha = 0.025, version = 2)
  f[2,5]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_099_Weibull_expl, e = POT_ES_099_Weibull_expl, alpha = 0.01, version = 2)
  f[3,5]<-k$pvalue_twosided_asymptotic
  
  k = esr_backtest(r = ret, q = POT_VaR_095_Weibull_expl, e = POT_ES_095_Weibull_expl, alpha = 0.05, version = 1)
  g[1,5]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_0975_Weibull_expl, e = POT_ES_0975_Weibull_expl, alpha = 0.025, version = 1)
  g[2,5]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_099_Weibull_expl, e = POT_ES_099_Weibull_expl, alpha = 0.01, version = 1)
  g[3,5]<-k$pvalue_twosided_asymptotic
  
 
  POT_FZ0_loss_095_Weibull_expl  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 18]) 
  POT_FZ0_loss_0975_Weibull_expl  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 19])
  POT_FZ0_loss_099_Weibull_expl  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 20])
  

  
  path2 <- paste("output_data\\VaR_Weibull_", stock, "_explanatory_none_rolling.txt", sep="");
  
  dane <- read.table(path2);
  
 
  
  POT_FZ0_loss_095_Weibull_none <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 18]) 
  POT_FZ0_loss_0975_Weibull_none  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 19])
  POT_FZ0_loss_099_Weibull_none  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 20])
  
 
  
  
  
  
  path2 <- paste("output_data\\VaR_DWeibull_", stock, "_explanatory_inv_rolling.txt", sep="");
  
  dane <- read.table(path2);
  ret <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 2])
  
  POT_ES_095_DWeibull_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 22])
  POT_VaR_095_DWeibull_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 21])
  
  POT_ES_0975_DWeibull_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 11])
  POT_VaR_0975_DWeibull_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 10])
  
  POT_ES_099_DWeibull_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 9])
  POT_VaR_099_DWeibull_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 8])
  
  c[1,6]<-stat(0.05, POT_VaR_095_DWeibull_expl, POT_ES_095_DWeibull_expl)
  c[2,6]<-stat(0.025, POT_VaR_0975_DWeibull_expl, POT_ES_0975_DWeibull_expl)
  c[3,6]<-stat(0.01, POT_VaR_099_DWeibull_expl, POT_ES_099_DWeibull_expl) 
  
  
  excerd= as.matrix(ret<POT_VaR_095_DWeibull_expl);
  d[1,6]<- sum((-ret*excerd)/(nrow(excerd)*0.05*POT_ES_095_DWeibull_expl))+1;
  excerd= as.matrix(ret<POT_VaR_0975_DWeibull_expl);
  d[2,6]<- sum((-ret*excerd)/(nrow(excerd)*0.025*POT_ES_0975_DWeibull_expl))+1; 
  excerd= as.matrix(ret<POT_VaR_099_DWeibull_expl);
  d[3,6]<- sum((-ret*excerd)/(nrow(excerd)*0.01*POT_ES_099_DWeibull_expl))+1; 
  
  
  k = esr_backtest(r = ret, q = POT_VaR_095_DWeibull_expl, e = POT_ES_095_DWeibull_expl, alpha = 0.05, version = 3)
  e[1,6]<-k$pvalue_onesided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_0975_DWeibull_expl, e = POT_ES_0975_DWeibull_expl, alpha = 0.025, version = 3)
  e[2,6]<-k$pvalue_onesided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_099_DWeibull_expl, e = POT_ES_099_DWeibull_expl, alpha = 0.01, version = 3)
  e[3,6]<-k$pvalue_onesided_asymptotic
  
  
  k = esr_backtest(r = ret, q = POT_VaR_095_DWeibull_expl, e = POT_ES_095_DWeibull_expl, alpha = 0.05, version = 2)
  f[1,6]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_0975_DWeibull_expl, e = POT_ES_0975_DWeibull_expl, alpha = 0.025, version = 2)
  f[2,6]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_099_DWeibull_expl, e = POT_ES_099_DWeibull_expl, alpha = 0.01, version = 2)
  f[3,6]<-k$pvalue_twosided_asymptotic
  
  k = esr_backtest(r = ret, q = POT_VaR_095_DWeibull_expl, e = POT_ES_095_DWeibull_expl, alpha = 0.05, version = 1)
  g[1,6]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_0975_DWeibull_expl, e = POT_ES_0975_DWeibull_expl, alpha = 0.025, version = 1)
  g[2,6]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_099_DWeibull_expl, e = POT_ES_099_DWeibull_expl, alpha = 0.01, version = 1)
  g[3,6]<-k$pvalue_twosided_asymptotic
  

  
  POT_FZ0_loss_095_DWeibull_expl  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 18]) 
  POT_FZ0_loss_0975_DWeibull_expl  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 19])
  POT_FZ0_loss_099_DWeibull_expl  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 20])
  
  
  path2 <- paste("output_data\\VaR_DWeibull_", stock, "_explanatory_none_rolling.txt", sep="");
  
  dane <- read.table(path2);
  
 
  
  POT_FZ0_loss_095_DWeibull_none  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 18]) 
  POT_FZ0_loss_0975_DWeibull_none  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 19])
  POT_FZ0_loss_099_DWeibull_none  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 20])
  
  
  
  path2 <- paste("output_data\\VaR_GGamma_", stock, "_explanatory_inv_rolling.txt", sep="");
  
  dane <- read.table(path2);
  ret <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 2])
  
  POT_ES_095_GGamma_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 22])
  POT_VaR_095_GGamma_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 21])
  
  POT_ES_0975_GGamma_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 11])
  POT_VaR_0975_GGamma_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 10])
  
  
  
  POT_ES_099_GGamma_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 9])
  POT_VaR_099_GGamma_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 8])
  
  
  c[1,3]<-stat(0.05, POT_VaR_095_GGamma_expl, POT_ES_095_GGamma_expl)
  c[2,3]<-stat(0.025, POT_VaR_0975_GGamma_expl, POT_ES_0975_GGamma_expl)
  c[3,3]<-stat(0.01, POT_VaR_099_GGamma_expl, POT_ES_099_GGamma_expl) 
  
  excerd= as.matrix(ret<POT_VaR_095_GGamma_expl);
  d[1,3]<- sum((-ret*excerd)/(nrow(excerd)*0.05*POT_ES_095_GGamma_expl))+1;
  excerd= as.matrix(ret<POT_VaR_0975_GGamma_expl);
  d[2,3]<- sum((-ret*excerd)/(nrow(excerd)*0.025*POT_ES_0975_GGamma_expl))+1; 
  excerd= as.matrix(ret<POT_VaR_099_GGamma_expl);
  d[3,3]<- sum((-ret*excerd)/(nrow(excerd)*0.01*POT_ES_099_GGamma_expl))+1; 
  
  
  k = esr_backtest(r = ret, q = POT_VaR_095_GGamma_expl, e = POT_ES_095_GGamma_expl, alpha = 0.05, version = 3)
  e[1,3]<-k$pvalue_onesided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_0975_GGamma_expl, e = POT_ES_0975_GGamma_expl, alpha = 0.025, version = 3)
  e[2,3]<-k$pvalue_onesided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_099_GGamma_expl, e = POT_ES_099_GGamma_expl, alpha = 0.01, version = 3)
  e[3,3]<-k$pvalue_onesided_asymptotic
  
  
  k = esr_backtest(r = ret, q = POT_VaR_095_GGamma_expl, e = POT_ES_095_GGamma_expl, alpha = 0.05, version = 2)
  f[1,3]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_0975_GGamma_expl, e = POT_ES_0975_GGamma_expl, alpha = 0.025, version = 2)
  f[2,3]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_099_GGamma_expl, e = POT_ES_099_GGamma_expl, alpha = 0.01, version = 2)
  f[3,3]<-k$pvalue_twosided_asymptotic
  
  k = esr_backtest(r = ret, q = POT_VaR_095_GGamma_expl, e = POT_ES_095_GGamma_expl, alpha = 0.05, version = 1)
  g[1,3]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_0975_GGamma_expl, e = POT_ES_0975_GGamma_expl, alpha = 0.025, version = 1)
  g[2,3]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_099_GGamma_expl, e = POT_ES_099_GGamma_expl, alpha = 0.01, version = 1)
  g[3,3]<-k$pvalue_twosided_asymptotic
  

  POT_FZ0_loss_095_GGamma_expl  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 18])
  POT_FZ0_loss_0975_GGamma_expl  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 19])
  POT_FZ0_loss_099_GGamma_expl  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 20])
  
  path2 <- paste("output_data\\VaR_GGamma_", stock, "_explanatory_none_rolling.txt", sep="");
  
  dane <- read.table(path2);
  
  
  
  POT_FZ0_loss_095_GGamma_none  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 18]) 
  POT_FZ0_loss_0975_GGamma_none  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 19])
  POT_FZ0_loss_099_GGamma_none  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 20])
  
  
  
  
  path2 <- paste("output_data\\VaR_DGGamma_", stock, "_explanatory_inv_rolling.txt", sep="");
  
  dane <- read.table(path2);
  ret <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 2])
  
  POT_ES_095_DGGamma_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 22])
  POT_VaR_095_DGGamma_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 21])
  
  
  POT_ES_0975_DGGamma_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 11])
  POT_VaR_0975_DGGamma_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 10])
  
  
  POT_ES_099_DGGamma_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 9])
  POT_VaR_099_DGGamma_expl <- -as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 8])
  

  c[1,4]<-stat(0.05, POT_VaR_095_DGGamma_expl, POT_ES_095_DGGamma_expl)
  c[2,4]<-stat(0.025, POT_VaR_0975_DGGamma_expl, POT_ES_0975_DGGamma_expl)
  c[3,4]<-stat(0.01, POT_VaR_099_DGGamma_expl, POT_ES_099_DGGamma_expl) 
 
  
  excerd= as.matrix(ret<POT_VaR_095_DGGamma_expl);
  d[1,4]<- sum((-ret*excerd)/(nrow(excerd)*0.05*POT_ES_095_DGGamma_expl))+1;
  excerd= as.matrix(ret<POT_VaR_0975_DGGamma_expl);
  d[2,4]<- sum((-ret*excerd)/(nrow(excerd)*0.025*POT_ES_0975_DGGamma_expl))+1; 
  excerd= as.matrix(ret<POT_VaR_099_DGGamma_expl);
  d[3,4]<- sum((-ret*excerd)/(nrow(excerd)*0.01*POT_ES_099_DGGamma_expl))+1; 
  
  
  k = esr_backtest(r = ret, q = POT_VaR_095_DGGamma_expl, e = POT_ES_095_DGGamma_expl, alpha = 0.05, version = 3)
  e[1,4]<-k$pvalue_onesided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_0975_DGGamma_expl, e = POT_ES_0975_DGGamma_expl, alpha = 0.025, version = 3)
  e[2,4]<-k$pvalue_onesided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_099_DGGamma_expl, e = POT_ES_099_DGGamma_expl, alpha = 0.01, version = 3)
  e[3,4]<-k$pvalue_onesided_asymptotic
  
  
  k = esr_backtest(r = ret, q = POT_VaR_095_DGGamma_expl, e = POT_ES_095_DGGamma_expl, alpha = 0.05, version = 2)
  f[1,4]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_0975_DGGamma_expl, e = POT_ES_0975_DGGamma_expl, alpha = 0.025, version = 2)
  f[2,4]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_099_DGGamma_expl, e = POT_ES_099_DGGamma_expl, alpha = 0.01, version = 2)
  f[3,4]<-k$pvalue_twosided_asymptotic
  
  k = esr_backtest(r = ret, q = POT_VaR_095_DGGamma_expl, e = POT_ES_095_DGGamma_expl, alpha = 0.05, version = 1)
  g[1,4]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_0975_DGGamma_expl, e = POT_ES_0975_DGGamma_expl, alpha = 0.025, version = 1)
  g[2,4]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = POT_VaR_099_DGGamma_expl, e = POT_ES_099_DGGamma_expl, alpha = 0.01, version = 1)
  g[3,4]<-k$pvalue_twosided_asymptotic
  
  
  POT_FZ0_loss_095_DGGamma_expl  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 18]) 
  POT_FZ0_loss_0975_DGGamma_expl  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 19])
  POT_FZ0_loss_099_DGGamma_expl  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 20])
  
  
  path2 <- paste("output_data\\VaR_DGGamma_", stock, "_explanatory_none_rolling.txt", sep="");
  
  dane <- read.table(path2);
  
  
  
  POT_FZ0_loss_095_DGGamma_none  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 18]) 
  POT_FZ0_loss_0975_DGGamma_none  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 19])
  POT_FZ0_loss_099_DGGamma_none  <- as.numeric(dane[which(dane[,1]>backtesting & dane[,1]<end_date), 20])
  
  
  
  c[1,8]<-stat(0.05, VaR_095_apARCH_norm, ES_095_apARCH_norm)
  c[2,8]<-stat(0.025, VaR_0975_apARCH_norm, ES_0975_apARCH_norm)
  c[3,8]<-stat(0.01, VaR_099_apARCH_norm, ES_099_apARCH_norm) 
 
  
  
  excerd= as.matrix(ret<VaR_095_apARCH_norm);
  d[1,8]<- sum((-ret*excerd)/(nrow(excerd)*0.05*ES_095_apARCH_norm))+1;
  excerd= as.matrix(ret<VaR_0975_apARCH_norm);
  d[2,8]<- sum((-ret*excerd)/(nrow(excerd)*0.025*ES_0975_apARCH_norm))+1; 
  excerd= as.matrix(ret<VaR_099_apARCH_norm);
  d[3,8]<- sum((-ret*excerd)/(nrow(excerd)*0.01*ES_099_apARCH_norm))+1; 
  
  
  k = esr_backtest(r = ret, q = VaR_095_apARCH_norm, e = ES_095_apARCH_norm, alpha = 0.05, version = 3)
  e[1,8]<-k$pvalue_onesided_asymptotic
  k = esr_backtest(r = ret, q = VaR_0975_apARCH_norm, e = ES_0975_apARCH_norm, alpha = 0.025, version = 3)
  e[2,8]<-k$pvalue_onesided_asymptotic
  k = esr_backtest(r = ret, q = VaR_099_apARCH_norm, e = ES_099_apARCH_norm, alpha = 0.01, version = 3)
  e[3,8]<-k$pvalue_onesided_asymptotic
  
  
  k = esr_backtest(r = ret, q = VaR_095_apARCH_norm, e = ES_095_apARCH_norm, alpha = 0.05, version = 2)
  f[1,8]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = VaR_0975_apARCH_norm, e = ES_0975_apARCH_norm, alpha = 0.025, version = 2)
  f[2,8]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = VaR_099_apARCH_norm, e = ES_099_apARCH_norm, alpha = 0.01, version = 2)
  f[3,8]<-k$pvalue_twosided_asymptotic
  
  
  k = esr_backtest(r = ret, q = VaR_095_apARCH_norm, e = ES_095_apARCH_norm, alpha = 0.05, version = 1)
  g[1,8]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = VaR_0975_apARCH_norm, e = ES_0975_apARCH_norm, alpha = 0.025, version = 1)
  g[2,8]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = VaR_099_apARCH_norm, e = ES_099_apARCH_norm, alpha = 0.01, version = 1)
  g[3,8]<-k$pvalue_twosided_asymptotic
  
  
  
  c[1,9]<-stat(0.05, VaR_095_apARCH_norm, ES_095_sGARCH_norm)
  c[2,9]<-stat(0.025, VaR_0975_apARCH_norm, ES_0975_sGARCH_norm)
  c[3,9]<-stat(0.01, VaR_099_apARCH_norm, ES_099_sGARCH_norm) 
  
  excerd= as.matrix(ret<VaR_095_sGARCH_norm);
  d[1,9]<- sum((-ret*excerd)/(nrow(excerd)*0.05*ES_095_sGARCH_norm))+1;
  excerd= as.matrix(ret<VaR_0975_sGARCH_norm);
  d[2,9]<- sum((-ret*excerd)/(nrow(excerd)*0.025*ES_0975_sGARCH_norm))+1; 
  excerd= as.matrix(ret<VaR_099_sGARCH_norm);
  d[3,9]<- sum((-ret*excerd)/(nrow(excerd)*0.01*ES_099_sGARCH_norm))+1; 
  
  k = esr_backtest(r = ret, q = VaR_095_sGARCH_norm, e = ES_095_sGARCH_norm, alpha = 0.05, version = 3)
  e[1,9]<-k$pvalue_onesided_asymptotic
  k = esr_backtest(r = ret, q = VaR_0975_sGARCH_norm, e = ES_0975_sGARCH_norm, alpha = 0.025, version = 3)
  e[2,9]<-k$pvalue_onesided_asymptotic
  k = esr_backtest(r = ret, q = VaR_099_sGARCH_norm, e = ES_099_sGARCH_norm, alpha = 0.01, version = 3)
  e[3,9]<-k$pvalue_onesided_asymptotic 
  
  k = esr_backtest(r = ret, q = VaR_095_sGARCH_norm, e = ES_095_sGARCH_norm, alpha = 0.05, version = 2)
  f[1,9]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = VaR_0975_sGARCH_norm, e = ES_0975_sGARCH_norm, alpha = 0.025, version = 2)
  f[2,9]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = VaR_099_sGARCH_norm, e = ES_099_sGARCH_norm, alpha = 0.01, version = 2)
  f[3,9]<-k$pvalue_twosided_asymptotic
  
  k = esr_backtest(r = ret, q = VaR_095_sGARCH_norm, e = ES_095_sGARCH_norm, alpha = 0.05, version = 1)
  g[1,9]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = VaR_0975_sGARCH_norm, e = ES_0975_sGARCH_norm, alpha = 0.025, version = 2)
  g[2,9]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = VaR_099_sGARCH_norm, e = ES_099_sGARCH_norm, alpha = 0.01, version = 1)
  g[3,9]<-k$pvalue_twosided_asymptotic
  
  c[1,10]<-stat(0.05, VaR_095_apARCH_sstd, ES_095_apARCH_sstd)
  c[2,10]<-stat(0.025, VaR_0975_apARCH_sstd, ES_0975_apARCH_sstd)
  c[3,10]<-stat(0.01, VaR_099_apARCH_sstd, ES_099_apARCH_sstd) 
  
  
  excerd= as.matrix(ret<VaR_095_apARCH_sstd);
  d[1,10]<- sum((-ret*excerd)/(nrow(excerd)*0.05*ES_095_apARCH_sstd))+1;
  excerd= as.matrix(ret<VaR_0975_apARCH_sstd);
  d[2,10]<- sum((-ret*excerd)/(nrow(excerd)*0.025*ES_0975_apARCH_sstd))+1; 
  excerd= as.matrix(ret<VaR_099_apARCH_sstd);
  d[3,10]<- sum((-ret*excerd)/(nrow(excerd)*0.01*ES_099_apARCH_sstd))+1; 
  
  k = esr_backtest(r = ret, q = VaR_095_apARCH_sstd, e = ES_095_apARCH_sstd, alpha = 0.05, version = 3)
  e[1,10]<-k$pvalue_onesided_asymptotic
  k = esr_backtest(r = ret, q = VaR_0975_apARCH_sstd, e = ES_0975_apARCH_sstd, alpha = 0.025, version = 3)
  e[2,10]<-k$pvalue_onesided_asymptotic
  k = esr_backtest(r = ret, q = VaR_099_apARCH_sstd, e = ES_099_apARCH_sstd, alpha = 0.01, version = 3)
  e[3,10]<-k$pvalue_onesided_asymptotic   

  
  k = esr_backtest(r = ret, q = VaR_095_apARCH_sstd, e = ES_095_apARCH_sstd, alpha = 0.05, version = 2)
  f[1,10]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = VaR_0975_apARCH_sstd, e = ES_0975_apARCH_sstd, alpha = 0.025, version = 2)
  f[2,10]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = VaR_099_apARCH_sstd, e = ES_099_apARCH_sstd, alpha = 0.01, version = 2)
  f[3,10]<-k$pvalue_twosided_asymptotic
  
  k = esr_backtest(r = ret, q = VaR_095_apARCH_sstd, e = ES_095_apARCH_sstd, alpha = 0.05, version = 1)
  g[1,10]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = VaR_0975_apARCH_sstd, e = ES_0975_apARCH_sstd, alpha = 0.025, version = 1)
  g[2,10]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = VaR_099_apARCH_sstd, e = ES_099_apARCH_sstd, alpha = 0.01, version = 1)
  g[3,10]<-k$pvalue_twosided_asymptotic
  
  c[1,11]<-stat(0.05, VaR_095_apARCH_sstd, ES_095_sGARCH_sstd)
  c[2,11]<-stat(0.025, VaR_0975_apARCH_sstd, ES_0975_sGARCH_sstd)
  c[3,11]<-stat(0.01, VaR_099_apARCH_sstd, ES_099_sGARCH_sstd)
  
  
  excerd= as.matrix(ret<VaR_095_sGARCH_sstd);
  d[1,11]<- sum((-ret*excerd)/(nrow(excerd)*0.05*ES_095_sGARCH_sstd))+1;
  excerd= as.matrix(ret<VaR_0975_sGARCH_sstd);
  d[2,11]<- sum((-ret*excerd)/(nrow(excerd)*0.025*ES_0975_sGARCH_sstd))+1; 
  excerd= as.matrix(ret<VaR_099_sGARCH_sstd);
  d[3,11]<- sum((-ret*excerd)/(nrow(excerd)*0.01*ES_099_sGARCH_sstd))+1; 
  
  k = esr_backtest(r = ret, q = VaR_095_sGARCH_sstd, e = ES_095_sGARCH_sstd, alpha = 0.05, version = 3)
  e[1,11]<-k$pvalue_onesided_asymptotic
  k = esr_backtest(r = ret, q = VaR_0975_sGARCH_sstd, e = ES_0975_sGARCH_sstd, alpha = 0.025, version = 3)
  e[2,11]<-k$pvalue_onesided_asymptotic
  k = esr_backtest(r = ret, q = VaR_099_sGARCH_sstd, e = ES_099_sGARCH_sstd, alpha = 0.01, version = 3)
  e[3,11]<-k$pvalue_onesided_asymptotic   
  
  
  k = esr_backtest(r = ret, q = VaR_095_sGARCH_sstd, e = ES_095_sGARCH_sstd, alpha = 0.05, version = 2)
  f[1,11]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = VaR_0975_sGARCH_sstd, e = ES_0975_sGARCH_sstd, alpha = 0.025, version = 2)
  f[2,11]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = VaR_099_sGARCH_sstd, e = ES_099_sGARCH_sstd, alpha = 0.01, version = 2)
  f[3,11]<-k$pvalue_twosided_asymptotic
  
  k = esr_backtest(r = ret, q = VaR_095_sGARCH_sstd, e = ES_095_sGARCH_sstd, alpha = 0.05, version = 1)
  g[1,11]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = VaR_0975_sGARCH_sstd, e = ES_0975_sGARCH_sstd, alpha = 0.025, version = 1)
  g[2,11]<-k$pvalue_twosided_asymptotic
  k = esr_backtest(r = ret, q = VaR_099_sGARCH_sstd, e = ES_099_sGARCH_sstd, alpha = 0.01, version = 1)
  g[3,11]<-k$pvalue_twosided_asymptotic
  
  
  options(width=250)
  
  

Loss_0975=cbind(POT_FZ0_loss_0975_Burr_none, POT_FZ0_loss_0975_Burr_expl,  POT_FZ0_loss_0975_GGamma_none, POT_FZ0_loss_0975_GGamma_expl,
                POT_FZ0_loss_0975_Weibull_none, POT_FZ0_loss_0975_Weibull_expl, POT_FZ0_loss_0975_DBurr_none, POT_FZ0_loss_0975_DBurr_expl,  
                POT_FZ0_loss_0975_DGGamma_none, POT_FZ0_loss_0975_DGGamma_expl, POT_FZ0_loss_0975_DWeibull_none, POT_FZ0_loss_0975_DWeibull_expl,  
                POT_FZ0_loss_0975_BNB_none, POT_FZ0_loss_0975_BNB_expl, FZ0_0975_apARCH_norm, FZ0_0975_sGARCH_norm, FZ0_0975_apARCH_sstd, FZ0_0975_sGARCH_sstd)

if (backtesting==20110101){
  path_model <- paste("output_data\\FZ0_Loss_0975_", stock, "_rolling_long.txt", sep="")}

if (backtesting==20190101){
  path_model <- paste("output_data\\FZ0_Loss_0975_", stock, "_rolling.txt", sep="")}

write.table(Loss_0975, path_model, append = FALSE, sep = " ", dec = ".",
            row.names = FALSE, col.names = FALSE);


Loss_095=cbind(POT_FZ0_loss_095_Burr_none, POT_FZ0_loss_095_Burr_expl,  POT_FZ0_loss_095_GGamma_none, POT_FZ0_loss_095_GGamma_expl,
               POT_FZ0_loss_095_Weibull_none, POT_FZ0_loss_095_Weibull_expl, POT_FZ0_loss_095_DBurr_none, POT_FZ0_loss_095_DBurr_expl,  
               POT_FZ0_loss_095_DGGamma_none, POT_FZ0_loss_095_DGGamma_expl, POT_FZ0_loss_095_DWeibull_none, POT_FZ0_loss_095_DWeibull_expl,  
               POT_FZ0_loss_095_BNB_none, POT_FZ0_loss_095_BNB_expl, FZ0_095_apARCH_norm, FZ0_095_sGARCH_norm, FZ0_095_apARCH_sstd, FZ0_095_sGARCH_sstd)

if (backtesting==20110101){
  path_model <- paste("output_data\\FZ0_Loss_095_", stock, "_rolling_long.txt", sep="")}

if (backtesting==20190101){
  path_model <- paste("output_data\\FZ0_Loss_095_", stock, "_rolling.txt", sep="")}

write.table(Loss_095, path_model, append = FALSE, sep = " ", dec = ".",
            row.names = FALSE, col.names = FALSE);

Loss_099=cbind(POT_FZ0_loss_099_Burr_none, POT_FZ0_loss_099_Burr_expl,  POT_FZ0_loss_099_GGamma_none, POT_FZ0_loss_099_GGamma_expl,
               POT_FZ0_loss_099_Weibull_none, POT_FZ0_loss_099_Weibull_expl, POT_FZ0_loss_099_DBurr_none, POT_FZ0_loss_099_DBurr_expl,  
               POT_FZ0_loss_099_DGGamma_none, POT_FZ0_loss_099_DGGamma_expl, POT_FZ0_loss_099_DWeibull_none, POT_FZ0_loss_099_DWeibull_expl,  
               POT_FZ0_loss_099_BNB_none, POT_FZ0_loss_099_BNB_expl, FZ0_099_apARCH_norm, FZ0_099_sGARCH_norm, FZ0_099_apARCH_sstd, FZ0_099_sGARCH_sstd)


if (backtesting==20110101){
  path_model <- paste("output_data\\FZ0_Loss_099_", stock, "_rolling_long.txt", sep="")}

if (backtesting==20190101){
  path_model <- paste("output_data\\FZ0_Loss_099_", stock, "_rolling.txt", sep="")}

write.table(Loss_099, path_model, append = FALSE, sep = " ", dec = ".",
            row.names = FALSE, col.names = FALSE);



# Diebold-Mariano tests

library(forecast);


# FZ0L for 95% VaR and ES



discrete_models=cbind(POT_FZ0_loss_095_DBurr_none, POT_FZ0_loss_095_DBurr_expl,  
                      POT_FZ0_loss_095_DGGamma_none, POT_FZ0_loss_095_DGGamma_expl, 
                      POT_FZ0_loss_095_DWeibull_none, POT_FZ0_loss_095_DWeibull_expl,  
                      POT_FZ0_loss_095_BNB_none, POT_FZ0_loss_095_BNB_expl)

continuous_models=cbind(POT_FZ0_loss_095_Burr_none, POT_FZ0_loss_095_Burr_expl,  
                        POT_FZ0_loss_095_GGamma_none, POT_FZ0_loss_095_GGamma_expl,
                        POT_FZ0_loss_095_Weibull_none, POT_FZ0_loss_095_Weibull_expl)


options(width=200)

tab= matrix(0, 8, 6)


for (i in c(1,2,3,4,5,6,7,8)){
  
  for (j in c(1,2,3,4,5,6)){
    
    ala <- dm.test(
      discrete_models[,i],
      continuous_models[,j],
      alternative = "less",
      h = 1,
      power = 1,
      varestimator = "acf"
    )
    
    tab[i, j]= ala$p.value
    
  }
}
tab_95 = round(tab, digits = 3)



# FZ0L for 97.5% VaR and ES

discrete_models=cbind(POT_FZ0_loss_0975_DBurr_none, POT_FZ0_loss_0975_DBurr_expl,  
                      POT_FZ0_loss_0975_DGGamma_none, POT_FZ0_loss_0975_DGGamma_expl, 
                      POT_FZ0_loss_0975_DWeibull_none, POT_FZ0_loss_0975_DWeibull_expl,  
                      POT_FZ0_loss_0975_BNB_none, POT_FZ0_loss_0975_BNB_expl)

continuous_models=cbind(POT_FZ0_loss_0975_Burr_none, POT_FZ0_loss_0975_Burr_expl,  
                        POT_FZ0_loss_0975_GGamma_none, POT_FZ0_loss_0975_GGamma_expl,
                        POT_FZ0_loss_0975_Weibull_none, POT_FZ0_loss_0975_Weibull_expl)

tab= matrix(0, 8, 6)


for (i in c(1,2,3,4,5,6,7,8)){
  
  for (j in c(1,2,3,4,5,6)){
    
    ala <- dm.test(
      discrete_models[,i],
      continuous_models[,j],
      alternative = "less",
      h = 1,
      power = 1,
      varestimator = "acf"
    )
    
    tab[i, j]= ala$p.value
    
  }
}
tab_975 = round(tab, digits = 3)


# FZ0L for 99% VaR and ES

discrete_models=cbind(POT_FZ0_loss_099_DBurr_none, POT_FZ0_loss_099_DBurr_expl,  
                      POT_FZ0_loss_099_DGGamma_none, POT_FZ0_loss_099_DGGamma_expl, 
                      POT_FZ0_loss_099_DWeibull_none, POT_FZ0_loss_099_DWeibull_expl, 
                      POT_FZ0_loss_099_BNB_none, POT_FZ0_loss_099_BNB_expl)

continuous_models=cbind(POT_FZ0_loss_099_Burr_none, POT_FZ0_loss_099_Burr_expl,  
                        POT_FZ0_loss_099_GGamma_none, POT_FZ0_loss_099_GGamma_expl,
                        POT_FZ0_loss_099_Weibull_none, POT_FZ0_loss_099_Weibull_expl)

tab= matrix(0, 8, 6)


for (i in c(1,2,3,4,5,6,7,8)){
  
  for (j in c(1,2,3,4,5,6)){
    
    ala <- dm.test(
      discrete_models[,i],
      continuous_models[,j],
      alternative = "less",
      h = 1,
      power = 1,
      varestimator = "acf"
    )
    
    tab[i, j]= ala$p.value
    
  }
}
tab_99 = round(tab, digits = 3)

if(stock=="DowJones"){
wynik_DowJones=cbind(tab_95, "||", tab_975, "||", tab_99);

rownames(wynik_DowJones) <- c("DB-RSPOT", "DB-SPOT",  "DGG-RSPOT", "DGG-SPOT", "DW-RSPOT", "DW-SPOT", "BNB-RSPOT", "BNB-SPOT");

colnames(wynik_DowJones) <- c("B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT", "||", "B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT", "||", "B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT");


aux_backtest_DowJones=round(cbind(f[, 1:7], f[, 9], f[, 11]),3);

rownames(aux_backtest_DowJones) <- c("alpha = 0.95", "alpha = 0.975",  "alpha = 0.99");

colnames(aux_backtest_DowJones) <- c("B-SPOT", "DB-SPOT",  "GG-SPOT", "DGG-SPOT", "W-SPOT", "DW-SPOT", "BNB-SPOT", "Gaussian GARCH", "Skew t GARCH");


strict_backtest_DowJones=round(cbind(g[, 1:7], g[, 9], g[, 11]),3);

rownames(strict_backtest_DowJones) <- c("alpha = 0.95", "alpha = 0.975",  "alpha = 0.99");

colnames(strict_backtest_DowJones) <- c("B-SPOT", "DB-SPOT",  "GG-SPOT", "DGG-SPOT", "W-SPOT", "DW-SPOT", "BNB-SPOT", "Gaussian GARCH", "Skew t GARCH")
}


if(stock=="NASDAQ"){

wynik_NASDAQ=cbind(tab_95, "||", tab_975, "||", tab_99);

rownames(wynik_NASDAQ) <- c("DB-RSPOT", "DB-SPOT",  "DGG-RSPOT", "DGG-SPOT", "DW-RSPOT", "DW-SPOT", "BNB-RSPOT", "BNB-SPOT");

colnames(wynik_NASDAQ) <- c("B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT", "||", "B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT", "||", "B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT");

aux_backtest_NASDAQ=round(cbind(f[, 1:7], f[, 9], f[, 11]),3);

rownames(aux_backtest_NASDAQ) <- c("alpha = 0.95", "alpha = 0.975",  "alpha = 0.99");

colnames(aux_backtest_NASDAQ) <- c("B-SPOT", "DB-SPOT",  "GG-SPOT", "DGG-SPOT", "W-SPOT", "DW-SPOT", "BNB-SPOT", "Gaussian GARCH", "Skew t GARCH");


strict_backtest_NASDAQ=round(cbind(g[, 1:7], g[, 9], g[, 11]),3);

rownames(strict_backtest_NASDAQ) <- c("alpha = 0.95", "alpha = 0.975",  "alpha = 0.99");

colnames(strict_backtest_NASDAQ) <- c("B-SPOT", "DB-SPOT",  "GG-SPOT", "DGG-SPOT", "W-SPOT", "DW-SPOT", "BNB-SPOT", "Gaussian GARCH", "Skew t GARCH");
}

if(stock=="SP500"){
wynik_SP500=cbind(tab_95, "||", tab_975, "||", tab_99);

rownames(wynik_SP500) <- c("DB-RSPOT", "DB-SPOT",  "DGG-RSPOT", "DGG-SPOT", "DW-RSPOT", "DW-SPOT", "BNB-RSPOT", "BNB-SPOT");

colnames(wynik_SP500) <- c("B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT", "||", "B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT", "||", "B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT");


aux_backtest_SP500=round(cbind(f[, 1:7], f[, 9], f[, 11]),3);

rownames(aux_backtest_SP500) <- c("alpha = 0.95", "alpha = 0.975",  "alpha = 0.99");

colnames(aux_backtest_SP500) <- c("B-SPOT", "DB-SPOT",  "GG-SPOT", "DGG-SPOT", "W-SPOT", "DW-SPOT", "BNB-SPOT", "Gaussian GARCH", "Skew t GARCH");


strict_backtest_SP500=round(cbind(g[, 1:7], g[, 9], g[, 11]),3);

rownames(strict_backtest_SP500) <- c("alpha = 0.95", "alpha = 0.975",  "alpha = 0.99");

colnames(strict_backtest_SP500) <- c("B-SPOT", "DB-SPOT",  "GG-SPOT", "DGG-SPOT", "W-SPOT", "DW-SPOT", "BNB-SPOT", "Gaussian GARCH", "Skew t GARCH");
}

if(stock=="Wilshire"){
wynik_Wilshire=cbind(tab_95, "||", tab_975, "||", tab_99);

rownames(wynik_Wilshire) <- c("DB-RSPOT", "DB-SPOT",  "DGG-RSPOT", "DGG-SPOT", "DW-RSPOT", "DW-SPOT", "BNB-RSPOT", "BNB-SPOT");

colnames(wynik_Wilshire) <- c("B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT", "||", "B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT", "||", "B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT");


aux_backtest_Wilshire=round(cbind(f[, 1:7], f[, 9], f[, 11]),3);

rownames(aux_backtest_Wilshire) <- c("alpha = 0.95", "alpha = 0.975",  "alpha = 0.99");

colnames(aux_backtest_Wilshire) <- c("B-SPOT", "DB-SPOT",  "GG-SPOT", "DGG-SPOT", "W-SPOT", "DW-SPOT", "BNB-SPOT", "Gaussian GARCH", "Skew t GARCH");


strict_backtest_Wilshire=round(cbind(g[, 1:7], g[, 9], g[, 11]),3);

rownames(strict_backtest_Wilshire) <- c("alpha = 0.95", "alpha = 0.975",  "alpha = 0.99");

colnames(strict_backtest_Wilshire) <- c("B-SPOT", "DB-SPOT",  "GG-SPOT", "DGG-SPOT", "W-SPOT", "DW-SPOT", "BNB-SPOT", "Gaussian GARCH", "Skew t GARCH");
}
}

# REPLICATION OUTPUT TO TEXT FILES:


# This is the replication of Table 4: 


sink(file="replicated_results\\Replicated_Table_4.txt", append=FALSE)


print("This is the replication of Table 4");

print("=================================================================================================================================================")

print("Dow Jones:");

titles <- c("B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT", "||", "B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT", "||", "B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT");

paste(c("     ", titles), collapse = "  ")

write.table(wynik_DowJones, "replicated_results\\Replicated_Table_4.txt",sep="\t", col.names=FALSE, row.names=TRUE , append=TRUE) ;



sink(file="replicated_results\\Replicated_Table_4.txt", append=TRUE)

print("=================================================================================================================================================")

print("NASDAQ:")

titles <- c("B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT", "||", "B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT", "||", "B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT");

paste(c("     ", titles), collapse = "  ")

write.table(wynik_NASDAQ, "replicated_results\\Replicated_Table_4.txt",sep="\t", col.names=FALSE, row.names=TRUE , append=TRUE) ;





print("=================================================================================================================================================")

print("SP 500:");

titles <- c("B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT", "||", "B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT", "||", "B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT");

paste(c("     ", titles), collapse = "  ")

write.table(wynik_SP500, "replicated_results\\Replicated_Table_4.txt",sep="\t", col.names=FALSE, row.names=TRUE , append=TRUE) ;




print("=================================================================================================================================================")

print("Wilshire 5000:");

titles <- c("B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT", "||", "B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT", "||", "B-RSPOT", "B-SPOT",  "GG-RSPOT", "GG-SPOT", "W-RSPOT", "W-SPOT");

paste(c("     ", titles), collapse = "  ")

write.table(wynik_Wilshire, "replicated_results\\Replicated_Table_4.txt",sep="\t", col.names=FALSE, row.names=TRUE , append=TRUE) ;

sink()

# This is the replication of Table 5

sink(file="replicated_results\\Replicated_Table_5.txt", append=FALSE)

# Strict ESR test p-value

print("This is the replication of Table 5");

print("Strict ESR test p-value")
strict_backtest_DowJones;

# Auxiliary ESR test p-value

print("Auxiliary ESR test p-value")
aux_backtest_DowJones;




sink()

sink(file="replicated_results\\Replicated_Table_G7.txt", append=FALSE)


# This is the replication of Table G7
print("This is the replication of Table G7");

# NASDAQ

# Strict ESR test p-value
print("=================================================================================================================================================")
print("NASDAQ:")
print("Strict ESR test p-value")
strict_backtest_NASDAQ;

# Auxiliary ESR test p-value

print("Auxiliary ESR test p-value")
aux_backtest_NASDAQ;

# SP500
print("=================================================================================================================================================")
print("SP 500:")

# Strict ESR test p-value

print("Strict ESR test p-value")
strict_backtest_SP500;

# Auxiliary ESR test p-value

print("Auxiliary ESR test p-value")
aux_backtest_SP500;

# Wilshire 5000
print("=================================================================================================================================================")
print("Wilshire 5000:")

# Strict ESR test p-value

print("Strict ESR test p-value")
strict_backtest_Wilshire;

# Auxiliary ESR test p-value

print("Auxiliary ESR test p-value")
aux_backtest_Wilshire;
sink()

end_time <- Sys.time()


# end_time - start_time
