import os
import socket
import time
from html import escape

import psycopg
from fastapi import FastAPI
from fastapi.responses import HTMLResponse
from pydantic import BaseModel

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
        row = c.execute(
            "INSERT INTO items (text) VALUES (%s) RETURNING id", (item.text,)
        ).fetchone()
    return {"id": row[0], "text": item.text}


@app.get("/items")
def list_items():
    with conn() as c:
        rows = c.execute("SELECT id, text FROM items ORDER BY id").fetchall()
    return [{"id": r[0], "text": r[1]} for r in rows]


PAGE = """<!doctype html>
<html lang="en" data-state="__STATE__">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>dev-app</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Schibsted+Grotesk:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
:root{--mist:#edf1f5;--paper:#fff;--ink:#0f1b2d;--slate:#5b6b7f;--line:#d5dde6;--accent:#3b5bff;--ok:#0e9f6e;--bad:#d64545;--mono:ui-monospace,SFMono-Regular,Menlo,Consolas,monospace}
*{box-sizing:border-box}
body{margin:0;background:var(--mist);color:var(--ink);font:16px/1.55 "Schibsted Grotesk",system-ui,-apple-system,"Segoe UI",sans-serif}
main{max-width:880px;margin:0 auto;padding:40px 20px 64px}
header{display:flex;flex-wrap:wrap;align-items:center;justify-content:space-between;gap:12px;margin-bottom:28px}
h1{margin:0;font-size:1.75rem;letter-spacing:-.02em}
h2{margin:0 0 4px;font-size:1.15rem;letter-spacing:-.01em}
.sub{margin:0;color:var(--slate)}
.pill{display:inline-flex;align-items:center;gap:8px;padding:6px 14px;border-radius:999px;background:var(--paper);border:1px solid var(--line);font-weight:600;font-size:.9rem}
.dot{width:10px;height:10px;border-radius:50%;background:var(--ok)}
[data-state=ok] .dot{animation:pulse 2.4s ease-out infinite}
[data-state=down] .dot{background:var(--bad)}
@keyframes pulse{0%{box-shadow:0 0 0 0 rgba(14,159,110,.5)}70%,100%{box-shadow:0 0 0 9px rgba(14,159,110,0)}}
.path{display:grid;grid-template-columns:repeat(4,1fr);gap:0;background:var(--paper);border:1px solid var(--line);border-radius:14px;overflow:hidden}
.node{padding:18px 18px 20px;border-left:1px solid var(--line);min-width:0}
.node:first-child{border-left:0}
.node b{display:block;font-size:.95rem}
.node span{display:block;color:var(--slate);font-size:.88rem;overflow-wrap:anywhere}
.node code{display:block;margin-top:8px;font:500 .85rem var(--mono);color:var(--accent);overflow-wrap:anywhere}
[data-state=down] .node.db code{color:var(--bad)}
.banner{margin:16px 0 0;padding:12px 16px;border-radius:10px;background:#fdecec;color:#8a1f1f;border:1px solid #f3c5c5}
[data-state=ok] .banner{display:none}
section{margin-top:28px;background:var(--paper);border:1px solid var(--line);border-radius:14px;padding:24px}
form{display:flex;gap:10px;margin:16px 0 6px}
input{flex:1;min-width:0;padding:11px 14px;border:1px solid var(--line);border-radius:10px;font:inherit;color:var(--ink)}
button{padding:11px 20px;border:0;border-radius:10px;background:var(--accent);color:#fff;font:inherit;font-weight:600;cursor:pointer}
button:disabled{opacity:.6;cursor:default}
input:focus-visible,button:focus-visible,a:focus-visible{outline:3px solid #9fb0ff;outline-offset:2px}
#msg{min-height:1.4em;margin:0;color:var(--slate);font-size:.9rem}
ul{list-style:none;margin:12px 0 0;padding:0}
li{display:flex;gap:14px;padding:11px 0;border-top:1px solid var(--line)}
li .id{flex:none;min-width:2.5rem;color:var(--slate);font-family:var(--mono);font-size:.88rem}
li.empty{color:var(--slate)}
li.empty .id{display:none}
footer{margin-top:24px;display:flex;gap:20px;color:var(--slate);font-size:.92rem}
a{color:var(--accent);font-weight:600}
@media(max-width:700px){.path{grid-template-columns:1fr 1fr}.node:nth-child(3){border-left:0}.node:nth-child(n+3){border-top:1px solid var(--line)}form{flex-direction:column}}
@media(prefers-reduced-motion:reduce){.dot{animation:none!important}}
</style>
</head>
<body>
<main>
<header>
  <div>
    <h1>dev-app</h1>
    <p class="sub">Running on AWS ECS, connected to Amazon RDS for PostgreSQL.</p>
  </div>
  <div class="pill"><span class="dot"></span>__STATUS__</div>
</header>

<div class="path" aria-label="Request path">
  <div class="node"><b>Your browser</b><span>Sends the request over HTTP</span></div>
  <div class="node"><b>Load balancer</b><span>Routes to a healthy container</span></div>
  <div class="node"><b>App container</b><span>FastAPI on ECS</span><code>__HOST__</code></div>
  <div class="node db"><b>Database</b><span>__DBVER__</span><code>__LATENCY__</code></div>
</div>
<p class="banner" role="alert">The app cannot reach the database. Check the RDS instance, its security group, and the DB secret.</p>

<section>
  <h2>Saved items</h2>
  <p class="sub"><span id="count">__COUNT__</span> stored in PostgreSQL</p>
  <form id="add">
    <input id="text" name="text" placeholder="Type something to save" autocomplete="off" maxlength="200" aria-label="Item text">
    <button id="btn" type="submit">Save item</button>
  </form>
  <p id="msg" role="status"></p>
  <ul id="items">__ITEMS__</ul>
</section>

<footer>
  <a href="/docs">API docs</a>
  <a href="/health">Health check</a>
  <span>Environment: __ENV__</span>
</footer>
</main>

<script>
const form = document.getElementById("add");
const input = document.getElementById("text");
const btn = document.getElementById("btn");
const list = document.getElementById("items");
const msg = document.getElementById("msg");
const count = document.getElementById("count");

function render(items) {
  list.replaceChildren();
  if (!items.length) {
    const li = document.createElement("li");
    li.className = "empty";
    li.textContent = "Nothing saved yet. Add an item and it is written to the database.";
    list.appendChild(li);
  }
  items.forEach(function (it) {
    const li = document.createElement("li");
    const id = document.createElement("span");
    id.className = "id";
    id.textContent = "#" + it.id;
    const text = document.createElement("span");
    text.textContent = it.text;
    li.append(id, text);
    list.appendChild(li);
  });
  count.textContent = items.length + (items.length === 1 ? " item" : " items");
}

form.addEventListener("submit", async function (e) {
  e.preventDefault();
  const text = input.value.trim();
  if (!text) return;
  btn.disabled = true;
  try {
    const r = await fetch("/items", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ text: text })
    });
    if (!r.ok) throw new Error("save failed");
    input.value = "";
    render(await (await fetch("/items")).json());
    msg.textContent = "Item saved.";
  } catch (err) {
    msg.textContent = "Could not save the item. Check the database connection.";
  } finally {
    btn.disabled = false;
    input.focus();
  }
});
</script>
</body>
</html>
"""


