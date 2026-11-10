import os
import psycopg
from fastapi import FastAPI
from pydantic import BaseModel
from fastapi.responses import HTMLResponse

app = FastAPI()

def conn():
    return psycopg.connect(
        host=os.environ["DB_HOST"],
        port=os.environ.get("DB_PORT", "5432"),
        dbname=os.environ["DB_NAME"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
        sslmode="require",  
        connect_timeout=5,
    )

class Item(BaseModel):
    text: str

@app.on_event("startup")
def init():
    with conn() as c:
        c.execute("CREATE TABLE IF NOT EXISTS items (id SERIAL PRIMARY KEY, text TEXT)")

@app.get("/health")
def health():
    with conn() as c:
        c.execute("SELECT 1")
    return {"status": "ok"}

@app.post("/items")
def add(item: Item):
    with conn() as c:
        row = c.execute("INSERT INTO items (text) VALUES (%s) RETURNING id", (item.text,)).fetchone()
    return {"id": row[0], "text": item.text}

@app.get("/items")
def list_items():
    with conn() as c:
        rows = c.execute("SELECT id, text FROM items ORDER BY id").fetchall()
    return [{"id": r[0], "text": r[1]} for r in rows]


@app.get("/", response_class=HTMLResponse)
def home():
    with conn() as c:
        rows = c.execute("SELECT id, text FROM items ORDER BY id").fetchall()
    items = "".join(f"<li>{r[0]}: {r[1]}</li>" for r in rows)
    return f"""
    <h1>dev-app is running</h1>
    <p>Connected to RDS PostgreSQL.</p>
    <ul>{items}</ul>
    <p><a href="/docs">API docs</a> | <a href="/health">Health</a></p>
    """