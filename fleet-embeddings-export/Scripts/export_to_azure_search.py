import os
import json
import requests
import psycopg2
from dotenv import load_dotenv

load_dotenv()

# PostgreSQL setup
conn = psycopg2.connect(
    host=os.getenv("PG_HOST"),
    dbname=os.getenv("PG_DB"),
    user=os.getenv("PG_USER"),
    password=os.getenv("PG_PASSWORD"),
    port=os.getenv("PG_PORT")
)
cur = conn.cursor()

# Azure Search setup
search_endpoint = os.getenv("AZURE_SEARCH_ENDPOINT")
admin_key = os.getenv("AZURE_SEARCH_ADMIN_KEY")
index_name = "fleetdocs-index"  # Customize if needed

# Create index (one-time)
headers = {
    "Content-Type": "application/json",
    "api-key": admin_key
}

index_schema = {
    "name": index_name,
    "fields": [
        {"name": "id", "type": "Edm.String", "key": True},
        {"name": "filename", "type": "Edm.String"},
        {"name": "content", "type": "Edm.String"},
        {"name": "embedding", "type": "Collection(Edm.Single)", "searchable": True, "vectorSearchDimensions": 1536}
    ],
    "vectorSearch": {
        "algorithmConfigurations": [
            {"name": "default", "kind": "hnsw"}
        ]
    }
}

requests.put(f"{search_endpoint}/indexes/{index_name}?api-version=2023-07-01-preview", headers=headers, json=index_schema)

# Fetch from DB
cur.execute("SELECT id, filename, content, embedding FROM fleet_docs")
rows = cur.fetchall()

# Prepare upload docs
docs = []
for row in rows:
    doc = {
        "@search.action": "upload",
        "id": str(row[0]),
        "filename": row[1],
        "content": row[2],
        "embedding": row[3]
    }
    docs.append(doc)

# Upload documents
upload_url = f"{search_endpoint}/indexes/{index_name}/docs/index?api-version=2023-07-01-preview"
upload_headers = {
    "Content-Type": "application/json",
    "api-key": admin_key
}
upload_body = {"value": docs}
resp = requests.post(upload_url, headers=upload_headers, json=upload_body)

if resp.status_code == 200:
    print("✅ Documents successfully uploaded to Azure AI Search.")
else:
    print(f"❌ Failed to upload documents: {resp.text}")

cur.close()
conn.close()
