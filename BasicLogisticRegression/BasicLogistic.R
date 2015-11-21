# This script does a basic logistic regression on all the data per category and
# see what we get. Uses only 2014 data for training.

source("logistic_utilities.R")
source("../lib/crime_utilities.R")
library(scatterplot3d)

crime_data_no_outlier <- read_crime_data("/Users/christopherhowlin/Documents/DataScience/Datasets/SFCrime/train-no-outlier_2014.csv")
crime_data_working <- crime_data_no_outlier

crime_data_working$Descript <- NULL
crime_data_working$Resolution <- NULL
crime_data_working$Address <- NULL

L = crime_data_working$Category == "LARCENY/THEFT"
crime.larceny <- crime_data_working[L,]
crime_data_working$isLarceny <- L

NC = crime_data_working$Category == "NON-CRIMINAL"
crime.noncriminal <- crime_data_working[NC,]

A = crime_data_working$Category == "ASSAULT"
crime.assault <- crime_data_working[A,]

hist(crime_data_working$Times)
hist(crime.larceny$Times)
hist(crime.noncriminal$Times)
hist(crime.assault$Times)

scatterplot3d(crime.larceny$X, crime.larceny$Y, crime.larceny$Times, main="3D Scatterplot")

crime.test <- read_crime_data("/Users/christopherhowlin/Documents/DataScience/Datasets/SFCrime/test.csv")

predict.df <- crime.test$Id
DECIMAL_LIMIT <- 5
levels(crime_data_working$Category) <- get_levels()
for(category in levels(crime_data_working$Category))
{
  print(category)
  predict.df <- cbind(predict.df,
                      format(round(get_test_predictions(crime_data_working, crime.test, category), DECIMAL_LIMIT), nsmall = DECIMAL_LIMIT))
}

colnames(predict.df) <- c("Id", levels(crime_data_working$Category))

options(digits = 10)
options(scipen=999)

fileConn<-file("/Users/christopherhowlin/Documents/DataScience/Project/SFCrime_Kaggle/BasicLogisticRegression/submissionBasic-2014.csv", open="w")
write.csv(predict.df, fileConn, row.names=F, quote=F)
close(fileConn)
