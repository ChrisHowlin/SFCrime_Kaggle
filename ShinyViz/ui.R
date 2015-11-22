# Thanks to:
#  - Kaggle for the data.
#  - Open Street Maps for the map underlay.
#  - ggmap for the map plotting functions

library(shiny)
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

shinyUI(fluidPage(
  titlePanel("San Francisco Crime Data Visualisation"),

  sidebarLayout(
    sidebarPanel(
      helpText("A density plot of the San Francisco crime categories in 2014."),

      selectInput("category_select", "Select crime category", choices=get_category_levels())

      # Selection by hour to come later...
      # sliderInput("hour_slide", "Hour", min=0, max=23, value=12, step=1)
    ),

    mainPanel(plotOutput("plot"))
  )
))
