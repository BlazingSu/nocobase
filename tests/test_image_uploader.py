from unittest import mock
import csv
import requests

from agents import image_uploader


def test_upload_image(tmp_path):
    fake_resp = mock.Mock()
    fake_resp.json.return_value = {"data": {"url": "http://img"}}
    fake_resp.raise_for_status.return_value = None

    file_path = tmp_path / "img.png"
    file_path.write_bytes(b"data")

    with mock.patch.object(requests, "post", return_value=fake_resp) as post:
        url = image_uploader.upload_image("http://api", "token", "files", str(file_path))

    post.assert_called_once()
    assert url == "http://img"


def test_upload_images_in_folder(tmp_path):
    folder = tmp_path / "imgs"
    folder.mkdir()
    (folder / "a.png").write_bytes(b"a")
    (folder / "b.png").write_bytes(b"b")

    with mock.patch.object(image_uploader, "upload_image", side_effect=["u1", "u2"]) as up:
        urls = image_uploader.upload_images_in_folder("http://api", "token", "files", str(folder))

    assert urls == ["u1", "u2"]
    assert up.call_count == 2


def test_download_files_csv(tmp_path):
    csv_file = tmp_path / "files.csv"
    api = mock.Mock(spec=image_uploader.NocoAPI)
    api.list_fields.return_value = [{"name": "id"}, {"name": "url"}]
    api.list_records.return_value = [{"id": 1, "url": "http://img"}]

    image_uploader.download_files_csv(api, "files", str(csv_file))

    with open(csv_file, newline="", encoding="utf-8") as f:
        rows = list(csv.DictReader(f))

    assert rows == [{"id": "1", "url": "http://img"}]

