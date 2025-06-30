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
        logging.debug("Request headers: %s", headers)
        try:
            with urllib.request.urlopen(req) as resp:
                status = resp.status
                resp_data = resp.read()
        except urllib.error.HTTPError as e:
            body = e.read().decode()
            logging.error("HTTP %s error for %s: %s", e.code, url, body)
            raise
        except urllib.error.URLError as e:
            logging.error("Failed to reach %s: %s", url, e.reason)
            raise
        logging.debug("Response status: %s", status)
        if resp_data:
            logging.debug("Response body: %s", resp_data.decode())
            return json.loads(resp_data.decode())
        return {}

    def sign_in(self) -> None:
        """登录并保存返回的 token"""
        payload = {"email": self.username, "password": self.password}
        response = self._request("POST", "auth:signIn", data=payload)
        token = response.get("data", {}).get("token")
        if not token:
            raise RuntimeError("Failed to obtain token")
        self.token = token

    def create_collection(
        self, name: str, template: str = "general", data_source_key: str | None = None
    ) -> dict:
        """创建集合（数据表）并在数据源中记录"""

        payload = {"name": name, "template": template}

        # 先在集合层面创建数据表
        resp = self._request("POST", "collections:create", data=payload)

        # 如指定了数据源，则同步写入 dataSourcesCollections
        if data_source_key:
            quoted_name = urllib.parse.quote(name, safe="")
            quoted_ds = urllib.parse.quote(data_source_key, safe="")
            path = f"dataSources/{quoted_ds}/collections:update?filterByTk={quoted_name}"
            try:
                self._request("POST", path, data=payload)
            except urllib.error.HTTPError:
                # 如果数据源中已存在该记录，忽略错误
                logging.debug("Collection %s already linked to data source %s", name, data_source_key)

        return resp

    def create_field(
        self,
        collection_name: str,
        field: dict,
        data_source_key: str | None = None,
    ) -> dict:
        """在指定集合中创建字段并写入数据源"""

        values = field.copy()

        # 先在集合层面创建字段，确保数据库结构存在
        path = f"collections/{collection_name}/fields:create"
        resp = self._request("POST", path, data=values)
        logging.debug("Field created response: %s", resp)

        # 如指定数据源，则额外写入 dataSourcesFields
        if data_source_key:
            quoted_ds = urllib.parse.quote(data_source_key, safe="")
            quoted_collection = urllib.parse.quote(collection_name, safe="")
            ds_path = f"dataSourcesCollections/{quoted_ds}.{quoted_collection}/fields:create"
            try:
                self._request("POST", ds_path, data=values)
            except urllib.error.HTTPError:
                logging.debug(
                    "Field %s already linked to data source %s", field.get("name"), data_source_key
                )

        return resp

    def list_fields(
        self, collection_name: str, data_source_key: str | None = None
    ) -> dict:
        """列出指定集合的字段"""

        if data_source_key:
            quoted_ds = urllib.parse.quote(data_source_key, safe="")
            quoted_collection = urllib.parse.quote(collection_name, safe="")
            path = (
                f"dataSourcesCollections/{quoted_ds}.{quoted_collection}/fields:list"
            )
        else:
            path = f"collections/{collection_name}/fields:list"

        return self._request("GET", path)

    def create_record(self, collection: str, values: dict) -> dict:
        """在指定集合中创建记录"""
        path = f"{collection}:create"
        return self._request("POST", path, data={"values": values})

    def refresh_data_source(self, key: str = "main") -> dict:
        """刷新指定数据源，使最新结构在界面中可见"""
        quoted = urllib.parse.quote(key, safe="")
        path = f"dataSources:refresh?filterByTk={quoted}"
        return self._request("POST", path)

