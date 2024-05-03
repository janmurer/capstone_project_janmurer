library(tidyverse)
library(here)
library(httr)
library(jsonlite)

# Load API key from .csv using here package. Define base URL for OpenCage API.

api_key_opencage <- read.csv(here("00_api_credentials", "api_credentials.csv")) %>%
  pull(geocoding_api_key)

base_url_opencage <- "https://api.opencagedata.com/geocode/v1/json"


# Function to define user location and store it in a variable

define_user_location <- function(address) {
  user_location <<- address
}

# Function to get coordinates from OpenCage API

get_coordinates <- function() {
  
  # Make a GET request
  
  geocoding_response <- httr::GET(url = base_url_opencage, query = list(q = user_location, key = api_key_opencage))
  
  # Check status code
  
  if (geocoding_response$status_code == 200) {
    
    # Convert response to json
    
    geocoding_response_json <- httr::content(geocoding_response, as = "text") %>%
      fromJSON()
    
    # Extract coordinates (latitude/longitude)
    
    user_lat <- geocoding_response_json$results$geometry$lat[1]
    user_lng <- geocoding_response_json$results$geometry$lng[1]
    
    return(list(latitude = user_lat, longitude = user_lng))
  } else {
    stop("Request failed with status code ", geocoding_response$status_code)
  }
}


get_user_coordinates <- function() {
  # Make a GET request
  geocoding_response <- httr::GET(url = base_url_opencage, query = list(q = user_location, key = api_key_opencage))
  
  # Check status code
  if (geocoding_response$status_code == 200) {
    # Convert response to json
    geocoding_response_json <- httr::content(geocoding_response, as = "text") %>%
      fromJSON()
    
    # Extract coordinates (latitude/longitude)
    user_lat <- geocoding_response_json$results$geometry$lat[1]
    user_lng <- geocoding_response_json$results$geometry$lng[1]
    
    # Create a dataframe named user_coordinates
    user_coordinates <- data.frame(latitude = user_lat, longitude = user_lng)
    
    # Print the result
    print(user_coordinates)
    
    # No need to return the result since it's stored locally
  } else {
    stop("Request failed with status code ", geocoding_response$status_code)
  }
}







