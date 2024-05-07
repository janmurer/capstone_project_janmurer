# Run functions.R and opendata_swiss to setup R-environment

source("03_scripts/functions.R")
source("03_scripts/opendata_swiss.R")

# Define your location

define_user_location("Diebold-Schilling-Strasse 39, 6004 Luzern, Switzerland")

# Get user coordinates

user_coordinates <- get_user_coordinates()

# Find the nearest public toilet and print it in the console

find_nearest_location(user_coordinates, opendata_swiss_toilettes_df_cleaned_international_coordinates)
