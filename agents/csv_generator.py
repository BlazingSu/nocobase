import csv
from typing import Any, Dict, Iterable, List, Optional

from .noco_api import NocoAPI


def generate_csv(csv_file_path: str, field_names: List[str], records: Iterable[Dict[str, Any]], image_field: Optional[str] = None, image_url: Optional[str] = None) -> None:
    """Generate a CSV file from records.

    Parameters
    ----------
    csv_file_path: str
        Output CSV file path.
    field_names: List[str]
        List of field names (column headers).
    records: Iterable[Dict[str, Any]]
        Iterable of record dictionaries.
    image_field: Optional[str]
        Field name to insert an image URL.
    image_url: Optional[str]
        Image URL to insert into each record if `image_field` is given.
    """
    with open(csv_file_path, "w", newline="", encoding="utf-8") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=field_names)
        writer.writeheader()
        for record in records:
            row = dict(record)
            if image_field and image_url:
                row[image_field] = image_url
            writer.writerow(row)


def generate_template(csv_file_path: str, collection_name: str, api: NocoAPI) -> None:
    """Generate an empty CSV template for a collection.

    Parameters
    ----------
    csv_file_path: str
        Output CSV file path.
    collection_name: str
        Name of the collection to inspect for fields.
    api: NocoAPI
        Authenticated API client used to fetch field information.
    """
    fields = api.list_fields(collection_name)
    field_names = [field["name"] for field in fields]
    generate_csv(csv_file_path, field_names, [])

