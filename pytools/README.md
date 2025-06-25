# NocoBase Python Tools

This directory provides a simple Python library for interacting with the NocoBase REST API.
It can create collections from SQL files and import CSV data into an existing collection.

## Usage

Run the module as a script:

```bash
python -m nocobase_api --base-url http://localhost:13000/api \
    --username admin --password secret \
    --sql schema.sql \
    --csv data.csv --collection posts
```

Only the options you need are required. Use `--sql` to create tables from a SQL
file and `--csv` with `--collection` to import CSV rows.

