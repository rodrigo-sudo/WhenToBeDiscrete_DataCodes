
library(zoo)
library(tseries)
library(evd)
library(exdex)

PP<-  function (values, p){
  threshold<-quantile(values,p)
  n <- length(values)
  
  starttime <- 0
  alltimes<-c(1:n)
  times <- alltimes[values> threshold]
  timesT <-c(times,n)
  durations<-diff(c(0,times))
  durations<-durations[durations>0]
  endtime<-times[length(times)]
  durationsT<-diff(c(0,timesT))
  durationsT<-durationsT[durationsT>0]
  marks <- values[values > threshold] - threshold
  marksT<-c(marks,0)
  out <- list(times = times, marks = marks, durations=durations,starttime = starttime,
              endtime = endtime, threshold = threshold,values=values,marksT=marksT,timesT=timesT,durationsT=durationsT)
  oldClass(out) <- c("MPP")
  out
}


yt<-read.csv("DataManuscript.csv")



theta11<-round(exi(yt[,1],quantile(yt[,1], 0.9),r=0),2)
theta12<-round(exi(yt[,1],quantile(yt[,1],0.93),r=0),2)
theta13<-round(exi(yt[,1],quantile(yt[,1],0.95),r=0),2)

theta21<-round(exi(yt[,2],quantile(yt[,2], 0.9),r=0),2)
theta22<-round(exi(yt[,2],quantile(yt[,2],0.93),r=0),2)
theta23<-round(exi(yt[,2],quantile(yt[,2],0.95),r=0),2)

theta31<-round(exi(yt[,3],quantile(yt[,3], 0.9),r=0),2)
theta32<-round(exi(yt[,3],quantile(yt[,3],0.93),r=0),2)
theta33<-round(exi(yt[,3],quantile(yt[,3],0.95),r=0),2)

theta41<-round(exi(yt[,4],quantile(yt[,4], 0.9),r=0),2)
theta42<-round(exi(yt[,4],quantile(yt[,4],0.93),r=0),2)
theta43<-round(exi(yt[,4],quantile(yt[,4],0.95),r=0),2)


out<-rbind(c(0.1,theta41,theta31,theta21,theta11),
      c(0.07,theta42,theta32,theta22,theta12),
      c(0.05,theta43,theta33,theta23,theta13))
colnames(out)<-c("Threshold%","Dow Jones","Nasdaq","S&P 500","Wilshire")
print(out)
