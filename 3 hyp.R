library(xlsx) #экспорт в Excel
library(zoo) #работа с датами
setwd("D:/Для учебы/Курсовая/Материалы/Фьючерсы") ## Директория с данными

## Загрузим контракты с разной датой экспирации
aa<-read.csv("BR-7.18.csv")
ab<-read.csv("BR-8.18.csv")
ac<-read.csv("BR-9.18.csv")

ba<-read.csv("CL-6.18.csv")
bb<-read.csv("CL-9.18.csv")

## Оставим только даты и цены закрытия
aa<-aa[,c(1,7)]
ab<-ab[,c(1,7)]
ac<-ac[,c(1,7)]

ba<-ba[,c(1,7)]
bb<-bb[,c(1,7)]

colnames(aa)<-c('Date','Price BR-7.18')
colnames(ab)<-c('Date','Price BR-8.18')
colnames(ac)<-c('Date','Price BR-9.18')

colnames(ba)<-c('Date','CL-6.18')
colnames(bb)<-c('Date','CL-9.18')

## Объединим данные 
a<-merge(aa,ab,by='Date')
b<-merge(aa,ac,by='Date')
c<-merge(ab,ac,by='Date')

z<-merge(ba,bb,by='Date')

## Избавимся от пропущеных значений
a<-na.locf(a)
b<-na.locf(b)
c<-na.locf(c)

z<-na.locf(z)

a<-na.omit(a)
b<-na.omit(b)
c<-na.locf(c)

z<-na.omit(z)

a$`Price BR-7.18`<-as.numeric(a$`Price BR-7.18`);class(a$`Price BR-7.18`)
a$`Price BR-8.18`<-as.numeric(a$`Price BR-8.18`);class(a$`Price BR-8.18`)
b$`Price BR-7.18`<-as.numeric(b$`Price BR-7.18`);class(b$`Price BR-7.18`)
b$`Price BR-9.18`<-as.numeric(b$`Price BR-9.18`);class(b$`Price BR-9.18`)
c$`Price BR-8.18`<-as.numeric(c$`Price BR-8.18`);class(c$`Price BR-8.18`)
c$`Price BR-9.18`<-as.numeric(c$`Price BR-9.18`);class(c$`Price BR-9.18`)
z$`CL-6.18`<-as.numeric(z$`CL-6.18`);class(z$`CL-6.18`)
z$`CL-9.18`<-as.numeric(z$`CL-9.18`);class(z$`CL-9.18`)

## Расчтитпем спреды
a$Spead<-a$`Price BR-8.18`-a$`Price BR-7.18`;head(a)
b$Spead<-b$`Price BR-9.18`-b$`Price BR-7.18`;head(b)
c$Spread<-c$`Price BR-9.18`-c$`Price BR-8.18`;head(c)
z$Spead<-z$`CL-9.18`-z$`CL-6.18`;head(z)


## Сохраним данные контраты в Excel
setwd("D:/Для учебы/Курсовая/Рабочая папка/Расчеты") ## зададим папку, куда нужно сохранять файлы
write.xlsx(a,'a.xlsx')
write.xlsx(b,'b.xlsx')
write.xlsx(c,'c.xlsx')
write.xlsx(z,'z.xlsx')

## Все остальные расчеты проводим в Excel 
