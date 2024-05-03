# Define the function
find_nearest_toilet <- function(user_coordinates, opendata_swiss_toilettes_df_cleaned) {
  # Initialize variables to store the index and minimum distance
  nearest_index <- NULL
  min_distance <- Inf
  
  # Iterate over each toilet location
  for (i in 1:nrow(opendata_swiss_toilettes_df_cleaned)) {
    # Calculate distance between user coordinates and the current toilet location
    distance <- sqrt((opendata_swiss_toilettes_df_cleaned$longitude[i] - user_coordinates$longitude)^2 + 
                       (opendata_swiss_toilettes_df_cleaned$latitude[i] - user_coordinates$latitude)^2)
    
    # Update nearest index and minimum distance if a closer location is found
    if (distance < min_distance) {
      nearest_index <- i
      min_distance <- distance
    }
  }
  
  # Return the nearest toilet location
  nearest_toilet <- opendata_swiss_toilettes_df_cleaned[nearest_index, ]
  return(nearest_toilet)
}