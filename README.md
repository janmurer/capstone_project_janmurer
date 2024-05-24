# Capstone Project 

Repository for the final capstone project in the seminar "Data Mining for the Social Sciences using R".

# Description

The repository contains a primitive Shiny application that can be run within RStudio. The application takes the user's location as input and returns the nearest public toilet in Lucerne.  

# Installation

To run the application, you need to have R and RStudio installed on your computer. You can download R from the [CRAN website](https://cran.r-project.org/). You can download RStudio from the [RStudio website](https://www.rstudio.com/products/rstudio/download/).

To install the required packages, run the following code in the RStudio console:

install.packages(c(
  "tidyverse", 
  "here", 
  "httr", 
  "jsonlite", 
  "dplyr", 
  "sf", 
  "shiny"
))


Additionally, you need a private API key to use the OpenCage API. You can get a free API key by signing up on the [OpenCage website](https://opencagedata.com/).

Store the key in a .csv file in the folder "00_api_credentials" and name the file "api_credentials.csv". The title of the column should be "geocoding_api_key" and the key should be stored in the first cell of the second row. You may use Microsoft Excel or Google Sheets to create the file.

To run the application, execute the script "app.R" in Rstudio. The script is located in the folder "03_scripts".


