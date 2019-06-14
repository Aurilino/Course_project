## Проверим гепотизу о возврате цены фьючерса к теоретическому значению

library(Quandl) ## Загрузка данных из Quandlа
library(rvest) ## web-скраплинг
 

## Загрузим данные оп Brent
ICE.BRN<-Quandl("ICE/BM2018") ## Загрузим данные по июньскому фьючерсу Brent Crude Futures
ICE.BRN<-ICE.BRN[,c(1,5)] ## Оставляем только столбцы с датамыи ценами
colnames(ICE.BRN)<-c("Date","Price") ## Переименовываем 

## Загрузим данные оп MOSPRIME
url<-"http://mosprime.com/period.html?d1=16.11.2009&d2=30.04.2018&b=-1"
M_P <- url %>%
  read_html() %>%
  html_nodes(xpath='//*[@id="content"]/table') %>%
  .[[1]] %>%
  html_table()
M_P<-M_P[,c(1,2)] ## оставим только данные по ставке MOSPRIME overnight
colnames(M_P)<-c("Date","M")
## Обработаем данные по MOSPRIME
M_P$Date<-as.Date(M_P$Date, format='%d.%m.%Y')
M_P$M<-gsub(',','.',M_P$M)
M_P$M<-as.numeric(M_P$M)
M_P$M<-M_P$M/100; head(M_P)

## Загрузим данные по фьючерсу
setwd("D:/Для учебы/Курсовая/Материалы/Фьючерсы") ## Укажим путь к файлам с данными по фьючерсам
a<-c("BR-5.18.csv") ## Зададим фьючерс на Brent с экспирацией в мае
BR<-read.csv(a) 
BRv<-read.csv(a)
BR<-BR[,c(1,7)]
BRv<-BRv[,c(1,10)]
colnames(BR)<-c("Date","Brent")
colnames(BRv)<-c("Date","Volume")
BR$Date<-as.Date(BR$Date, format='%d.%m.%Y')
BR$Brent<-na.locf(BR$Brent);head(BR)
date<-c('02.05.2018');date<-as.Date(date,format='%d.%m.%Y');head(date) ## Дата экспирации фьючерса

## Объединим данные
df<-merge(ICE.BRN,M_P,by='Date')
df$t<-date-df$Date; df$t<-as.numeric(df$t);head(df)
df$t<-df$t/365
df<-merge(BR,df,by="Date")
df<-na.omit(df);head(df)

## Расчитаем теоритическую цену
df$rt<-df$M*df$t ## Расчитаем r*t 
df$e<-exp(df$rt) ## Расчитаем 'r^(r*t)'
df$TP<-df$Price*df$e;head(df) ## Найдем теоритическую цену
df<-df[,-c(3,4,5,6,7)];head(df)## Удалим лишнии колонки

## Найдем разность между теоритической и фактической ценной
df$diff<-df$Brent-df$TP;head(df)
plot(df$diff,main="Разница между ценой нефти Brent и её теоритической ценой", xlab="Время",ylab="Разница")
BRv<-na.omit(BRv)
plot(BRv$Volume,main="График объемов торгов по нефт Brent",xlab="Время",ylab="объем",type="l")

## Сравним данную гипотезу с фьючеросом на золото

## Загрузим данные по Золоту

GD<-Quandl("LBMA/GOLD")
GD<-GD[,c(1,3)];head(GD) ## Оставим только данные с датами и закрытиемторгов
colnames(GD)<-c("Date","Price")
class(GD$Date);class(GD$Price)
## Загрузим даные по фьючерсу московскоой биржи

b<-c("GOLD-3.18.csv") ## Зададим фьючерс по золоту с экспирацией в марте
G<-read.csv(b) 
Gv<-read.csv(b)
G<-G[,c(1,7)]
Gv<-Gv[,c(1,11)]
colnames(G)<-c("Date","Gold")
colnames(Gv)<-c("Date","Volume")
G$Date<-as.Date(G$Date, format='%d.%m.%Y');class(G$Date)
G$Gold<-as.numeric(G$Gold);class(G$Gold)
date<-c('21.06.2018');date<-as.Date(date,format='%d.%m.%Y');head(date) ## Дата экспирации фьючерса

