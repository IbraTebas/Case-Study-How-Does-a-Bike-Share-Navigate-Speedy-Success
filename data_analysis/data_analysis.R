library(dplyr)

#Load data cleaned
data_clean <- read.csv("data_clean_final.csv", header = TRUE)

data %>%
  group_by(col_to_group_by) %>%
  summarise_at(vars(col_to_aggregate), list(name = mean))