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
  crime_data$Dates <- as.POSIXct(crime_data$Dates)
  crime_data$Times <- get_time_of_day(crime_data$Dates)

  return(crime_data)
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

# Takes time in POSIXct format and gets time in day as minutes from midnight
get_time_of_day <- function(dates)
{
  posix_lt <- as.POSIXlt(dates)
  time_of_day <- posix_lt$hour*60 + posix_lt$min
}
