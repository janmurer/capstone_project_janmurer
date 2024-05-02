library(jsonlite)
library(here)

# Load data using fromJSON and here
opendata_swiss_toilettes <- fromJSON(here("01_data_input", "TOILETTE.json"))

# Create a new list to store combined properties and coordinates
opendata_swiss_toilettes_combine_coordinates_features <- lapply(1:nrow(opendata_swiss_toilettes$features), function(i) {
  # Extract properties and coordinates
  properties <- opendata_swiss_toilettes$features$properties[i, ]
  coordinates <- opendata_swiss_toilettes$features$geometry$coordinates[[i]]  # Access coordinates list
  
  # Combine properties and coordinates into a single structure
  combined <- list(properties = properties, coordinates = coordinates)
  
  return(combined)
})
