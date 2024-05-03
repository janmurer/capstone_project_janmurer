# Define your location

define_user_location("Kreuzbuchstrasse 38, 6006 Luzern, Switzerland")

# Get your exact coordinates

user_coordinates <- get_user_coordinates()

# Find the nearest public toilet

find_nearest_location(user_coordinates, opendata_swiss_toilettes_df_cleaned_international_coordinates)
