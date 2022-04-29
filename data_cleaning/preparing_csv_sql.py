# -*- coding: utf-8 -*-
"""
Created on Mon Apr 25 00:29:30 2022

@author: ibrahim Volpi
"""
### execute on the same directory than the files to be added the headers same as in CSV file with the headers on ("Tester.csv") ###
### output will be a csv file on the same directory with the adding of "headed_" at the beggining of the filename
import pandas as pd
import os

directory = './no_names/'

tester = pd.read_csv('TESTER.csv')
names = list(tester.columns)

for filname in os.listdir(directory):
    temp = str(filname)
    df = pd.read_csv(directory + str(filname))
    df.columns = names
    df.to_csv('headed_{}'.format(temp), index = False)
    
    