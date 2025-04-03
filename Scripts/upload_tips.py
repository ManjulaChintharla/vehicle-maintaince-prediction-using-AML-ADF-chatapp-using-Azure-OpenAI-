import psycopg2
from docx import Document
import os

# Database connection details
DB_NAME = "your_database"
DB_USER = "your_username"
DB_PASSWORD = "your_password"
DB_HOST = "your_host"
DB_PORT = "your_port"

# Get the absolute path of the repository
repo_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

# Correct file path
doc_path = os.path.join(repo_root, "Data", "Fleet_Maintenance_Tips.docx")
print(f"Using document path: {doc_path}")

# Ensure the file exists before reading
if not os.path.exists(doc_path):
    print(f"Error: File '{doc_path}' not found!")
    exit(1)  # Exit script if file is missing

# Load the document
document = Document(doc_path)  # ✅ Fix: Define `document`

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

            # Connect to PostgreSQL
            conn = psycopg2.connect(
                dbname=DB_NAME,
                user=DB_USER,
                password=DB_PASSWORD,
                host=DB_HOST,
                port=DB_PORT
            )
            cursor = conn.cursor()

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
