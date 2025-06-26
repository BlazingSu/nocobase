import json
import logging
import urllib.request
import urllib.parse
import urllib.error

"""NocoBase REST API 简易客户端"""


class NocoBaseClient:
    """与 NocoBase REST API 交互的简单客户端"""

    def __init__(self, base_url: str, username: str, password: str, authenticator: str = "basic"):
        """初始化客户端并保存认证信息"""
        self.base_url = base_url.rstrip('/')
        # 如果末尾未包含 /api，则自动补全，避免用户遗漏
        if not self.base_url.endswith('/api'):
            self.base_url += '/api'
        self.username = username
        self.password = password
        self.authenticator = authenticator
        self.token = None

    def _request(self, method: str, path: str, data: dict | None = None) -> dict:
        """内部请求方法，用于发送 HTTP 请求"""
        url = f"{self.base_url}/{path.lstrip('/')}"
        headers = {"Content-Type": "application/json"}
        # 登录方式标识，默认为 "basic"，可在实例化时传入
        if self.authenticator:
            headers["X-Authenticator"] = self.authenticator
        if self.token:
            headers["Authorization"] = f"Bearer {self.token}"  # 认证信息
        body = None
        if data is not None:
            body = json.dumps(data).encode()
        req = urllib.request.Request(url, data=body, headers=headers, method=method)
        logging.debug("%s %s", method, url)
        if data is not None:
            logging.debug("Payload: %s", data)
        try:
            with urllib.request.urlopen(req) as resp:
                resp_data = resp.read()
        except urllib.error.HTTPError as e:
            logging.error("HTTP %s error for %s: %s", e.code, url, e.read().decode())
            raise
        if not resp_data:
            return {}
        return json.loads(resp_data.decode())

    def sign_in(self) -> None:
        """登录并保存返回的 token"""
        payload = {"email": self.username, "password": self.password}
        response = self._request("POST", "auth:signIn", data=payload)
        token = response.get("data", {}).get("token")
        if not token:
            raise RuntimeError("Failed to obtain token")
        self.token = token

    def create_collection(self, name: str, fields: list[dict]) -> dict:
        """创建集合（数据表）"""
        values = {"name": name, "template": "general", "fields": fields}
        return self._request("POST", "collections:create", data={"values": values})

    def create_record(self, collection: str, values: dict) -> dict:
        """在指定集合中创建记录"""
        path = f"{collection}:create"
        return self._request("POST", path, data={"values": values})