## Объединим данные
dfg<-merge(GD,M_P,by='Date')
dfg$t<-date-dfg$Date; dfg$t<-as.numeric(dfg$t)
dfg$t<-dfg$t/365;head(dfg)
dfg<-merge(G,dfg,by="Date")
dfg<-na.locf(dfg)
dfg<-na.omit(dfg);head(dfg)
dfg$Date<-as.Date(dfg$Date);class(dfg$Date)
dfg$Gold<-as.numeric(dfg$Gold);class(dfg$Gold)
dfg$Price<-as.numeric(dfg$Price);class(dfg$Price)
dfg$M<-as.numeric(dfg$M);class(dfg$M)
dfg$t<-as.numeric(dfg$t);class(dfg$t)


## Расчитаем теоритическую цену
dfg$rt<-dfg$M*dfg$t ## Расчитаем r*t 
dfg$e<-exp(dfg$rt);dfg$e<-as.numeric(dfg$e) ## Расчитаем 'r^(r*t)'
dfg$TP<-dfg$Price*dfg$e;head(dfg) ## Найдем теоритическую цену
dfg<-dfg[,-c(3,4,5,6,7)];head(dfg)## Удалим лишнии колонки

## Найдем разность между теоритической и фактической ценной
dfg$diff<-dfg$Gold-dfg$TP;head(dfg)
plot(dfg$diff,main="Разница между ценой золота и его теоритической ценой", xlab="Время",ylab="Разница")
Gv<-na.omit(Gv)
plot(Gv$Volume,main="График объемов торгов по золоту",xlab="Время",ylab="объем",type="l")

## Сравним данную гипотезу с фьючеросом на серебро

## Загрузим данные по Золоту

SV<-Quandl("LBMA/SILVER")
SV<-SV[,c(1,2)];head(SV) ## Оставим только данные с датами и закрытием торгов
colnames(SV)<-c("Date","Price")
class(SV$Date);class(SV$Price)
## Загрузим даные по фьючерсу московскоой биржи

c<-c("SILV-3.18.csv") ## Зададим фьючерс серебра с экспирацией в марте
S<-read.csv(c) 
Sv<-read.csv(c)
S<-S[,c(1,7)]
Sv<-Sv[,c(1,11)]
colnames(S)<-c("Date","Silver")
colnames(Sv)<-c("Date","Volume")
class(S$Date)
S$Date<-as.Date.factor(S$Date, format='%d.%m.%Y');class(S$Date)
S$Silver<-as.numeric(S$Silver);class(S$Silver)
date<-c('15.03.2018');date<-as.Date(date,format='%d.%m.%Y');class(date);head(date) ## Дата экспирации фьючерса

## Объединим данные
dfg<-merge(SV,M_P,by='Date')
dfg$t<-date-dfg$Date; dfg$t<-as.numeric(dfg$t)
dfg$t<-dfg$t/365;head(dfg)
dfg<-merge(S,dfg,by="Date")
dfg<-na.locf(dfg)
dfg<-na.omit(dfg);head(dfg)
dfg$Date<-as.Date(dfg$Date);class(dfg$Date)
dfg$Silver<-as.numeric(dfg$Silver);class(dfg$Silver)
dfg$Price<-as.numeric(dfg$Price);class(dfg$Price)
dfg$M<-as.numeric(dfg$M);class(dfg$M)
dfg$t<-as.numeric(dfg$t);calss(dfg$t)


## Расчитаем теоритическую цену
dfg$rt<-dfg$M*dfg$t ## Расчитаем r*t 
dfg$e<-exp(dfg$rt);dfg$e<-as.numeric(dfg$e) ## Расчитаем 'r^(r*t)'
dfg$TP<-dfg$Price*dfg$e;head(dfg) ## Найдем теоритическую цену
dfg<-dfg[,-c(3,4,5,6,7)];head(dfg)## Удалим лишнии колонки

## Найдем разность между теоритической и фактической ценной
dfg$diff<-dfg$Silver-dfg$TP;head(dfg)
plot(dfg$diff,main="Разница между ценой серебра и его теоритической ценой", xlab="Время",ylab="Разница")
Sv<-na.omit(Sv)
plot(Sv$Volume,main="График объемов торгов по серебру",xlab="Время",ylab="объем",type="l")



