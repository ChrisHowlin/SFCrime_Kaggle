# Thanks to:
#  - Kaggle for the data.
#  - Open Street Maps for the map underlay.
#  - ggmap for the map plotting functions

library(shiny)
source("crime_utilities.R")

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
