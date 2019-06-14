library(xlsx) #экспорт в Excel
library(zoo) #работа с датами
library(ggplot2) # для графиков

## Загрузим данные по июньскому фьючерсу на нефть Brent
setwd("D:/Для учебы/Курсовая/Материалы/Фьючерсы") ## Директория с данными
BR<-read.csv("BR-7.18.csv")
BR<-BR[,c(1,7)]## Оставим столбцы с датами и ценами закрытия
colnames(BR)<-c("date","Brent")
BR<-na.locf(BR)
BR<-na.omit(BR);head(BR)
BR$date<-as.Date(BR$date,format="%d.%m.%Y");class(BR$date)
BR$Brent<-as.numeric(BR$Brent);class(BR$Brent)

## Загрузим данные по опциона пут со страйками 75:70 
setwd("D:/Для учебы/Курсовая/Материалы/Опционы") ## Директория с данными
a<-read.csv("BR 75.csv")
b<-read.csv("BR 74.csv")
c<-read.csv("BR 73.csv")
d<-read.csv("BR 72.csv")
e<-read.csv("BR 71.csv")
f<-read.csv("BR 70.csv")

## оставим данные с датой и расчетной ценой
a<-a[,c(1,3)];colnames(a)<-c("date","BR75")
b<-b[,c(1,3)];colnames(b)<-c("date","BR74")
c<-c[,c(1,3)];colnames(c)<-c("date","BR73")
d<-d[,c(1,3)];colnames(d)<-c("date","BR72")
e<-e[,c(1,3)];colnames(e)<-c("date","BR71")
f<-f[,c(1,3)];colnames(f)<-c("date","BR70")
a$date<-as.Date(a$date,format="%d.%m.%Y");class(a$date)
b$date<-as.Date(b$date,format="%d.%m.%Y");class(b$date)
c$date<-as.Date(c$date,format="%d.%m.%Y");class(c$date)
d$date<-as.Date(d$date,format="%d.%m.%Y");class(d$date)
e$date<-as.Date(e$date,format="%d.%m.%Y");class(e$date)
f$date<-as.Date(f$date,format="%d.%m.%Y");class(f$date)

## Объединим данные
Op<-merge(a,b,by="date")
Op<-merge(Op,c,by="date")
Op<-merge(Op,d,by="date")
Op<-merge(Op,e,by="date")
Op<-merge(Op,f,by="date")
Op<-merge(Op,BR,by="date");head(Op)

## Расчитаем изменения
df<-data.frame(date=Op$date[-1],BR70=diff(log(Op$BR70),lag=1),BR71=diff(log(Op$BR71),lag=1),BR72=diff(log(Op$BR72),lag=1),BR73=diff(log(Op$BR73),lag=1),BR74=diff(log(Op$BR74),lag=1),BR75=diff(log(Op$BR75),lag=1),Brent=diff(log(Op$Brent),lag=1));head(df)

## Выгрузим полученные данные в Excel
setwd("D:/Для учебы/Курсовая/Рабочая папка/Расчеты") ## зададим папку, куда нужно сохранять файлы
write.xlsx(df,"option.diff.xlsx")
write.xlsx(Op,"option.base.xlsx")
## Все остальные расчеты проводим в Excel