@app.get("/", response_class=HTMLResponse)
def home():
    host = socket.gethostname()
    env = os.environ.get("APP_ENV", "dev")
    ok = True
    rows = []
    version = "PostgreSQL"
    latency = "unreachable"
    try:
        with conn() as c:
            start = time.perf_counter()
            full_version = c.execute("SELECT version()").fetchone()[0]
            latency = f"{(time.perf_counter() - start) * 1000:.0f} ms query"
            version = " ".join(full_version.split()[:2])
            rows = c.execute("SELECT id, text FROM items ORDER BY id").fetchall()
    except Exception:
        ok = False

    if rows:
        items = "".join(
            f'<li><span class="id">#{r[0]}</span><span>{escape(str(r[1]))}</span></li>'
            for r in rows
        )
    else:
        items = (
            '<li class="empty"><span class="id"></span>'
            "<span>Nothing saved yet. Add an item and it is written to the database.</span></li>"
        )

    html = (
        PAGE.replace("__STATE__", "ok" if ok else "down")
        .replace("__STATUS__", "Healthy" if ok else "Degraded")
        .replace("__HOST__", escape(host))
        .replace("__DBVER__", escape(version) if ok else "PostgreSQL")
        .replace("__LATENCY__", escape(latency))
        .replace("__COUNT__", f"{len(rows)} {'item' if len(rows) == 1 else 'items'}")
        .replace("__ITEMS__", items)
        .replace("__ENV__", escape(env))
    )
    return HTMLResponse(html, status_code=200 if ok else 503)