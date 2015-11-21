# Utility functions shared by each file

read_crime_data <- function(filename)
{
  crime_data <- read.csv(filename, header = T, comment.char = "#")
  if(!is.null(crime_data$Category))
  {
    crime_data$Category <- as.factor(crime_data$Category)
  }

  crime_data$PdDistrict <- as.factor(crime_data$PdDistrict)
  crime_data$DayOfWeek <- as.factor(crime_data$DayOfWeek)
  crime_data$Dates <- as.POSIXct(crime_data$Dates, format="%Y-%m-%d %H:%M:%S", tz='GMT')
  datesLT <- as.POSIXlt(crime_data$Dates)
  crime_data$Year <- datesLT$year
  crime_data$Month <- datesLT$mon
  crime_data$Times <- (datesLT$hour*60 + datesLT$min)
  crime_data$X_bin <- bin_coordinate_data(crime_data$X, 100)
  crime_data$Y_bin <- bin_coordinate_data(crime_data$Y, 100)

  return(crime_data)
}

bin_coordinate_data <- function(coords, num_bins)
{
  min <- min(coords)
  max <- max(coords)
  bucket_size <- (max - min) / num_bins

  ceiling(coords / bucket_size)
}

get_category_levels_array <- function(x)
{
  as.integer(x == get_category_levels())
}

get_category_levels <- function()
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

normalise_distribution_by_row <- function(distribution, normalization_target = 1)
{
  # Find the sum of each column and determine the normalisation factor so
  # normalised sum matches normalisation_target
  row_sums.total <- rowSums(distribution)
  row_sums.normalised <- normalization_target / row_sums.total
  normalized_distribution <- distribution
  for(row in 1:nrow(distribution))
  {
    normalized_distribution[row,] <- distribution[row,] * row_sums.normalised[row]
  }

  return(normalized_distribution)
}

log_loss_by_record <- function(actual, predicted)
{
  # Normalise row values to 1 before calculating log-loss
  normalise_distribution_by_row(predicted)
  actual_as_array <- lapply(actual, get_category_levels_array)
  actual.df <- data.frame(t(sapply(actual_as_array,c)))
  predicted.log <- log(predicted)
  pre


  for(result in 1:length(actual))
  {
    1*log(predicted[result,actual[result]])
    log_loss.df[result,] <- c(result, 1*log(predicted[result,actual[result]]))
  }

  result <- -1/length(actual)*sum(log_loss.table[,2])
  return(result)
}

categorical_log_loss <- function(actual, predicted)
{
  # Calculates the log-loss per category to find out which categories contribute
  # best and least to the score

  # Normalise row values to 1 before calculating log-loss
  normalise_distribution_by_row(predicted)

  log_loss_sum <- 0
  category_ll.df <- NULL
  for(level in 1:get_category_levels())
  {
    category_temp <- which(actual == level, arr.ind=TRUE)
    category_ll <- 1*log(predicted[category_temp,])
    result <- -1/length(actual)*sum()
    category_ll.df <- rbind(category_ll.df, c(level, sum))
  }

  result <- -1/length(actual)*log_loss_sum
  return(result)
}

truncate_output <- function(output, length)
{
  format(round(output, length), nsmall = length)
}
