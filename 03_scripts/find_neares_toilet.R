# Function to find nearest location
find_nearest_location <- function(user_coordinates, locations_df) {
  # Calculate distances between user coordinates and each location
  distances <- sqrt((locations_df$latitude - user_coordinates$latitude)^2 + 
                      (locations_df$longitude - user_coordinates$longitude)^2)
  
  # Find the index of the location with the minimum distance
  nearest_index <- which.min(distances)
  
  # Print the name of the nearest location
  print(locations_df$NAME[nearest_index])
}