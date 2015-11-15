# This script does a basic logistic regression on all the data per category and
# see what we get

library(scatterplot3d)

crime_data_no_outlier <- read.csv("/Users/christopherhowlin/Documents/DataScience/Datasets/SFCrime/train-no-outlier_2014.csv", header = T, comment.char = "#")
crime_data_working <- crime_data_no_outlier

get_levels <- function()
{
  return (c("ARSON","ASSAULT","BAD CHECKS","BRIBERY","BURGLARY","DISORDERLY CONDUCT",
           "DRIVING UNDER THE INFLUENCE","DRUG/NARCOTIC","DRUNKENNESS","EMBEZZLEMENT",
           "EXTORTION","FAMILY OFFENSES","FORGERY/COUNTERFEITING","FRAUD","GAMBLING",
           "KIDNAPPING","LARCENY/THEFT","LIQUOR LAWS","LOITERING","MISSING PERSON",
           "NON-CRIMINAL","OTHER OFFENSES","PORNOGRAPHY/OBSCENE MAT","PROSTITUTION",
           "RECOVERED VEHICLE","ROBBERY","RUNAWAY","SECONDARY CODES","SEX OFFENSES FORCIBLE",
           "SEX OFFENSES NON FORCIBLE","STOLEN PROPERTY","SUICIDE","SUSPICIOUS OCC","TREA",
           "TRESPASS","VANDALISM","VEHICLE THEFT","WARRANTS","WEAPON LAWS"))
}

get_time_of_day <- function(dates)
{
  posix_lt <- as.POSIXlt(dates)
  time_of_day <- posix_lt$hour*60 + posix_lt$min
}

crime_data_working$Descript <- NULL
crime_data_working$Resolution <- NULL
crime_data_working$Address <- NULL
crime_data_working$PdDistrict <- NULL
crime_data_working$DayOfWeek <- NULL
crime_data_working$Category <- as.factor(crime_data_working$Category)
crime_data_working$Dates <- as.POSIXct(crime_data_working$Dates)
crime_data_working$Times <- get_time_of_day(crime_data_working$Dates)

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

logit.fit <- glm(isLarceny ~ X + Y + Times, family='binomial', data=crime_data_working)
summary(logit.fit)

crime.test <- read.csv("/Users/christopherhowlin/Documents/DataScience/Datasets/SFCrime/test.csv", header = T, comment.char = "#")

crime.test$Dates <- as.POSIXct(crime.test$Dates)
crime.test$Times <- get_time_of_day(crime.test$Dates)

crime.predict <- predict(logit.fit, newdata=crime.test,type='response') #type=response will expoentiate the output to give the odds,

get_test_predictions <- function(input_data, test_data, category)
{
  L = input_data$Category == category
  input_data$isCategory <- L

  logit.fit <- glm(isCategory ~ X + Y + Times, family='binomial', data=input_data)
  predictions <- predict(logit.fit, newdata=test_data,type='response')

  return(predictions)
}

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

fileConn<-file("/Users/christopherhowlin/Documents/DataScience/Project/SFCrime_Kaggle/BasicLogisticRegression/submissionBasic.csv", open="w")
write.csv(predict.df, fileConn, row.names=F, quote=F)
close(fileConn)
