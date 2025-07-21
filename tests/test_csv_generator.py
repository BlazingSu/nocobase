import csv
import os

from agents import csv_generator


def test_generate_csv(tmp_path):
    csv_file = tmp_path / "out.csv"
    field_names = ["id", "name", "image"]
    records = [{"id": 1, "name": "A"}]

    csv_generator.generate_csv(str(csv_file), field_names, records, image_field="image", image_url="http://img")

    with open(csv_file, newline="", encoding="utf-8") as f:
        rows = list(csv.DictReader(f))

    assert rows == [{"id": "1", "name": "A", "image": "http://img"}]

