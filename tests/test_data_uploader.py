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

