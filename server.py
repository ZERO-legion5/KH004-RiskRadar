import sqlite3
import time
import pandas as pd
import random

conn = sqlite3.connect('database.db')
cursor = conn.cursor()

cursor.execute('''
    CREATE TABLE IF NOT EXISTS KH(
    trans_num VARCHAR(255),
    merchant FLOAT,
    category FLOAT,
    amt FLOAT,
    gender FLOAT,
    lat FLOAT,
    long FLOAT,
    city_pop FLOAT,
    job FLOAT,
    age FLOAT,
    timestamp_year FLOAT,
    timestamp_month FLOAT,
    timestamp_day FLOAT,
    timestamp_hour FLOAT,
    timestamp_min FLOAT,
    timestamp_second FLOAT,
    timestamp timestamp default current_timestamp
);
''')
conn.commit()

def insert_data(dat):

    s = 'INSERT INTO KH (trans_num, merchant, category, amt, gender, lat, long, city_pop, job, age, timestamp_year, timestamp_month, timestamp_day, timestamp_hour, timestamp_min, timestamp_second) VALUES ('
    
    # Properly format trans_num within the SQL query
    s += f'"{dat["trans_num"]}", '

    # Add the rest of the values
    s += ', '.join(list(map(str, dat[1:])))
    s += ');'
    
    cursor.execute(s)
    conn.commit()

df = pd.read_csv('fraudDataAnon.csv', index_col=0)
df.drop(columns= ['is_fraud'],inplace=True)

try:
    while True:

        dat = df.iloc[random.randint(0, df.shape[0] - 1), :]

        conn = sqlite3.connect('database.db')
        cursor = conn.cursor()

        print(dat)
        insert_data(dat)

        conn.commit()
        conn.close()

        time.sleep(2)

except KeyboardInterrupt:
    print("Exiting the program.")

finally:
    conn.close()
