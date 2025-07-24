from unittest import mock
import csv

from agents.data_uploader import upload_csv_data
from agents.noco_api import NocoAPI


def test_upload_csv_data(tmp_path):
    csv_file = tmp_path / "data.csv"
    with open(csv_file, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=["name"])
        writer.writeheader()
        writer.writerow({"name": "A"})
        writer.writerow({"name": "B"})

    api = NocoAPI("http://api", "token")
    with mock.patch.object(api, "create_record") as create_record:
        upload_csv_data(str(csv_file), "posts", api)

    assert create_record.call_count == 2
    create_record.assert_any_call("posts", {"name": "A"})
    create_record.assert_any_call("posts", {"name": "B"})


def test_empty_strings_become_none(tmp_path):
    csv_file = tmp_path / "data.csv"
    with open(csv_file, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=["name", "desc"])
        writer.writeheader()
        writer.writerow({"name": "A", "desc": ""})

    api = NocoAPI("http://api", "token")
    with mock.patch.object(api, "create_record") as create_record:
        upload_csv_data(str(csv_file), "posts", api)

    create_record.assert_called_once_with("posts", {"name": "A", "desc": None})


def test_list_strings_are_parsed(tmp_path):
    csv_file = tmp_path / "data.csv"
    with open(csv_file, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=["tags"])
        writer.writeheader()
        writer.writerow({"tags": "['服装']"})

    api = NocoAPI("http://api", "token")
    with mock.patch.object(api, "create_record") as create_record:
        upload_csv_data(str(csv_file), "posts", api)

    create_record.assert_called_once_with("posts", {"tags": ["服装"]})


def test_custom_encoding(tmp_path):
    csv_file = tmp_path / "data.csv"
    with open(csv_file, "w", newline="", encoding="latin-1") as f:
        writer = csv.DictWriter(f, fieldnames=["name"])
        writer.writeheader()
        writer.writerow({"name": "Æ"})

    api = NocoAPI("http://api", "token")
    with mock.patch.object(api, "create_record") as create_record:
        upload_csv_data(str(csv_file), "posts", api, encoding="latin-1")

    create_record.assert_called_once_with("posts", {"name": "Æ"})


def test_upsert_when_id_present(tmp_path):
    csv_file = tmp_path / "data.csv"
    with open(csv_file, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=["id", "name"])
        writer.writeheader()
        writer.writerow({"id": "1", "name": "A"})

    api = NocoAPI("http://api", "token")
    with mock.patch.object(api, "upsert_record") as upsert:
        upload_csv_data(str(csv_file), "posts", api, use_upsert=True)

    upsert.assert_called_once_with("posts", "1", {"name": "A"})

