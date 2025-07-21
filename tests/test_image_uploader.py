from unittest import mock
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

