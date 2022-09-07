# city-weather-data-pipeline

# Overview

the script:

data_pipeline.R --> this script reads in all json files (containing weather data for Australian cities) in the "raw_data" folder and transforms and loads the data to produce the following two outputs containing: a. The average temperature for each city. b. The top three most common “weather text” for each city. These two results are exported as csv files in the "outputs folder"

This script has been developed to handle new data every day, for an unknown number of cities.

Note: when new data for subsequent days comes in, the old json files need to be removed from the "raw_data" folder, as the script reads in all json files in that folder.
Automatic movement of json files for that day into an archived folder once the script has been run is planned for a future update to the script, for now manual movement is required.

folders:

raw_data --> where the raw json files are kept a collection of JSON files, each of which contains the hourly weather data for an Australian city over a period of 24 hours

output --> where the two results (a. The average temperature for each city. b. The top three most common “weather text” for each city.) are exported to for that day with date of script being run in file name

# Dependencies

1. R 
2. Open source R packages (code for installation included in data_pipeline script):
purrr
tidyverse
jsonlite
janitor
dplyr
h2o
rio

3. RStudio IDE (not necessarily required but highly recommended)

Note: this script was developed on R version 4.1.2, some packages may not be updated for very new versions of R, so update your R version at your own risk) 

# How do I run it?

1. Make sure you have R installed, if not please see below links for R installation
(if installing R for the first time to run this script, it's recommended to install version 4.1.2 as it is the same as what this script was developed on

For Windows:
https://cran.r-project.org/bin/windows/base/

For Mac:
https://cran.r-project.org/bin/macosx/

2. Make sure you have RStudio Installed, if not please see below links

https://www.rstudio.com/products/rstudio/download/#download

3. Open the GitHub Desktop and clone this repository

4. Open the data_pipeline.R script in Rstudio

5. Make sure to change the path to stem of the file path that the repository is located on your computer 
(everything in the path that comes before the "/GitHub"

6. Select all (the entire script) and either click "run" in RStudio IDE or the classic "Ctrl Enter" shortcut

"Data pipeline run complete" will be printed in the console to indicate the script has run successfully

# Troubleshooting a potential issue: a short story

John Snow clones this repository to his local drive on his computer and the file path looks like this:

"/Users/JohnSnow/Documents/GitHub/city-weather-data-pipeline

Because John Snow knows nothing, he didn't read this README and he tries to run this script but he received an error of doom. He then realises that he didn't change the my_path to his own local drive and so he updates it to look like this

`my_path <- "/Users/JohnSnow/Documents/" # CHANGE ME to your local path stem`

Then the script ran successfully, and even though John Snow still knows nothing, he now knows how to run this script and what the average temperature for each Australian city is as well as the top 3 most common weather conditions for that day for each city.

