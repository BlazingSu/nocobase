import ast
import csv
from typing import Any, Dict

from .noco_api import NocoAPI


def sanitize_row(row: Dict[str, Any], *, parse_lists: bool = True) -> Dict[str, Any]:
    """Return a sanitized copy of a CSV row.

    Empty strings are converted to ``None``. When ``parse_lists`` is ``True``,
    values that look like Python list literals are converted to actual lists
    using :func:`ast.literal_eval`.
    """

    sanitized: Dict[str, Any] = {}
    for key, value in row.items():
        if value == "":
            sanitized[key] = None
            continue

        if parse_lists and isinstance(value, str):
            text = value.strip()
            if text.startswith("[") and text.endswith("]"):
                try:
                    sanitized[key] = ast.literal_eval(text)
                    continue
                except (ValueError, SyntaxError):  # pragma: no cover - safety
                    pass

        sanitized[key] = value

    return sanitized


def upload_csv_data(
    csv_file_path: str,
    collection_name: str,
    api: NocoAPI,
    *,
    encoding: str = "utf-8",
    use_upsert: bool = False,
) -> None:
    """Upload records from a CSV file to a NocoBase collection.

    Parameters
    ----------
    csv_file_path: str
        Path to the CSV file containing records.
    collection_name: str
        Name of the collection to upload records to.
    api: NocoAPI
        Authenticated API client.
    encoding: str, optional
        Character encoding used when reading ``csv_file_path``.
    use_upsert: bool, optional
        When ``True`` and the CSV contains an ``id`` column, use
        :meth:`NocoAPI.upsert_record` instead of
        :meth:`NocoAPI.create_record`.
    """
    with open(csv_file_path, newline="", encoding=encoding) as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            sanitized = sanitize_row(row)
            if use_upsert and "id" in sanitized and sanitized["id"] is not None:
                record_id = sanitized.pop("id")
                api.upsert_record(collection_name, record_id, sanitized)
            else:
                api.create_record(collection_name, sanitized)

