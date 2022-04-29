install.packages('bigrquery')
install.packages('gridExtra')
install.packages('scales')
library(bigrquery)
library(gridExtra)
library(scales)
bigrquery::bq_auth(path = 'CAPSTONE_KEYS.json' )



projectid = 'tidal-tower-348213'
sql_trips_number_type <- "SELECT COUNT(*) as member_type_trips, member_casual
FROM (SELECT * FROM `tidal-tower-348213.Data_trips_12_month.Data_trips_12_months` where  end_lat is not NULL)
group by
member_casual"

sql_rideable_and_user_type <- "SELECT COUNT(*) as member_type_trips, member_casual, rideable_type
FROM (SELECT * FROM `tidal-tower-348213.Data_trips_12_month.Data_trips_12_months` where  end_lat is not NULL)
group by
member_casual, rideable_type
ORDER BY
member_casual"

tb_trips_numbers_type <- bq_project_query(projectid, sql_trips_number_type)
Number_of_trips_type <- as.data.frame(bq_table_download(tb_trips_numbers_type, n_max=Inf))  #in n_max it can be restricted the amount of results recovered. Convenient for results with less than 100 MB
ggplot(Number_of_trips_type, aes(x = member_casual, y=member_type_trips)) + geom_col()+ scale_y_continuous(labels = comma)


tb_trips_rideable_and_user_type <- bq_project_query(projectid, sql_rideable_and_user_type)
Number_of_rideable_and_user_type <- as.data.frame(bq_table_download(tb_trips_rideable_and_user_type, n_max=Inf)) 


