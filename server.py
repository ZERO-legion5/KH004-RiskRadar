import sqlite3
import time
import pandas as pd
import random
import smtplib
from email.message import EmailMessage

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
    datetime DATE DEFAULT (datetime('now','localtime'))
);
''')
conn.commit()

def insert_data(dat):

    s = 'INSERT INTO KH (trans_num, merchant, category, amt, gender, lat, long, city_pop, job, age, timestamp_year, timestamp_month, timestamp_day, timestamp_hour, timestamp_min, timestamp_second) VALUES ('
    
    # Properly format trans_num within the SQL query
    s += f'"{dat[0]}", '

    # Add the rest of the values
    s += ', '.join(list(map(str, dat[1:])))
    s += ');'
    
    cursor.execute(s)
    conn.commit()

df = pd.read_csv('fraudDataAnon.csv', index_col=0)

def alert(trxno):

    sender = "emailalerts76@gmail.com"
    receiver = "zerolegion5@gmail.com"

    s = smtplib.SMTP('smtp.gmail.com', 587)
    s.starttls()
    s.login(sender, "dyul espr lymt wjwa")

    em = EmailMessage()
    em['From'] = sender
    em['To'] = receiver
    em['Subject'] = f"⚠️ Critical Level ALERT - {trxno}"
    em.set_content(f'Transaction {trxno} has been deteced as fraud. Immediate action required. Predefined solutions include adding the user to a blacklist and forward to higher ranking personnel and authorities related to Fraud Management.') 

    s.sendmail(sender, receiver, em.as_string())
    s.quit()

try:
    while True:

        threshold = 199
        val = random.randint(0,200)

        dat = df.iloc[random.randint(0, df.shape[0] - 1), :]

        if val <= threshold and dat.iloc[1] == 1:

            continue

        if dat.iloc[1] == 1:

            alert(dat.iloc[0])
        
        data = list(dat.values)
        data.pop(1)

        conn = sqlite3.connect('database.db')
        cursor = conn.cursor()

        print(dat)
        insert_data(data)

        conn.commit()
        conn.close()

        time.sleep(random.randint(1,4))

except KeyboardInterrupt:
    print("Exiting the program.")

finally:
    conn.close()
