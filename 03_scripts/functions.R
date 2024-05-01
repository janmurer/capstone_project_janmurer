library(tidyverse)
library(here)
library(httr)
library(jsonlite)


# create wrapper function to get coordinates from opencage api.

# load api key from .csv using here package. define base url for opencage api.

api_key_opencage <- read.csv(here("00_api_credentials", "api_credentials.csv")) %>%
                               pull(geocoding_api_key)

base_url_opencage <- "https://api.opencagedata.com/geocode/v1/json"


# define user location

user_location <- "Diebold-Schilling-Strasse 32, 6004 Luzern, Switzerland"


# make a GET request

geocoding_response <- httr::GET(url = base_url_opencage, query = list(q = user_location, key = api_key_opencage))

# check status code

geocoding_response$status_code

# convert response to json

geocoding_response_json <- httr::content(geocoding_response, as = "text") %>%
                          fromJSON()

# extract coordinates

geocoding_response_json$results$geometry$lat
geocoding_response_json$results$geometry$lng