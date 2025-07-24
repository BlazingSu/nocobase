import argparse

from agents.auth import authenticate_user
from agents.noco_api import NocoAPI
from agents.data_uploader import upload_csv_data
from agents.csv_generator import generate_template


def main() -> None:
    """Generate templates or upload CSV records to NocoBase collections."""
    parser = argparse.ArgumentParser(description="NocoBase CSV helper")
    sub = parser.add_subparsers(dest="command", required=True)

    tmpl = sub.add_parser("template", help="Download CSV template")
    tmpl.add_argument("api_url", help="Base API URL")
    tmpl.add_argument("username", help="User email for authentication")
    tmpl.add_argument("password", help="User password")
    tmpl.add_argument("collection", help="Collection name")
    tmpl.add_argument("output_csv", help="Path to write the template CSV")
    tmpl.add_argument("--authenticator", default="local", help="Authenticator name")
    tmpl.add_argument(
        "--include-data",
        action="store_true",
        help="Include existing records in the template",
    )

    up = sub.add_parser("upload", help="Upload CSV data")
    up.add_argument("api_url", help="Base API URL")
    up.add_argument("username", help="User email for authentication")
    up.add_argument("password", help="User password")
    up.add_argument("collection", help="Collection name")
    up.add_argument("csv_file", help="CSV file with records")
    up.add_argument("--authenticator", default="local", help="Authenticator name")
    up.add_argument(
        "--encoding",
        default="utf-8",
        help="Encoding of the CSV file (default: utf-8)",
    )
    up.add_argument(
        "--use-upsert",
        action="store_true",
        help="Use upsert when an id column is present",
    )

    args = parser.parse_args()

    token = authenticate_user(args.api_url, args.username, args.password, args.authenticator)
    api = NocoAPI(args.api_url, token)

    if args.command == "template":
        generate_template(
            args.output_csv,
            args.collection,
            api,
            include_data=args.include_data,
        )
    elif args.command == "upload":
        upload_csv_data(
            args.csv_file,
            args.collection,
            api,
            encoding=args.encoding,
            use_upsert=args.use_upsert,
        )


if __name__ == "__main__":
    main()
