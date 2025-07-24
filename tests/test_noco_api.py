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


def test_update_record():
    api = NocoAPI("http://api", "token")
    fake_resp = mock.Mock()
    fake_resp.json.return_value = {"data": {"id": 1}}
    fake_resp.raise_for_status.return_value = None

    with mock.patch.object(requests, "post", return_value=fake_resp) as post:
        result = api.update_record("posts", "1", {"name": "B"})

    post.assert_called_once_with(
        "http://api/posts:update",
        json={"filter": {"id": "1"}, "values": {"name": "B"}},
        headers=api._headers(),
    )
    assert result == {"id": 1}


def test_upsert_record_update_success():
    api = NocoAPI("http://api", "token")
    with mock.patch.object(api, "update_record", return_value={"ok": True}) as upd, \
        mock.patch.object(api, "create_record") as create:
        result = api.upsert_record("posts", "1", {"name": "B"})

    upd.assert_called_once_with("posts", "1", {"name": "B"})
    create.assert_not_called()
    assert result == {"ok": True}


def test_upsert_record_fallback_to_create():
    api = NocoAPI("http://api", "token")
    with mock.patch.object(api, "update_record", side_effect=RuntimeError):
        with mock.patch.object(api, "create_record", return_value={"id": 2}) as cr:
            result = api.upsert_record("posts", "2", {"name": "C"})

    cr.assert_called_once_with("posts", {"name": "C"})
    assert result == {"id": 2}


def test_upsert_record_create_when_no_id():
    api = NocoAPI("http://api", "token")
    with mock.patch.object(api, "create_record", return_value={"id": 3}) as cr:
        result = api.upsert_record("posts", None, {"name": "D"})

    cr.assert_called_once_with("posts", {"name": "D"})
    assert result == {"id": 3}

