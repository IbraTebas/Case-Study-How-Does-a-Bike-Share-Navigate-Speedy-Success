# -*- coding: utf-8 -*-
"""
Created on Wed Apr 27 11:14:03 2022

@author: ibrah
"""

import pandas as pd
import numpy as np

data = pd.read_csv('data_12_months_remove_station_nan.csv')
geo_columns=["start_lat","start_lng","end_lat", "end_lng"]


#Drop two redundant index columns
data.drop('Unnamed: 0', inplace=True, axis=1)
data.drop('X', inplace=True, axis=1)

#convert geolocation coordinates into float with 4 decimals. 
for i in geo_columns:
    data[i] = pd.to_numeric(data[i])
    data[i]= np.round(data[i], decimals = 4)

#construct the other dataFrames for the task, one DF named data_NaN for geoloc. of rows with NaN and another DF data_no_NaN with rows with no NaN
data_NaN = data[pd.isnull(data['end_station_name'])]
data_NaN_coord = data_NaN[geo_columns]
data_no_NaN = data.dropna()

Tester = data_NaN.head()
# Names = []
# for row in data_NaN.itertuples(index=False):
#     try:    
#         Names = Names + [max(data_no_NaN.query(("start_lat == {} and start_lng == {}".format(row[6],row[7]))))["start_station_name"]]
#     except:
#         Names = Names + [""]
        
        
  
    