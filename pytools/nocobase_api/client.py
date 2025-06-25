import json
import urllib.request
import urllib.parse


class NocoBaseClient:
    """Simple client for interacting with the NocoBase REST API."""

    def __init__(self, base_url: str, username: str, password: str, authenticator: str = "password"):
        self.base_url = base_url.rstrip('/')
        self.username = username
        self.password = password
        self.authenticator = authenticator
        self.token = None

    def _request(self, method: str, path: str, data: dict | None = None) -> dict:
        url = f"{self.base_url}/{path.lstrip('/')}"
        headers = {"Content-Type": "application/json"}
        if self.token:
            headers["Authorization"] = f"Bearer {self.token}"
        body = None
        if data is not None:
            body = json.dumps(data).encode()
        req = urllib.request.Request(url, data=body, headers=headers, method=method)
        with urllib.request.urlopen(req) as resp:
            resp_data = resp.read()
            if not resp_data:
                return {}
            return json.loads(resp_data.decode())

    def sign_in(self) -> None:
        payload = {"email": self.username, "password": self.password}
        response = self._request("POST", "auth:signIn", data=payload)
        token = response.get("data", {}).get("token")
        if not token:
            raise RuntimeError("Failed to obtain token")
        self.token = token

    def create_collection(self, name: str, fields: list[dict]) -> dict:
        values = {"name": name, "template": "general", "fields": fields}
        return self._request("POST", "collections:create", data={"values": values})

    def create_record(self, collection: str, values: dict) -> dict:
        path = f"{collection}:create"
        return self._request("POST", path, data={"values": values})

