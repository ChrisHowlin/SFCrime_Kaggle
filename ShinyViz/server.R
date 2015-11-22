# server.R

library(ggmap)
source("crime_utilities.R")
# Just using the 2014 data to start with (quicker to plot)
crime_data_no_outlier <- read_crime_data("data/train-no-outlier_2014.csv")

theme_set(theme_bw(16))
# Reload the map fresh...
# SF_base_map <- qmap(location = c(-122.5209, 37.7058, -122.3245, 37.8336), color = "bw", source = 'osm')
SF_base_map <- readRDS('data/SF_base_map.rds') # Save data locally so we don't have to keep downloading it when the app starts


shinyServer(function(input, output) {

  output$plot <- renderPlot({

    # Build filters
    hour_filter <- which(crime_data_no_outlier$Hour == input$hour_slide)
    category_filter <- which(crime_data_no_outlier$Category==input$category_select)

    # Match dow
    dow <- switch(input$dow_slide,
                   '1' = 'Monday',
                   '2' = 'Tuesday',
                   '3' = 'Wednesday',
                   '4' = 'Thursday',
                   '5' = 'Friday',
                   '6' = 'Saturday',
                   '7' = 'Sunday')

    dow_filter <- which(crime_data_no_outlier$DayOfWeek==dow)

    combined_filter <- intersect(intersect(hour_filter, category_filter),
                                  dow_filter)
    # Bloc
    SF_base_map + stat_density2d(
      aes(x = X, y = Y, fill = ..level..,  alpha = ..level..),
      size = 2, bins = 4, data = crime_data_no_outlier[combined_filter,],
      geom = "polygon"
    ) +
      scale_fill_gradient(low = "black", high = "red")
  })
})
