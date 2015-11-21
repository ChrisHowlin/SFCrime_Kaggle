# R script for generating Kaggle submission using a random estimation of crime
# of the test.csv set.
#
# The random distribution is based on the total distribution of crime categories
# from the training set and generating a random output based on the district
# and the weighted output of the prior distribution

source("../lib/crime_utilities.R")
source("../lib/logistic_utilities.R")
library(lubridate)

print("Reading training file")

# Firstly generate the distributions based on the training set
# 2014!!
crime_data_no_outlier <- read_crime_data("/Users/christopherhowlin/Documents/DataScience/Datasets/SFCrime/train-no-outlier_2014.csv")
crime_data_working <- crime_data_no_outlier

print("Shuffling data")
#Randomly shuffle the data
crime_data_shuffled <-crime_data_working[sample(nrow(crime_data_working)),]

FOLDS <- 5
pd_ll <- cross_validate_logistic_regression(crime_data_shuffled, as.formula("isCategory ~ PdDistrict"), FOLDS)
pd_t_ll <- cross_validate_logistic_regression(crime_data_shuffled, as.formula("isCategory ~ PdDistrict + Times"), FOLDS)
pd_t_m_y_ll <- cross_validate_logistic_regression(crime_data_shuffled, as.formula("isCategory ~ PdDistrict + Times + Month + Year"), FOLDS)

colnames(predict.df) <- c("Id", levels(crime_data_working$Category))

options(digits = 10)
options(scipen=999)

fileConn<-file("precinct_only.csv", open="w")
write.csv(predict.df, fileConn, row.names=F, quote=F)
close(fileConn)
