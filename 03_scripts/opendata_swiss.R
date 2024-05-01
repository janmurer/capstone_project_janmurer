library(jsonlite)

# Load data using here
opendata_swiss_toilettes <- fromJSON("TOILETTE.json")

# Extract relevant information
toilettes_data <- opendata_swiss_toilettes$features
extracted_data <- lapply(toilettes_data, function(feature) {
  c(
    feature$geometry$coordinates[[1]],
    feature$geometry$coordinates[[2]],
    feature$properties$NAME,
    feature$properties$IN_BETRIEB,
    feature$properties$HINDERNISFREI
  )
})

# Convert list to dataframe
opendata_swiss_toilettes_df <- as.data.frame(do.call(rbind, extracted_data))