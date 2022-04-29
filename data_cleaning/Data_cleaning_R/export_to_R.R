### EXPORT to R

install.packages('bigrquery')
library(bigrquery)
library(gridExtra)
library(scales)
bigrquery::bq_auth(path = 'CAPSTONE_KEYS.json' )


sql_all_trips_12_months <- "SELECT * FROM `tidal-tower-348213.Data_trips_12_month.Data_trips_12_months`"
tb_all_trips_12_months <- bq_project_query(projectid, sql_all_trips_12_months)
data_12_months <- as.data.frame(bq_table_download(tb_all_trips_12_months, n_max=Inf))
write.csv(data_12_months,"D:/data_12_months.csv", row.names = TRUE)