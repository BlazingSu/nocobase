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
        self,
        name: str,
        template: str = "general",
        data_source_key: str | None = None,
        **options,
    ) -> dict:
        """创建集合（数据表）并在数据源中记录"""

        payload = {"name": name, "template": template, **options}

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

    def set_fields(self, collection_name: str, fields: list[dict]) -> dict:
        """批量设置集合字段"""

        payload = {
            "filterByTk": collection_name,
            "values": {"fields": fields},
        }
        return self._request("POST", "collections:setFields", data=payload)

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

    # ------------------------------------------------------------------
    # Collection APIs

    def list_collections(self, params: dict | None = None) -> dict:
        """列出所有集合"""
        path = "collections:list"
        if params:
            path += "?" + urllib.parse.urlencode(params)
        return self._request("GET", path)

    def get_collection(self, name: str) -> dict:
        """获取单个集合信息"""
        quoted = urllib.parse.quote(name, safe="")
        path = f"collections:get?filterByTk={quoted}"
        return self._request("GET", path)

    def update_collection(self, name: str, values: dict) -> dict:
        """更新集合"""
        quoted = urllib.parse.quote(name, safe="")
        path = f"collections:update?filterByTk={quoted}"
        return self._request("POST", path, data=values)

    def destroy_collection(self, name: str) -> dict:
        """删除集合"""
        quoted = urllib.parse.quote(name, safe="")
        path = f"collections:destroy?filterByTk={quoted}"
        return self._request("POST", path)

    def move_collection(self, values: dict) -> dict:
        """移动集合的顺序"""
        return self._request("POST", "collections:move", data=values)

    def set_collection_fields(self, name: str, fields: list) -> dict:
        """批量设置集合字段"""
        quoted = urllib.parse.quote(name, safe="")
        path = f"collections:setFields?filterByTk={quoted}"
        return self._request("POST", path, data={"fields": fields})

    # ------------------------------------------------------------------
    # Collection field APIs

    def get_field(self, collection_name: str, name: str) -> dict:
        """获取指定字段信息"""
        quoted = urllib.parse.quote(name, safe="")
        path = f"collections/{collection_name}/fields:get?filterByTk={quoted}"
        return self._request("GET", path)

    def update_field(self, collection_name: str, name: str, values: dict) -> dict:
        """更新字段"""
        quoted = urllib.parse.quote(name, safe="")
        path = (
            f"collections/{collection_name}/fields:update?filterByTk={quoted}"
        )
        return self._request("POST", path, data=values)

    def destroy_field(self, collection_name: str, name: str) -> dict:
        """删除字段"""
        quoted = urllib.parse.quote(name, safe="")
        path = (
            f"collections/{collection_name}/fields:destroy?filterByTk={quoted}"
        )
        return self._request("POST", path)

    def move_field(self, collection_name: str, values: dict) -> dict:
        """移动字段顺序"""
        path = f"collections/{collection_name}/fields:move"
        return self._request("POST", path, data=values)

    # ------------------------------------------------------------------
    # Collection category APIs

    def list_collection_categories(self, params: dict | None = None) -> dict:
        """列出集合分类"""
        path = "collectionCategories:list"
        if params:
            path += "?" + urllib.parse.urlencode(params)
        return self._request("POST", path)

    def get_collection_category(self, key: str) -> dict:
        """获取集合分类"""
        quoted = urllib.parse.quote(key, safe="")
        path = f"collectionCategories:get?filterByTk={quoted}"
        return self._request("POST", path)

    def create_collection_category(self, values: dict) -> dict:
        """创建集合分类"""
        return self._request("POST", "collectionCategories:create", data=values)

    def update_collection_category(self, key: str, values: dict) -> dict:
        """更新集合分类"""
        quoted = urllib.parse.quote(key, safe="")
        path = f"collectionCategories:update?filterByTk={quoted}"
        return self._request("POST", path, data=values)

    def destroy_collection_category(self, key: str) -> dict:
        """删除集合分类"""
        quoted = urllib.parse.quote(key, safe="")
        path = f"collectionCategories:destroy?filterByTk={quoted}"
        return self._request("POST", path)

    def move_collection_category(self, values: dict) -> dict:
        """移动集合分类"""
        return self._request("POST", "collectionCategories:move", data=values)

    # ------------------------------------------------------------------
    # Database view APIs

    def get_db_view(self, name: str, schema: str | None = None) -> dict:
        """获取数据库视图字段"""
        params = {"filterByTk": name}
        if schema:
            params["schema"] = schema
        path = "dbViews:get?" + urllib.parse.urlencode(params)
        return self._request("GET", path)

    def list_db_views(self) -> dict:
        """列出未连接集合的数据库视图"""
        return self._request("GET", "dbViews:list")

    def query_db_view(
        self,
        name: str,
        schema: str | None = None,
        page: int | None = None,
        page_size: int | None = None,
    ) -> dict:
        """查询数据库视图数据"""
        params: dict[str, str | int] = {"filterByTk": name}
        if schema:
            params["schema"] = schema
        if page is not None:
            params["page"] = page
        if page_size is not None:
            params["pageSize"] = page_size
        path = "dbViews:query?" + urllib.parse.urlencode(params)
        return self._request("GET", path)

    # ------------------------------------------------------------------
    # Generic collection record APIs

    def list_records(self, collection: str, params: dict | None = None) -> dict:
        """列出集合记录"""
        path = f"{collection}:list"
        if params:
            path += "?" + urllib.parse.urlencode(params)
        return self._request("GET", path)

    def get_record(self, collection: str, key: str) -> dict:
        """获取单条记录"""
        quoted = urllib.parse.quote(key, safe="")
        path = f"{collection}:get?filterByTk={quoted}"
        return self._request("GET", path)

    def update_record(self, collection: str, key: str, values: dict) -> dict:
        """更新记录"""
        quoted = urllib.parse.quote(key, safe="")
        path = f"{collection}:update?filterByTk={quoted}"
        return self._request("POST", path, data={"values": values})

    def destroy_record(self, collection: str, key: str) -> dict:
        """删除记录"""
        quoted = urllib.parse.quote(key, safe="")
        path = f"{collection}:destroy?filterByTk={quoted}"
        return self._request("POST", path)

    def move_record(self, collection: str, values: dict) -> dict:
        """移动记录顺序"""
        path = f"{collection}:move"
        return self._request("POST", path, data=values)

    def export_records(self, collection: str, values: dict | None = None) -> dict:
        """导出记录"""
        path = f"{collection}:export"
        return self._request("POST", path, data=values or {})

    def import_xlsx(self, collection: str, values: dict) -> dict:
        """从 Excel 导入记录"""
        path = f"{collection}:importXlsx"
        return self._request("POST", path, data=values)

    def download_xlsx_template(self, collection: str, values: dict | None = None) -> dict:
        """下载导入模板"""
        path = f"{collection}:downloadXlsxTemplate"
        return self._request("POST", path, data=values or {})


    def create_record(self, collection: str, values: dict) -> dict:
        """在指定集合中创建记录"""
        path = f"{collection}:create"
        return self._request("POST", path, data={"values": values})

    def refresh_data_source(self, key: str = "main") -> dict:
        """刷新指定数据源，使最新结构在界面中可见"""
        quoted = urllib.parse.quote(key, safe="")
        path = f"dataSources:refresh?filterByTk={quoted}"
        return self._request("POST", path)

