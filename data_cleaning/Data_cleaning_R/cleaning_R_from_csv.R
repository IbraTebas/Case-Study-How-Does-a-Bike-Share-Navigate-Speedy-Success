install.packages("leaflet")
install.packages('geosphere')
install.packages('matrixStats')
install.packages('dplyr')
install.packages('plyr')
install.packages('vtable')

library(dplyr)
library(leaflet)
library(tidyverse)
library(geosphere)
library(matrixStats)
data <- read.csv("data_12_months.csv")

data <- data %>%
  distinct(ride_id, .keep_all = TRUE) %>%                       #eliminate duplicate rows 
  drop_na(end_lat)                                              #eliminate rows with NaN in the end_lat column less thank 5k detected with NAN count      
  
#extract date and time in separate columns at start and end
data$start_time<- format(as.POSIXct(                          
data$started_at),format = "%H:%M:%S")
data$start_date <- as.Date (data$started_at)

data$end_time<- format(as.POSIXct(
data$ended_at),format = "%H:%M:%S")
data$end_date <- as.Date (data$ended_at)

#add the day of the week                                                                                         
data$weekday_started = format(data$start_date, format = "%a")                                #*as a string abbreviated
data$weekday_started_int = as.numeric(format(data$start_date, format = "%u"))                #* as an integer, Monday = 1   
data$weekday_ended = format(data$end_date, format = "%a") 
data$weekday_ended_int = as.numeric(format(data$end_date, format = "%u"))                    #idem

#calculate duration
data$duration_trip_in_mins <- difftime(data$ended_at, data$started_at, units = "mins") #let's check some stats
mean(data$duration_trip_in_mins)
max(data$duration_trip_in_mins)
min(data$duration_trip_in_mins)

#removed the date columns with combination of day and time
data <- subset(data, select = -c(started_at, ended_at))      

#add the column distance_in_km to the data
#Function for distance.
haversine<- function(long1, lat1, long2, lat2) {
  
  stopifnot(is.numeric(long1),
            is.numeric(lat1),
            is.numeric(long2),
            is.numeric(lat2),
            long1 > -180,
            long1 < 180,
            lat1 > -180,
            lat1 < 180,
            long2 > -180,
            long2 < 180,
            lat2 > -180,
            lat2 < 180
  )
  
  long1 <- long1*pi/180
  lat1 <- lat1*pi/180
  long2 <- long2*pi/180
  lat2 <- lat2*pi/180
  
  R <- 6371 # Earth mean radius [km]
  delta.long <- (long2 - long1)
  delta.lat <- (lat2 - lat1)
  a <- sin(delta.lat/2)^2 + cos(lat1) * cos(lat2) * sin(delta.long/2)^2
  c <- 2 * asin(min(1,sqrt(a)))
  d = R * c
  return(d) # Distance in km
}

#add the column distance_in_km to the data
data$distance_in_km <- with(data, mapply(haversine, lat1=data$start_lat, long1=data$start_lng, lat2=data$end_lat, long2=data$end_lng))


#Shows the MAX of any numerical column, it is detected the outlier potentially observed on Tableau Graph: 
data %>% summarise_if(is.numeric, max)
data %>%summarise_if(is.numeric, min)

#let's detect outliers
outliers_distance_max <- data %>% filter(distance_in_km > 1000)
outliers_distance_and_duration <- data %>% filter(distance_in_km == 0 & duration_trip_in_mins < 5)# we will remove the trips that the bike is docked in the same station and less than 5 min have passed. Candidate to abandon trip.
Outlier_graph <-data %>% filter(ride_id == "9F438AD0AB380E3F" )  #ride id detected as an outlier on Tableau when checking end lat and lng.
outlier_time_more_than_5_hrs <- data %>% filter(duration_trip_in_mins > 300)  #check trip duration greater than 5 hours
outlier_time_null_time_or_negative <- data %>% filter(duration_trip_in_mins < 0 ) # check negative durations 

#Removal of the correspondent rows for the outliers
data <- subset(data, distance_in_km != 0 | duration_trip_in_mins > 4)     #removal of 131855 rows
data <- subset(data, distance_in_km < 1000)  #distance more than 1000KM, tested max and it went down to 114.3836
data <- subset(data, duration_trip_in_mins <= 300 & duration_trip_in_mins >=0) #removal of  9419 rows with more of 5 hours duration, 1161 of them more than a day.
data <- subset(data, ride_id != "9F438AD0AB380E3F")

#Remove NaN
data_no_NaN <- na.omit(data)

#Convert trip duration to float. 
data_no_NaN$duration_trip_in_mins <- as.numeric(data_no_NaN$duration_trip_in_mins)
data$duration_trip_in_mins <- as.numeric(data$duration_trip_in_mins)
#Check stats in both data with NaN and without
st(data)
st(data_no_NaN)

#After checking, the proportion of casual and members stay almost the same and the lose of data is less than 13%
#Also the other metrics are kept very similar, there is a small decrease  

#Save work
write.csv(data_no_NaN,"D:\\data_clean_final.csv", row.names = FALSE)



#Appendix:     

#Check for NAN values across columns. 
apply(X = is.na(data_no_NaN), MARGIN = 2, FUN = sum)


#Shows the MAX of any numerical column, it is detected the outlier potentially observed on Tableau
data %>% summarise_if(is.numeric, max)
data %>%summarise_if(is.numeric, min)
max(data$duration_trip_in_mins)
min(data$duration_trip_in_mins)


#Map:
# 
# leaflet(data) %>% 
#   addTiles() %>% 
#   addCircleMarkers(lat = ~start_lat, 
#                    lng = ~start_lng, 
#                    popup = paste("<b>Date:</b>", c(data$start_date), "<br>")

