# Load necceary libraries

library(tidyverse)
library(here)
library(httr)
library(jsonlite)

# Load API key from .csv using here package. Define base URL for OpenCage API

api_key_opencage <- read.csv(here("00_api_credentials", "api_credentials.csv")) %>%
  pull(geocoding_api_key)

base_url_opencage <- "https://api.opencagedata.com/geocode/v1/json"



# Wrapperfunction to fetch data from opendata.swiss API

fetch_opendata_swiss <- function(dataset_id) {
  
  # Construct API request URL
  
  url <- paste0("https://opendata.swiss/api/3/action/package_show?id=", dataset_id)
  
  # Make GET request
  
  response <- GET(url)
  
  # Check if request was successful
  
  if (http_type(response) == "application/json") {
    
    # Get the resource URL directly from the JSON response
    
    content <- content(response, "text")
    json_content <- fromJSON(content)
    
    # Check if resources are available
    
    if (!is.null(json_content$result$resources)) {
      
      # Extract the resource URL for the dataset to download
      
      resource_url <- json_content$result$resources$url[1]
      
      # Download the dataset
      
      dataset <- GET(resource_url)
      
      # Save the dataset to a temporary file
      
      temp_zip <- tempfile(fileext = ".zip")
      writeBin(content(dataset, "raw"), temp_zip)
      
      # Unzip the dataset to "01_data_input" folder using base R function
      
      unzip(temp_zip, exdir = here("01_data_input"))
      
      return(paste("Dataset downloaded and extracted to '01_data_input' folder"))
      
    } else {
      
      return("No resources found for this dataset.")
      
    }
    
  } else {
    
    return("Failed to fetch data.")
    
  }
}



# Wrapperfunction to get user coordinates using OpenCage API

get_user_coordinates <- function(user_location) {
  
  # Make a GET request
  
  geocoding_response <- GET(url = base_url_opencage, query = list(q = user_location, key = api_key_opencage))
  
  # Check status code
  
  if (geocoding_response$status_code == 200) {
    
    # Convert response to json
    
    geocoding_response_json <- content(geocoding_response, as = "text") %>%
      fromJSON()
    
    # Extract coordinates (latitude/longitude)
    
    user_lat <- geocoding_response_json$results$geometry$lat[1]
    user_lng <- geocoding_response_json$results$geometry$lng[1]
    
    # Create a dataframe named user_coordinates
    
    user_coordinates <- data.frame(latitude = user_lat, longitude = user_lng)
    
    return(user_coordinates)
    
  } else {
    
    stop("Request failed with status code ", geocoding_response$status_code)
 
     }
}



# Function to find nearest location

find_nearest_location <- function(user_coordinates, locations_df) {
  
  # Check if the user coordinates or locations data frame is empty
  
  if (length(user_coordinates) == 0 || nrow(locations_df) == 0) {
    
    return(NA)
  
    }
  
  # Calculate distances between user coordinates and each location
  
  distances <- sqrt((locations_df$latitude - user_coordinates$latitude)^2 + 
                      (locations_df$longitude - user_coordinates$longitude)^2)
  
  # Find the index of the location with the minimum distance
  
  nearest_index <- which.min(distances)
  
  # Check if a nearest location is found
  
  if (length(nearest_index) > 0) {
    
    # Return the name of the nearest location
    
    return(locations_df$NAME[nearest_index])
    
  } else {
    
    # If no nearest location is found, return NA
    
    return(NA)
    
  }
  
}

