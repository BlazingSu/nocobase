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
        writer = csv.DictWriter(
            csvfile, fieldnames=field_names, extrasaction="ignore"
        )
        writer.writeheader()
        for record in records:
            row = {key: record.get(key) for key in field_names}
            if image_field and image_url:
                row[image_field] = image_url
            writer.writerow(row)


def generate_template(
    csv_file_path: str,
    collection_name: str,
    api: NocoAPI,
    *,
    include_data: bool = False,
) -> None:
    """Generate a CSV template for a collection.

    Parameters
    ----------
    csv_file_path: str
        Output CSV file path.
    collection_name: str
        Name of the collection to inspect for fields.
    api: NocoAPI
        Authenticated API client used to fetch field information.
    include_data: bool, optional
        If ``True`` include existing records in the generated CSV.
    """
    fields = api.list_fields(collection_name)

    relation_interfaces = {
        "o2o",
        "oho",
        "obo",
        "o2m",
        "m2o",
        "m2m",
        "linkTo",
        "mbm",
        "subTable",
    }
    relation_types = {
        "belongsTo",
        "hasOne",
        "hasMany",
        "belongsToMany",
        "linkTo",
    }

    field_names = [
        f["name"]
        for f in fields
        if f.get("interface") not in relation_interfaces
        and f.get("type") not in relation_types
        and f.get("interface") != "formula"
        and f.get("type") != "formula"
    ]

    records: Iterable[Dict[str, Any]] = []
    if include_data:
        records = api.list_records(collection_name)
    generate_csv(csv_file_path, field_names, records)

