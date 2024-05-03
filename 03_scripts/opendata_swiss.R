library(jsonlite)
library(here)
library(dplyr)

# load data using fromJSON and here
opendata_swiss_toilettes <- fromJSON(here("01_data_input", "TOILETTE.json"))

# create a new list to store combined properties and coordinates

opendata_swiss_toilettes_combine_coordinates_features <- lapply(1:nrow(opendata_swiss_toilettes$features), function(i) {
  
  # extract properties and coordinates
  
  properties <- opendata_swiss_toilettes$features$properties[i, ]
  coordinates <- opendata_swiss_toilettes$features$geometry$coordinates[[i]]  # Access coordinates list
  
  # combine properties and coordinates into a single structure
  
  combined <- list(properties = properties, coordinates = coordinates)
  
  return(combined)
})


# convert the list of lists into a dataframe

opendata_swiss_toilettes_df <- bind_rows(opendata_swiss_toilettes_combine_coordinates_features)

