library(jsonlite)
library(here)
library(dplyr)

# Load data using fromJSON and here
opendata_swiss_toilettes <- fromJSON(here("01_data_input", "TOILETTE.json"))

# Create a new list to store combined properties and coordinates
opendata_swiss_toilettes_combine_coordinates_features <- lapply(1:nrow(opendata_swiss_toilettes$features), function(i) {
  # Extract properties and coordinates
  properties <- opendata_swiss_toilettes$features$properties[i, ]
  coordinates <- opendata_swiss_toilettes$features$geometry$coordinates[[i]]  # Access coordinates list
  
  # Separate x and y coordinates
  x_coord <- coordinates[1]
  y_coord <- coordinates[2]
  
  # Combine properties, x coordinate, and y coordinate into a single structure
  combined <- list(properties = properties, x_coord = x_coord, y_coord = y_coord)
  
  return(combined)
})

# Convert the list of lists into a dataframe
opendata_swiss_toilettes_df <- bind_rows(opendata_swiss_toilettes_combine_coordinates_features)


# Perform some data cleaning and filtering

# Select relevant columns

opendata_swiss_toilettes_df_cleaned <- opendata_swiss_toilettes_df %>%
  mutate(NAME = properties$NAME,
         IN_BETRIEB = properties$IN_BETRIEB,
         HINDERNISFREI = properties$HINDERNISFREI) %>%
  select(NAME, IN_BETRIEB, HINDERNISFREI, x_coord, y_coord)

# Remove rows with IN_BETRIEB = 0

opendata_swiss_toilettes_df_cleaned <- opendata_swiss_toilettes_df_cleaned %>%
  filter(IN_BETRIEB == 1)