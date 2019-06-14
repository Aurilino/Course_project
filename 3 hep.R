library(xlsx) #экспорт в Excel
library(Quandl) 


setwd("D:/Для учебы/Курсовая/Материалы/Фьючерсы") ## Директория с данными
a<-c("BR-7.18.csv")
b<-c("GOLD-6.18.csv")
c<-c("PLD-6.18.csv")
d<-c("PLT-6.18.csv")
e<-c("CL-6.18.csv")
f<-c("SILV-6.18.csv")


## Нефть Brent
df<-read.csv(a)
df<-df[,c(1,7)]
colnames(df)<-c("Date","Price")
df<-na.omit(df);head(df)
df$Date<-as.Date(df$Date,format="%d.%m.%Y");class(df$Date)
df$Price<-as.numeric(df$Price);class(df$Price)
write.xlsx(df,file = "dfB.xlsx")

 
## Золото 
df<-read.csv(b)
df<-df[,c(1,7)] 
colnames(df)<-c("Date","Price")
df<-na.omit(df);head(df)
df$Date<-as.Date(df$Date,format="%d.%m.%Y");class(df$Date)
df$Price<-as.numeric(df$Price);class(df$Price)
write.xlsx(df,file = "dfG.xlsx")


## Серебро
df<-read.csv(f)
df<-df[,c(1,7)] 
colnames(df)<-c("Date","Price")
df<-na.omit(df);head(df)
df$Date<-as.Date(df$Date,format="%d.%m.%Y");class(df$Date)
df$Price<-as.numeric(df$Price);class(df$Price)
write.xlsx(df,file = "dfS.xlsx")


## ПлатинаС‹
df<-read.csv(d)
df<-df[,c(1,7)] 
colnames(df)<-c("Date","Price")
df<-na.omit(df);head(df)
df$Date<-as.Date(df$Date,format="%d.%m.%Y");class(df$Date)
df$Price<-as.numeric(df$Price);class(df$Price)
write.xlsx(df,file = "dfPL.xlsx")


## Палладий
df<-read.csv(c)
df<-df[,c(1,7)] 
colnames(df)<-c("Date","Price")
df<-na.omit(df);head(df)
df$Date<-as.Date(df$Date,format="%d.%m.%Y");class(df$Date)
df$Price<-as.numeric(df$Price);class(df$Price)
write.xlsx(df,file = "dfPD.xlsx")

## Нефть Sweet
df<-read.csv(e)
df<-df[,c(1,7)] 
colnames(df)<-c("Date","Price")
df<-na.omit(df);head(df)
df$Date<-as.Date(df$Date,format="%d.%m.%Y");class(df$Date)
df$Price<-as.numeric(df$Price);class(df$Price)
write.xlsx(df,file = "dfSW.xlsx")

## Обработка данных по нефти Brent
ICE.BRN<-Quandl("ICE/BM2018") ## Brent Crude Futures
ICE.BRN<-ICE.BRN[,c(1,5)] 
colnames(ICE.BRN)<-c("Date","Price") 
write.xlsx(ICE.BRN,file = "dfICE.xlsx")
## Вычисления продолжим в Excel