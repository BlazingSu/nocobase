import requests
from typing import Any, Dict, List


class NocoAPI:
    """NocoBase HTTP API 的简易封装。"""

    def __init__(self, api_url: str, token: str):
        self.api_url = api_url.rstrip('/')
        self.token = token

    def _headers(self) -> Dict[str, str]:
        return {
            "Authorization": f"Bearer {self.token}",
            "Content-Type": "application/json",
        }

    def list_collections(self) -> List[Dict[str, Any]]:
        """返回所有集合。"""
        url = f"{self.api_url}/collections:list"
        try:
            response = requests.get(url, headers=self._headers())
            response.raise_for_status()
            return response.json().get("data", [])
        except requests.RequestException as exc:
            raise RuntimeError(f"Failed to list collections: {exc}") from exc

    def list_fields(self, collection_name: str) -> List[Dict[str, Any]]:
        """返回指定集合的全部字段。"""
        url = f"{self.api_url}/collections/{collection_name}/fields:list"
        try:
            response = requests.get(
                url,
                headers=self._headers(),
                params={"paginate": "false"},
            )
            response.raise_for_status()
            return response.json().get("data", [])
        except requests.RequestException as exc:
            raise RuntimeError(f"Failed to list fields: {exc}") from exc

    def list_records(self, collection_name: str) -> List[Dict[str, Any]]:
        """返回指定集合的全部记录。"""
        url = f"{self.api_url}/{collection_name}:list"
        try:
            response = requests.get(
                url,
                headers=self._headers(),
                params={"paginate": "false"},
            )
            response.raise_for_status()
            return response.json().get("data", [])
        except requests.RequestException as exc:
            raise RuntimeError(f"Failed to list records: {exc}") from exc

    def create_record(self, collection_name: str, data: Dict[str, Any]) -> Dict[str, Any]:
        """在指定集合中创建记录。

        参数
        ----------
        collection_name: str
            要插入的集合名称
        data: Dict[str, Any]
            创建的记录内容

        返回
        -------
        Dict[str, Any]
            API 返回的数据
        """
        url = f"{self.api_url}/{collection_name}:create"
        try:
            response = requests.post(url, json=data, headers=self._headers())
            response.raise_for_status()
            return response.json().get("data", {})
        except requests.RequestException as exc:
            raise RuntimeError(f"Failed to create record: {exc}") from exc

    def update_record(
        self, collection_name: str, record_id: str, data: Dict[str, Any]
    ) -> Dict[str, Any]:
        """更新指定集合中的记录。

        参数
        ----------
        collection_name: str
            需要更新的集合名称
        record_id: str
            要更新记录的标识
        data: Dict[str, Any]
            更新后的记录数据

        返回
        -------
        Dict[str, Any]
            API 返回的数据
        """
        url = f"{self.api_url}/{collection_name}:update"
        payload = {"filter": {"id": record_id}, "values": data}
        try:
            response = requests.post(url, json=payload, headers=self._headers())
            response.raise_for_status()
            return response.json().get("data", {})
        except requests.RequestException as exc:
            raise RuntimeError(f"Failed to update record: {exc}") from exc

    def upsert_record(
        self,
        collection_name: str,
        record_id: str | None,
        data: Dict[str, Any],
    ) -> Dict[str, Any]:
        """若传入 ``record_id`` 则更新记录，否则创建记录。

        当提供 ``record_id`` 时，方法会先尝试更新，若失败则退回到创建。"""
        if record_id:
            try:
                return self.update_record(collection_name, record_id, data)
            except RuntimeError:
                pass
        return self.create_record(collection_name, data)

