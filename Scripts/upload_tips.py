import psycopg2
from docx import Document
import os

# Database connection details
DB_NAME = "your_database"
DB_USER = "your_username"
DB_PASSWORD = "your_password"
DB_HOST = "your_host"
DB_PORT = "your_port"

# Connect to PostgreSQL
conn = psycopg2.connect(
    dbname=DB_NAME,
    user=DB_USER,
    password=DB_PASSWORD,
    host=DB_HOST,
    port=DB_PORT
)
cursor = conn.cursor()

# Load the document

doc_path = os.path.abspath("Data/Fleet_Maintenance_Tips.docx")
print(f"Using document path: {doc_path}")


# Parse and insert data
parameter = None
for para in document.paragraphs:
    text = para.text.strip()
    
    # Identify sections (parameters) like "Engine Health", "Vehicle Speed Sensor"
    if text and not text.isnumeric() and len(text.split()) < 5:
        parameter = text
    
    # Identify threshold, condition, tip, and cost (assuming table-like structure in doc)
    elif text and " - " in text:  
        parts = text.split(" - ")
        if len(parts) == 4:
            threshold, condition, maintenance_tip, estimated_cost = parts

            # Insert into PostgreSQL
            cursor.execute("""
                INSERT INTO fleet_maintenance_tips (parameter, threshold, condition, maintenance_tip, estimated_cost)
                VALUES (%s, %s, %s, %s, %s)
            """, (parameter, threshold, condition, maintenance_tip, estimated_cost))

# Commit and close connection
conn.commit()
cursor.close()
conn.close()

print("Fleet maintenance tips successfully uploaded to PostgreSQL.")
