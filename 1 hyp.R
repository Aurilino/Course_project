## Проверим гипотезу о постоянном и стабильном ссужении спреда между ближним и дальним контрактом

library(Quandl) ## Загрузка данных из Quandlа
library(zoo) ## Работа с временными рядами
library(lubridate) ## Работа с датами
library(rvest) ## web-скраплинг
library(ggplot2) ## гафики

## За основу возьмем фьючерсы московской биржи с датой экспирации (Ближний 01.06.2018 и Дальний 03.09.2018)

ICE.BRN<-Quandl("ICE/BM2018") ## Загрузим данные по июньскому фьючерсу Brent Crude Futures
ICE.BRN<-ICE.BRN[,c(1,5)] ## Оставляем только столбцы с датамыи ценами
colnames(ICE.BRN)<-c("Date","Price") ## Переименовываем 

## Зададим даты 
date_1<-as.Date("2018-06-01")
date_2<-as.Date("2018-09-03")

## Создадим в данных ICE.BRN столбцы с t1 - время до истечения ближенго контракта и t2 - время до истечения дальнего контракта
ICE.BRN$t1<-date_1 - ICE.BRN$Date
ICE.BRN$t2<-date_2 - ICE.BRN$Date

## Добавим столбец с данними по ставке межбанковского кредитования MOSPRIME

url<-"http://mosprime.com/period.html?d1=16.11.2009&d2=30.04.2018&b=-1"
M_P <- url %>%
  read_html() %>%
  html_nodes(xpath='//*[@id="content"]/table') %>%
  .[[1]] %>%
  html_table()
M_P<-M_P[,c(1,5)] ## оставим только месячные данные по ставке MOSPRIME
colnames(M_P)<-c("Date","M")
## Обработаем данные по MOSPRIME
M_P$Date<-as.Date(M_P$Date, format='%d.%m.%Y')
M_P$M<-gsub(',','.',M_P$M)
M_P$M<-as.numeric(M_P$M); head(M_P)

## добавим ставки MOSPRIME к данным по нефти
BRN<-merge(ICE.BRN,M_P,by='Date');head(BRN)
BRN$t1<-as.numeric(BRN$t1);BRN$t2<-as.numeric(BRN$t2);head(BRN)
BRN$t1<-(BRN$t1/365)
BRN$t2<-(BRN$t2/365)
## Расчитаем все данные для одинаковой цены и ставки
BRN$Price<-100 
BRN$M<-0.035
BRN$rt1<-(BRN$t1*BRN$M)
BRN$rt2<-(BRN$t2*BRN$M);head(BRN)
## Расчитаем стоимость ближнего и дальнего фьючерса
BRN$P1<-BRN$Price*exp(BRN$rt1)
BRN$P2<-BRN$Price*exp(BRN$rt2);head(BRN)
## РАсчитаем спред между 2мя контрактами
BRN$Spread<-BRN$P2-BRN$P1;head(BRN)
plot(BRN$Spread,type = "l",main="спред между 2мя контрактами",xlab = "Пройденное время", ylab = "Спред")
plot(BRN$P1+BRN$P2)
