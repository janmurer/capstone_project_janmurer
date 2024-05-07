# server.R
library(shiny)

shinyServer(function(input, output) {
  
  # Define user location based on input
  observeEvent(input$submit, {
    define_user_location(input$location)
    
    # Call function to get user coordinates
    user_coordinates <- get_user_coordinates()
    
    # Find the nearest public toilet and render the output
    nearest_location <- find_nearest_location(user_coordinates, opendata_swiss_toilettes_df_cleaned_international_coordinates)
    
    output$nearest_location <- renderText({
      nearest_location
    })
  })
})
