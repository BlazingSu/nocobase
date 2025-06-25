import argparse
from .client import NocoBaseClient
from .bulk_tools import create_tables_from_sql, import_csv


def main():
    parser = argparse.ArgumentParser(description="NocoBase API helper")
    parser.add_argument("--base-url", required=True, help="Base API URL, e.g. http://localhost:13000/api")
    parser.add_argument("--username", required=True, help="Login username")
    parser.add_argument("--password", required=True, help="Login password")
    parser.add_argument("--sql", help="SQL file for creating tables")
    parser.add_argument("--csv", help="CSV file for importing records")
    parser.add_argument("--collection", help="Target collection for CSV import")
    args = parser.parse_args()

    client = NocoBaseClient(args.base_url, args.username, args.password)
    client.sign_in()

    if args.sql:
        create_tables_from_sql(client, args.sql)

    if args.csv and args.collection:
        import_csv(client, args.collection, args.csv)


if __name__ == "__main__":
    main()

