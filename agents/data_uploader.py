import csv
from typing import Any, Dict

from .noco_api import NocoAPI


def upload_csv_data(csv_file_path: str, collection_name: str, api: NocoAPI) -> None:
    """Upload records from a CSV file to a NocoBase collection.

    Parameters
    ----------
    csv_file_path: str
        Path to the CSV file containing records.
    collection_name: str
        Name of the collection to upload records to.
    api: NocoAPI
        Authenticated API client.
    """
    with open(csv_file_path, newline="", encoding="utf-8") as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            api.create_record(collection_name, row)

