from typing import Union
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return "Hello World"

@app.get("/requestall/")
def requestall():
    return "Under Construction"