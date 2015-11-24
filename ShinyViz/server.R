# server.R

library(ggmap)
source("lib/crime_utilities.R")
# Just using the 2014 data to start with (quicker to plot)
crime_data_no_outlier <- read_crime_data("dataset/train-no-outlier.csv")

theme_set(theme_bw(16))
# Reload the map fresh...
# SF_base_map <- qmap(location = c(-122.5209, 37.7058, -122.3245, 37.8336), color = "bw", source = 'osm')
SF_base_map <- readRDS('data/SF_base_map.rds') # Save data locally so we don't have to keep downloading it when the app starts


shinyServer(function(input, output) {

  get_category_filter <- reactive({
    which(crime_data_no_outlier$Category==input$category_select)
  })

  get_hour_filter <- reactive({
    which(crime_data_no_outlier$Hour == input$hour_slide)
  })

  get_dow_filter <- reactive({
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
  })

  get_combined_filter <- reactive({

    # Build filters
    category_filter <- get_category_filter()

    combined_filter <- category_filter
    if(input$hour_check)
    {
      hour_filter <- get_hour_filter()
      combined_filter <- intersect(combined_filter, hour_filter)
    }

    if(input$dow_check)
    {
      dow_filter <- get_dow_filter()
      combined_filter <- intersect(combined_filter, dow_filter)
    }

    return (combined_filter)
  })

  output$plot <- renderPlot({

    # Build filters
    map_filter <- get_combined_filter()

    # Bloc
    if(length(map_filter) > 0)
    {
      SF_base_map + stat_density2d(
        aes(x = X, y = Y, fill = ..level..,  alpha = ..level..),
        size = 2, bins = 4, data = crime_data_no_outlier[map_filter,],
        geom = "polygon"
      ) +
        scale_fill_gradient(low = "black", high = "red")
    }
    else
    {
      SF_base_map
    }
  })
})
