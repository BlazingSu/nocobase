import csv
from .client import NocoBaseClient
from .sql_utils import parse_sql_file


def create_tables_from_sql(client: NocoBaseClient, sql_path: str):
    tables = parse_sql_file(sql_path)
    for table in tables:
        client.create_collection(table["name"], table["fields"])


def import_csv(client: NocoBaseClient, collection: str, csv_path: str):
    with open(csv_path, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            client.create_record(collection, row)

