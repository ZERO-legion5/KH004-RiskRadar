import sqlite3
import time
from datetime import datetime

conn = sqlite3.connect('database.db')
cursor = conn.cursor()

cursor.execute('''
    CREATE TABLE IF NOT EXISTS data_table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        value INTEGER,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
    )
''')
conn.commit()

def insert_data(value):
    cursor.execute('INSERT INTO data_table (value) VALUES (?)', (value,))
    conn.commit()

try:
    while True:
        data_value = 42
        insert_data(data_value)
        print(f"Data uploaded to database at {datetime.now()}")
        time.sleep(1)

except KeyboardInterrupt:
    print("Exiting the program.")
finally:
    conn.close()
