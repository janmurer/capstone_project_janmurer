library(jsonlite)
library(here)
library(dplyr)

# Fetch dataset using the opendata.swiss API and wrapperfunction.

dataset_id <- "0d56b6ae-4db2-4080-a958-4fb54b11c988"

fetch_opendata_swiss(dataset_id)

# Load data using fromJSON and here

opendata_swiss_toilettes <- fromJSON(here("01_data_input", "TOILETTE.json"))

# Create a new list to store combined properties and coordinates

opendata_swiss_toilettes_combine_coordinates_features <- lapply(1:nrow(opendata_swiss_toilettes$features), function(i) {
 
   # Extract properties and coordinates
  
  properties <- opendata_swiss_toilettes$features$properties[i, ]
  coordinates <- opendata_swiss_toilettes$features$geometry$coordinates[[i]]
  
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


# Convert coordinates from swiss coordinate system to international

library(sf)
library(dplyr)

# Create an sf object with the coordinates

coords_sf <- st_as_sf(opendata_swiss_toilettes_df_cleaned, coords = c("x_coord", "y_coord"))

# Set the current CRS to EPSG:2056

st_crs(coords_sf) <- 2056

# Transform coordinates to EPSG:4326 (WGS 84)

coords_sf_wgs84 <- st_transform(coords_sf, crs = 4326)

# Extract transformed coordinates

opendata_swiss_toilettes_df_cleaned_international_coordinates <- cbind(opendata_swiss_toilettes_df_cleaned, st_coordinates(coords_sf_wgs84))

# Rename columns to reflect latitude and longitude instead of X and Y

opendata_swiss_toilettes_df_cleaned_international_coordinates <- rename(opendata_swiss_toilettes_df_cleaned_international_coordinates, latitude = Y, longitude = X)
