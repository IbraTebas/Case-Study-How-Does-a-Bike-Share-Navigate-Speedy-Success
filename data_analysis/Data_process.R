library(tidyverse)

data_cleaned <- read.csv('data_clean_final.csv')

test <- data_cleaned %>% 
  filter(duration_trip_in_mins > 60)
