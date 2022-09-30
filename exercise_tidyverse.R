
# Import libraries
library(tidyverse)

#########################################
# The code is organised as follows:
# - first, I import and clean the data (feel free to look at the code to learn)
# - next, are the exercises. Write your solutions under each comments

# Read in the data
wb_data <- read_csv("wb_data.csv") %>% 
  
  # Rename columns to make it easier to manipulate in R
  rename(country_name = `Country Name`,
         country_code = `Country Code`,
         series_name = `Series Name`,
         series_code = `Series Code`) %>% 
  
  # Pivot the years data to long and clean them, including removing .. from
  # values and replacing them with NA (missing value), and converting the values to numeric.
  pivot_longer(cols = starts_with("20"),
               names_to = "year",
               values_to = "values") %>% 
  mutate(year = str_remove(year, "^.*\\[YR"),
         year = str_remove(year, "\\]"),
         year = as.numeric(year)) %>% 
  mutate(values = ifelse(values == "..", NA, values)) %>% 
  mutate(values = as.double(values)) %>% 
  
  # Change the series_code variable to make them more intuitive, and then
  # convert the series_codes into their own variables using pivot_wider()
  mutate(series_code = case_when(series_code == "EN.ATM.CO2E.PP.GD" ~ "co2_emissions",
                                 series_code == "NE.EXP.GNFS.ZS" ~ "exports",
                                 series_code == "NY.GDP.MKTP.KD.ZG" ~ "gdp_growth",
                                 series_code == "NY.GDP.PCAP.KD" ~ "gdp_per_capita",
                                 TRUE ~ "research_spending")) %>% 
  select(-series_name) %>% 
  pivot_wider(names_from = series_code, values_from = values) %>% 
  unnest()

#########################################
#########################################
# Exercises starts here

#########################################
# Calculate the average CO2 emissions in 2009 and 2019. Have they fallen over that time period?
# Tip: make sure you include "na.rm = TRUE" in the mean() function otherwise you will not get results







#########################################
# Was Armenia's GDP growth in 2010 higher or lower than the world average?







#########################################
# First, create a new variable called "north_america", which takes a value of 1 if 
# country_code is equal to either USA, CAN or MEX, and 0 otherwise.
# Next, calculate average exports in North America and in the rest of the world in 2015.
# Tip: again, remember to include na.rm = TRUE in you mean() function




  
#########################################
# Create a new variable with the ratio of exports to GDP per capita,
# and check whether the export-intensity of GDP per capita in 2015 was higher
# in Germany or in France










