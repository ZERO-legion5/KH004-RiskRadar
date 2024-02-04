from typing import Union
from fastapi import FastAPI, Query
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

    cursor.execute('SELECT * FROM KH ORDER BY datetime DESC LIMIT 10')
    dat = cursor.fetchall()
    
    mdl = joblib.load('xgbAnon.pkl')
    results = []

    for dat in dat:

        df = pd.DataFrame({
            'trans_num' : dat[0], 
            'merchant' : dat[1], 
            'category' : dat[2],
            'amt' : dat[3],
            'gender' : dat[4],
            'lat' : dat[5],
            'long' : dat[6], 
            'city_pop' : dat[7], 
            'job' : dat[8],
            'age' : dat[9], 
            'timestamp_year' : dat[10], 
            'timestamp_month' : dat[11],
            'timestamp_day' : dat[12], 
            'timestamp_hour' : dat[13], 
            'timestamp_min' : dat[14], 
            'timestamp_second' : dat[15]}, index = [0])
        
        ypred = mdl.predict(df.drop('trans_num', axis = 1))
        results.append({'trans_num': dat[0], 'datetime' : dat[16],  'class' : ypred.item(), 'prediction': 'Fraud' if ypred.item() == 1 else 'Not a Fraud'})

    conn.close()
    return results

@app.get("/request/")
async def process_data(trans_num: str = Query(..., description="Description for input7")):
    
    conn = sqlite3.connect('database.db')
    cursor = conn.cursor()

    cursor.execute("SELECT * FROM KH WHERE trans_num = '" + trans_num + "'")
    dat = cursor.fetchall()[0]
    
    mdl = joblib.load('xgbAnon.pkl')
    results = []

    df = pd.DataFrame({
        'trans_num' : dat[0], 
        'merchant' : dat[1], 
        'category' : dat[2],
        'amt' : dat[3],
        'gender' : dat[4],
        'lat' : dat[5],
        'long' : dat[6], 
        'city_pop' : dat[7], 
        'job' : dat[8],
        'age' : dat[9], 
        'timestamp_year' : dat[10], 
        'timestamp_month' : dat[11],
        'timestamp_day' : dat[12], 
        'timestamp_hour' : dat[13], 
        'timestamp_min' : dat[14], 
        'timestamp_second' : dat[15]}, index = [0])
        
    ypred = mdl.predict(df.drop('trans_num', axis = 1))
    data = {'trans_num': dat[0], 'datetime' : dat[16],  'class' : ypred.item(), 'prediction': 'Fraud' if ypred.item() == 1 else 'Not a Fraud'}

    conn.close()
    return data

