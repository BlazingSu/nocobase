from unittest import mock
import requests

from agents.noco_api import NocoAPI


def test_list_collections():
    api = NocoAPI("http://api", "token")
    fake_resp = mock.Mock()
    fake_resp.json.return_value = {"data": ["c1", "c2"]}
    fake_resp.raise_for_status.return_value = None

    with mock.patch.object(requests, "get", return_value=fake_resp) as get:
        result = api.list_collections()

    get.assert_called_once()
    assert result == ["c1", "c2"]


def test_list_fields():
    api = NocoAPI("http://api", "token")
    fake_resp = mock.Mock()
    fake_resp.json.return_value = {"data": ["f1", "f2"]}
    fake_resp.raise_for_status.return_value = None

    with mock.patch.object(requests, "get", return_value=fake_resp) as get:
        result = api.list_fields("posts")

    get.assert_called_once_with(
        "http://api/collections/posts/fields:list",
        headers=api._headers(),
        params={"paginate": "false"},
    )
    assert result == ["f1", "f2"]


def test_list_records():
    api = NocoAPI("http://api", "token")
    fake_resp = mock.Mock()
    fake_resp.json.return_value = {"data": [{"name": "A"}]}
    fake_resp.raise_for_status.return_value = None

    with mock.patch.object(requests, "get", return_value=fake_resp) as get:
        result = api.list_records("posts")

    get.assert_called_once_with(
        "http://api/posts:list",
        headers=api._headers(),
        params={"paginate": "false"},
    )
    assert result == [{"name": "A"}]

