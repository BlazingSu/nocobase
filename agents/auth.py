import requests


def authenticate_user(api_url: str, username: str, password: str, authenticator: str = "local") -> str:
    """Authenticate with the NocoBase API and return a bearer token.

    Parameters
    ----------
    api_url: str
        Base URL of the NocoBase API (e.g., http://localhost:13000/api)
    username: str
        User email address.
    password: str
        User password.
    authenticator: str, optional
        Name of the authenticator. Defaults to "local".

    Returns
    -------
    str
        Authentication token.

    Raises
    ------
    requests.RequestException
        If the authentication request fails.
    KeyError
        If the token is missing in the response.
    """
    url = f"{api_url}/auth:signIn"
    headers = {
        "Content-Type": "application/json",
        "X-Authenticator": authenticator,
    }
    data = {"email": username, "password": password}

    try:
        response = requests.post(url, json=data, headers=headers)
        response.raise_for_status()
        return response.json()["data"]["token"]
    except (requests.RequestException, KeyError) as exc:
        raise RuntimeError(f"Authentication failed: {exc}") from exc

