#This script connects to your PostgreSQL database, retrieves the embeddings, formats them into JSON, and uploads them to Azure AI Search.

import psycopg2
import requests
import json

# Connect to PostgreSQL
conn = psycopg2.connect(
    dbname="your_db",
    user="your_user",
    password="your_password",
    host="your_host",
    port="your_port"
)
cur = conn.cursor()

# Retrieve embeddings
cur.execute("SELECT id, embedding FROM your_table")
rows = cur.fetchall()

# Prepare data for Azure AI Search
documents = []
for row in rows:
    doc = {
        "id": row[0],
        "embedding": row[1]
    }
    documents.append(doc)

# Define your Azure AI Search endpoint and API key
search_service_name = "your_search_service_name"
index_name = "your_index_name"
api_key = "your_api_key"
endpoint = f"https://{search_service_name}.search.windows.net/indexes/{index_name}/docs/index?api-version=2021-04-30-Preview"

# Upload data to Azure AI Search
headers = {
    "Content-Type": "application/json",
    "api-key": api_key
}
data = {
    "value": documents
}
response = requests.post(endpoint, headers=headers, data=json.dumps(data))

if response.status_code == 200:
    print("Data uploaded successfully")
else:
    print(f"Failed to upload data: {response.status_code}, {response.text}")

# Close the connection
cur.close()
conn.close()
