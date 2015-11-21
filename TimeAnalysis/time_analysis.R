# R script for analysing the time dimension of the crime data

library(lubridate)  # for date manipulation

crime_data_no_outlier <- read.csv("/Users/christopherhowlin/Documents/DataScience/Datasets/SFCrime/train-no-outlier.csv", header = T, comment.char = "#")
crime_data_working <- crime_data_no_outlier

crime_data_working$Category <- as.factor(crime_data_no_outlier$Category)

# Plot crimes using coordinates provided - 30 seconds
plot(crime_data_no_outlier$X, crime_data_no_outlier$Y, col=crime_data_working$Category)

crime.hours <- hour(crime_data_no_outlier$Dates)

crime_data_working <- cbind(crime_data_working, crime.hours)

names(crime_data_working)
names(crime_data_working) <- cbind(names(crime_data_working), "Hours")

crime_by_hours <- split(crime_data_working, crime_data_working$crime.hours)

crime_hour <- as.data.frame(crime_by_hours[1])
plot(crime_hour$X0.X, crime_hour$X0.Y, col=crime_hour$X0.Category, main=sprintf("Hour = %d", hour))

for(hour in 1:length(crime_by_hours))
{
  crime_hour <- crime_by_hours[hour]
  plot(crime_hour$X, crime_hour$Y, col=crime_hour$Category, main=sprintf("Hour = %d", hour))
}

normalise_crime_distribution <- function(distribution, normalization_target = 1)
{
  # Find the sum of each column and determine the normalisation factor so
  # normalised sum matches normalisation_target
  col_sums.total <- colSums(distribution)
  col_sums.normalised <- normalization_target / col_sums.total
  normalized_distribution <- distribution
  for(col in 1:ncol(distribution))
  {
    normalized_distribution[,col] <- distribution[,col] * col_sums.normalised[col]
  }

  return(normalized_distribution)
}

generate_cumulative_crimes <- function(distribution)
{
  cumulative_df <- distribution

  for(row in 2:nrow(cumulative_df))
  {
    cumulative_df[row,]
    cumulative_df[row-1, ]
    cumulative_df[row,] <- cumulative_df[row,] + cumulative_df[row-1,]

  }

  return(cumulative_df)
}

crimes.normalised <- normalise_crime_distribution(crime_cross_ref, 1)
crimes.cumulative <- generate_cumulative_crimes(crimes.normalised)
crimes.cumulative
crimes.normalised

# Ok, now generate submission using these probabilities

crime.test <- read.csv("/Users/christopherhowlin/Documents/DataScience/Datasets/SFCrime/test.csv", header = T, comment.char = "#")
crime.submission <- data.frame()

N <- 1e4
crime.submission <- data.frame(num=rep(NA, N), txt=rep("", N),  # as many cols as you need
                 stringsAsFactors=FALSE)          # you don't know levels yet

fileConn<-file("/Users/christopherhowlin/Documents/DataScience/Project/submissionBasic.csv", open="w")

for(row in 1:nrow(crime.test))
{
  if((row %% 1000) == 0)
  {
    print(row)
  }

  # print(t(as.vector(crimes.normalised[,crime.test[row,"PdDistrict"]])))
  # output_row <- t(as.vector(c(crime.test[row, "Id"], crimes.normalised[,crime.test[row,"PdDistrict"]])))
  output_row <- t(as.vector(c(crime.test[row, "Id"], crime_cross_ref[,crime.test[row,"PdDistrict"]])))
  # print(output_row)
  write(output_row, fileConn, sep = ",", ncolumns = ncol(output_row))

  # crime.submission <- rbind(crime.submission, c(crime.test[row, "Id"], crimes.normalised[,crime.test[row,"PdDistrict"]]))
}
