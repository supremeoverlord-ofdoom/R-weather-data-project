#title: "Australian city weather pipeline"

  ### Overall Script < data pipeline for Australian city weather > ------------------------------------------------------------
# written by   : Sierra
# written on   : 6/09/2022        
# purpose      : 1. imports all x number of json files in assigned folder with 24hr weather for a city
# purpose      : 2. maps all json files into one data frame (df) and cleans it and transforms into:
# purpose      : 2. a) df with average temp (metric) per city b) df with top three most common “weather text” for each city
# purpose      : 3. two dfs are exported as csvs to outputs folder
# modified on  : 7/09/2022

  ## < 1. loading libraries and importing data > ------------------------------------------------------------------------------
rm(list = ls()) #clean working environment
pro_start <- Sys.time() #starting marker to monitor speed of script

# install pacman if not installed
if (!require("pacman")) install.packages("pacman")
  
#install packages (if not installed) and load them
pacman::p_load(
  purrr,
  tidyverse,
  jsonlite,
  janitor,
  dplyr,
  h2o)
  
#  ------- choose your path -------------------
my_path <- "/Users/JohnSnow/Documents/" # CHANGE ME to your local path stem 
#-----------------------------------------------

git_path <- "GitHub/city-weather-data-pipeline/raw_data" #path from github repository
path<- paste(my_path, git_path, sep = "") #combing local path and git to full path
files <- dir(path, pattern = "*.json") #only detecting json files

#importing json files and mapping to data frame
city_weather_df <- files %>%
  map_df(~fromJSON(file.path(path, .), flatten = TRUE))

  ## < 2. data cleaning > -----------------------------------------------------------------------------------------------------

#piping dataframe through cleaning functions
city_weather_df_clean <- city_weather_df %>% 
  janitor::clean_names() %>%  #cleaning column names
  dplyr::mutate_all(.funs=toupper) #change values to UPPER CASE (note this converts all values to character class)
  
#convert temperature to numeric
city_weather_df_clean$temperature_metric_value <- as.numeric(city_weather_df_clean$temperature_metric_value)

#check for inconsistencies in weather text to see if more cleaning is needed
table(city_weather_df_clean$weather_text)

  ## < 3. finding average temp (in degrees C) for each city > -----------------------------------------------------------------

#create new df grouped by city and metric temp
city_weather_df_mean <- city_weather_df_clean %>% 
  group_by(city) %>% # group by city
  summarise_at(vars(temperature_metric_value), list(average_temp = mean)) %>% # specify metric temp and applying function=mean
  ungroup() 

 ## < 4. finding top 3 "weather texts" for each city > ------------------------------------------------------------------------

#create new df grouped by city with top 3 frequency weather data by city
city_weather_df_top3 <- city_weather_df_clean %>% 
  group_by(city, weather_text) %>% #group by city and weather text
  summarise(weather_freq = n()) %>% #sum of freq of each weather text per city
  mutate(rank = order(order(weather_freq, city, decreasing=TRUE))) %>% #creating rank by city of weather text
  filter(rank <= 3) %>% #filter for top 3 weather texts
  arrange(rank, .by_group = TRUE) %>% # arrange weather text in ascending order for each city
  select(c(city, weather_text)) %>% #selecting columns of interest as per instructions
  ungroup() 

## < 5. export results as csv > -----------------------------------------------------------------------------------------------

#setting up for export
today <- Sys.Date() #today's date for file name
file_ext <- ".csv"  #assigning file extension
export_git_path <- "GitHub/city-weather-data-pipeline/output/" #assigning path to save csv

# export average temperatures
filename1 <- "daily_city_average_temp" 
full_filename_path1 <- paste(my_path, export_git_path, filename1, today, file_ext, sep = "") 
export(city_weather_df_mean, full_filename_path1)

# export top 3 "weather texts"
filename2 <- "daily_city_top3_weather" 
full_filename_path2 <- paste(my_path, export_git_path, filename2, today, file_ext, sep = "") 
export(city_weather_df_top3, full_filename_path2)

conn_end <- Sys.time()
print("Data pipeline run complete")
print("script run time = ")
print(conn_end - pro_start)

#end of code
