from unittest import mock
import requests

from agents import auth, config


def test_authenticate_user_success():
    fake_response = mock.Mock()
    fake_response.json.return_value = {"data": {"token": "abc"}}
    fake_response.raise_for_status.return_value = None

    with (
        mock.patch.object(requests, "post", return_value=fake_response) as post,
        mock.patch.object(config, "API_URL", "http://api"),
        mock.patch.object(config, "USERNAME", "user"),
        mock.patch.object(config, "PASSWORD", "pass"),
        mock.patch.object(config, "AUTHENTICATOR", "basic"),
    ):
        token = auth.authenticate_user()

    post.assert_called_once()
    assert token == "abc"

