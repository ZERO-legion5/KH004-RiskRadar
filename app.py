from typing import Union
from fastapi import FastAPI
import sqlite3
import joblib
import pandas as pd

app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/requestall/")
def requestall():

    conn = sqlite3.connect('database.db')
    cursor = conn.cursor()

    cursor.execute('SELECT * FROM KH ORDER BY timestamp DESC LIMIT 10')
    dat = cursor.fetchall()
    
    mdl = joblib.load('xgbAnon.pkl')
    results = []

    for i in dat:

        df = pd.DataFrame({
            'trans_num' : i[0], 
            'merchant' : i[1], 
            'category' : i[2],
            'amt' : i[3],
            'gender' : i[4],
            'lat' : i[5],
            'long' : i[6], 
            'city_pop' : i[7], 
            'job' : i[8],
            'age' : i[9], 
            'timestamp_year' : i[10], 
            'timestamp_month' : i[11],
            'timestamp_day' : i[12], 
            'timestamp_hour' : i[13], 
            'timestamp_min' : i[14], 
            'timestamp_second' : i[15]}, index = [0])
        
        ypred = mdl.predict(df.drop('trans_num', axis = 1))
        results.append({'trans_num': i[0], 'prediction': ypred.item()})

    conn.close()
    return results
