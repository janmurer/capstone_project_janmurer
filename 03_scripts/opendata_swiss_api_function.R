library(httr)
library(here)

# function to fetch data from opendata.swiss API

fetch_opendata_swiss <- function(dataset_id) {
  
  # construct API request URL
  
  url <- paste0("https://opendata.swiss/api/3/action/package_show?id=", dataset_id)
  
  # make GET request
  
  response <- GET(url)
  
  # check if request was successful
  
  if (http_type(response) == "application/json") {
    
    # get the resource URL directly from the JSON response
    
    content <- content(response, "text")
    json_content <- fromJSON(content)
    
    # check if resources are available
    
    if (!is.null(json_content$result$resources)) {
      
      # find the resource URL for the dataset you want to download
      
      resource_url <- json_content$result$resources$url[1]  # Assuming the first resource is the dataset
      
      # download the dataset
      
      dataset <- GET(resource_url)
      
      # save the dataset to a temporary file
      
      temp_zip <- tempfile(fileext = ".zip")
      writeBin(content(dataset, "raw"), temp_zip)
      
      # unzip the dataset to "01_data_input" folder using base R function
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
