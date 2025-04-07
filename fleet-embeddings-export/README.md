# Fleet Maintenance Embedding & Azure AI Search Integration

This project:
- Loads `.docx` documents related to fleet maintenance.
- Converts content into vector embeddings using Azure OpenAI.
- Stores embeddings in Azure PostgreSQL with `pgvector`.
- Exports embeddings to Azure AI Search for semantic search.

## Folder Structure
```
fleet-embeddings-export/
├── Data/                         # Contains .docx files
├── scripts/
│   ├── generate_embeddings_pgvector.py
│   └── export_to_azure_search.py
├── .env.example
├── requirements.txt
└── README.md
```

## Setup

1. Install requirements:

```bash
pip install -r requirements.txt
```

2. Configure `.env`:

```bash
cp .env.example .env
# Then edit with your credentials
```

3. Run scripts:

```bash
python scripts/generate_embeddings_pgvector.py
python scripts/export_to_azure_search.py
```
