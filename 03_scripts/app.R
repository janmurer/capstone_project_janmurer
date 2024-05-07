library(shiny)

# Source necessary scripts
source("03_scripts/functions.R")
source("03_scripts/opendata_swiss.R")

# Define UI
ui <- fluidPage(
  titlePanel("Nearest Public Toilet Finder"),
  sidebarLayout(
    sidebarPanel(
      textInput("location", "Enter your address/location"),
      actionButton("find_nearest", "Find Nearest Toilet")
    ),
    mainPanel(
      verbatimTextOutput("nearest_toilet_output")
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  # Function to find nearest toilet reactively when button is clicked
  nearest_toilet_output <- eventReactive(input$find_nearest, {
    # Get user coordinates
    user_coordinates <- get_user_coordinates(input$location)
    
    # Find nearest location
    nearest_toilet <- find_nearest_location(user_coordinates, opendata_swiss_toilettes_df_cleaned_international_coordinates)
    
    # Return nearest toilet information
    nearest_toilet
  })
  
  # Render output in dedicated box
  output$nearest_toilet_output <- renderPrint({
    nearest_toilet_output()
  })
}

# Run the application
shinyApp(ui = ui, server = server)
