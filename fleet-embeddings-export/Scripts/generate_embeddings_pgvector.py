import os
import psycopg2
import openai
from docx import Document
from dotenv import load_dotenv

load_dotenv()

# Azure OpenAI settings
openai.api_key = os.getenv("AZURE_OPENAI_KEY")
openai.api_base = os.getenv("AZURE_OPENAI_ENDPOINT")
openai.api_type = "azure"
openai.api_version = "2023-05-15"
deployment = os.getenv("AZURE_OPENAI_DEPLOYMENT")

# PostgreSQL connection
conn = psycopg2.connect(
    host=os.getenv("PG_HOST"),
    dbname=os.getenv("PG_DB"),
    user=os.getenv("PG_USER"),
    password=os.getenv("PG_PASSWORD"),
    port=os.getenv("PG_PORT")
)
cur = conn.cursor()

# Create table
cur.execute("""
CREATE TABLE IF NOT EXISTS fleet_docs (
    id SERIAL PRIMARY KEY,
    filename TEXT,
    content TEXT,
    embedding VECTOR(1536)
);
""")
conn.commit()

# Function to extract text from DOCX
def extract_text_from_docx(file_path):
    doc = Document(file_path)
    return "\n".join([para.text for para in doc.paragraphs if para.text.strip()])

# Process files
data_folder = "./Data"
for fname in os.listdir(data_folder):
    if fname.endswith(".docx"):
        path = os.path.join(data_folder, fname)
        text = extract_text_from_docx(path)

        # Create embedding
        response = openai.Embedding.create(
            input=text,
            deployment_id=deployment
        )
        embedding = response["data"][0]["embedding"]

        # Insert into DB
        cur.execute(
            "INSERT INTO fleet_docs (filename, content, embedding) VALUES (%s, %s, %s);",
            (fname, text, embedding)
        )
        conn.commit()

print("✅ Embeddings generated and inserted into PostgreSQL.")
cur.close()
conn.close()

