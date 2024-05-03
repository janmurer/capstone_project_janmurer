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

# Rename columns

opendata_swiss_toilettes_df_cleaned_international_coordinates <- rename(opendata_swiss_toilettes_df_cleaned_international_coordinates, latitude = Y, longitude = X)