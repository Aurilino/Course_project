## �������� �������� � ���������� � ���������� �������� ������ ����� ������� � ������� ����������

library(Quandl) ## �������� ������ �� Quandl�
library(zoo) ## ������ � ���������� ������
library(lubridate) ## ������ � ������
library(rvest) ## web-���������
library(ggplot2) ## ������

## �� ������ ������� �������� ���������� ����� � ����� ���������� (������� 01.06.2018 � ������� 03.09.2018)

ICE.BRN<-Quandl("ICE/BM2018") ## �������� ������ �� ��������� �������� Brent Crude Futures
ICE.BRN<-ICE.BRN[,c(1,5)] ## ��������� ������ ������� � ������� ������
colnames(ICE.BRN)<-c("Date","Price") ## ��������������� 

## ������� ���� 
date_1<-as.Date("2018-06-01")
date_2<-as.Date("2018-09-03")

## �������� � ������ ICE.BRN ������� � t1 - ����� �� ��������� �������� ��������� � t2 - ����� �� ��������� �������� ���������
ICE.BRN$t1<-date_1 - ICE.BRN$Date
ICE.BRN$t2<-date_2 - ICE.BRN$Date

## ������� ������� � ������� �� ������ �������������� ������������ MOSPRIME

url<-"http://mosprime.com/period.html?d1=16.11.2009&d2=30.04.2018&b=-1"
M_P <- url %>%
  read_html() %>%
  html_nodes(xpath='//*[@id="content"]/table') %>%
  .[[1]] %>%
  html_table()
M_P<-M_P[,c(1,5)] ## ������� ������ �������� ������ �� ������ MOSPRIME
colnames(M_P)<-c("Date","M")
## ���������� ������ �� MOSPRIME
M_P$Date<-as.Date(M_P$Date, format='%d.%m.%Y')
M_P$M<-gsub(',','.',M_P$M)
M_P$M<-as.numeric(M_P$M); head(M_P)

## ������� ������ MOSPRIME � ������ �� �����
BRN<-merge(ICE.BRN,M_P,by='Date');head(BRN)
BRN$t1<-as.numeric(BRN$t1);BRN$t2<-as.numeric(BRN$t2);head(BRN)
BRN$t1<-(BRN$t1/365)
BRN$t2<-(BRN$t2/365)
## ��������� ��� ������ ��� ���������� ���� � ������
BRN$Price<-100 
BRN$M<-0.035
BRN$rt1<-(BRN$t1*BRN$M)
BRN$rt2<-(BRN$t2*BRN$M);head(BRN)
## ��������� ��������� �������� � �������� ��������
BRN$P1<-BRN$Price*exp(BRN$rt1)
BRN$P2<-BRN$Price*exp(BRN$rt2);head(BRN)
## ��������� ����� ����� 2�� �����������
BRN$Spread<-BRN$P2-BRN$P1;head(BRN)
plot(BRN$Spread,type = "l",main="����� ����� 2�� �����������",xlab = "���������� �����", ylab = "�����")
plot(BRN$P1+BRN$P2)
