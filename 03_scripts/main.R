# Run functions.R and opendata_swiss to setup R-environnement

source("03_scripts/functions.R")
source("03_scripts/opendata_swiss.R")

# Define your location

define_user_location("Hallwilerweg 16, 6000 Luzern, Switzerland")

# Fetch your exact coordinates and store them in a variable

user_coordinates <- get_user_coordinates()

# Find the nearest public toilet printed in the console. 

find_nearest_location(user_coordinates, opendata_swiss_toilettes_df_cleaned_international_coordinates)
