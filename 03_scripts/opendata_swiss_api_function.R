library(httr)
library(jsonlite)
library(here)

# Function to fetch data from opendata.swiss API

fetch_opendata_swiss <- function(dataset_id) {
  # Construct API request URL
  
  url <- paste0("https://opendata.swiss/api/3/action/package_show?id=", dataset_id)
  
  # Make GET request
  
  response <- GET(url)
  
  # Check if request was successful
  
  if (http_type(response) == "application/json") {
    
    # Parse JSON response
    
    content <- content(response, "text")
    json_content <- fromJSON(content)
    
    # Check if resources are available
    
    if (!is.null(json_content$result$resources)) {
      
      # Find the resource URL for the dataset you want to download
      
      # You may need to adjust this based on the structure of the JSON response
      
      resource_url <- json_content$result$resources$url[1]  # Assuming the first resource is the dataset
      
      # Download the dataset
      
      dataset <- GET(resource_url)
      
      # Save the dataset to a temporary file
      
      temp_zip <- tempfile(fileext = ".zip")
      writeBin(content(dataset, "raw"), temp_zip)
      
      # Unzip the dataset to "01_data_input" folder using here package
      
      unzip(temp_zip, exdir = here("01_data_input"))
      
      return(paste("Dataset downloaded and extracted to '01_data_input' folder"))
    } else {
      return("No resources found for this dataset.")
    }
  } else {
    return("Failed to fetch data.")
  }
}


dataset_id <- "0d56b6ae-4db2-4080-a958-4fb54b11c988"
fetch_opendata_swiss(dataset_id)
