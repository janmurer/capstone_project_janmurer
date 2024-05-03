# Load API key from .csv using here package. Define base URL for OpenCage API.

api_key_opencage <- read.csv(here("00_api_credentials", "api_credentials.csv")) %>%
  pull(geocoding_api_key)

base_url_opencage <- "https://api.opencagedata.com/geocode/v1/json"

# Define your location

define_user_location("Dreilindenstrasse 22, 6004 Luzern, Switzerland")

# Get your exact coordinates

user_coordinates <- get_user_coordinates()

# Find the nearest public toilet

find_nearest_location(user_coordinates, opendata_swiss_toilettes_df_cleaned_international_coordinates)
