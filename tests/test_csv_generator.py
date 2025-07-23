import csv
import os
from unittest import mock

from agents import csv_generator


def test_generate_csv(tmp_path):
    csv_file = tmp_path / "out.csv"
    field_names = ["id", "name", "image"]
    records = [{"id": 1, "name": "A"}]

    csv_generator.generate_csv(str(csv_file), field_names, records, image_field="image", image_url="http://img")

    with open(csv_file, newline="", encoding="utf-8") as f:
        rows = list(csv.DictReader(f))

    assert rows == [{"id": "1", "name": "A", "image": "http://img"}]


def test_generate_csv_ignore_extra_fields(tmp_path):
    csv_file = tmp_path / "extra.csv"
    field_names = ["id", "name"]
    records = [{"id": 1, "name": "A", "unused": "x"}]

    csv_generator.generate_csv(str(csv_file), field_names, records)

    with open(csv_file, newline="", encoding="utf-8") as f:
        rows = list(csv.DictReader(f))

    assert rows == [{"id": "1", "name": "A"}]


def test_generate_template(tmp_path):
    csv_file = tmp_path / "template.csv"
    api = mock.Mock()
    api.list_fields.return_value = [{"name": "id"}, {"name": "name"}]

    csv_generator.generate_template(str(csv_file), "posts", api, include_data=False)

    with open(csv_file, newline="", encoding="utf-8") as f:
        reader = csv.reader(f)
        headers = next(reader)


    assert headers == ["id", "name"]


def test_generate_template_with_data(tmp_path):
    csv_file = tmp_path / "template.csv"
    api = mock.Mock()
    api.list_fields.return_value = [{"name": "id"}, {"name": "name"}]
    api.list_records.return_value = [{"id": 1, "name": "A", "extra": "x"}]

    csv_generator.generate_template(str(csv_file), "posts", api, include_data=True)

    with open(csv_file, newline="", encoding="utf-8") as f:
        rows = list(csv.DictReader(f))

    assert rows == [{"id": "1", "name": "A"}]

