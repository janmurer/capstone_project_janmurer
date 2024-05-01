library(tidyverse)
library(here)


# create wrapper function to get coordinates from opencage api.

# load api key from .csv using here

api_key_opencage <- read.csv(here("00_api_credentials/api_crentials.csv") %>%
                               pull(geocoding_api_key)



