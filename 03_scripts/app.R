# Load necessary libraries

library(shiny)

# Source necessary scripts

source("03_scripts/functions.R")
source("03_scripts/opendata_swiss.R")

# UI
ui <- fluidPage(
  
  titlePanel("SeatSeekr: Find the Nearest Public Toilet in Lucerne"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      textInput("location", "Enter your current location:"),
      
      actionButton("find_nearest", "Find Nearest Toilet", class = "btn-primary"),
      
      # Insert line break for better separation 
      
      br(),
      
      br(), 
      
      actionButton("quit_app", "Quit Application", class = "btn-danger")
      
    ),
    
    mainPanel(
      
      verbatimTextOutput("nearest_toilet_output")
      
    )
    
  )
  
)


server <- function(input, output, session) {
  
  # Function to find nearest toilet when button is clicked
  
  nearest_toilet_output <- eventReactive(input$find_nearest, {
    
    # Get user coordinates
    
    user_coordinates <- get_user_coordinates(input$location)
    
    # Find nearest location
    
    nearest_toilet <- find_nearest_location(user_coordinates, opendata_swiss_toilettes_df_cleaned_international_coordinates)
   
     # Return nearest toilet information
   
     nearest_toilet
     
  })
  
  # Render output in dedicated box
  
  output$nearest_toilet_output <- renderText({
    
    result <- nearest_toilet_output()
    
    paste("The nearest public toilet is located at:", result)
    
  })
  
  # Quit application when quit button is clicked
  
  observeEvent(input$quit_app, {
    
    stopApp()
    
  })
  
}

# Run the application

shinyApp(ui = ui, server = server)
