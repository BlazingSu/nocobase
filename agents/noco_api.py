import requests
from typing import Any, Dict, List


class NocoAPI:
    """Minimal wrapper around NocoBase HTTP API."""

    def __init__(self, api_url: str, token: str):
        self.api_url = api_url.rstrip('/')
        self.token = token

    def _headers(self) -> Dict[str, str]:
        return {
            "Authorization": f"Bearer {self.token}",
            "Content-Type": "application/json",
        }

    def list_collections(self) -> List[Dict[str, Any]]:
        """Return all collections."""
        url = f"{self.api_url}/collections:list"
        try:
            response = requests.get(url, headers=self._headers())
            response.raise_for_status()
            return response.json().get("data", [])
        except requests.RequestException as exc:
            raise RuntimeError(f"Failed to list collections: {exc}") from exc

    def list_fields(self, collection_name: str) -> List[Dict[str, Any]]:
        """Return all fields for a given collection."""
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
        """Return all records for a given collection."""
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
        """Create a record in the specified collection.

        Parameters
        ----------
        collection_name: str
            Name of the collection to insert into.
        data: Dict[str, Any]
            Record data to create.

        Returns
        -------
        Dict[str, Any]
            Response data from the API.
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
        """Update a record in the specified collection.

        Parameters
        ----------
        collection_name: str
            Name of the collection to update.
        record_id: str
            Identifier of the record to update.
        data: Dict[str, Any]
            Updated record values.

        Returns
        -------
        Dict[str, Any]
            Response data from the API.
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
        """Update the record if ``record_id`` is provided, otherwise create it.

        When ``record_id`` is specified, the method attempts an update first and
        falls back to creation if the update fails.
        """
        if record_id:
            try:
                return self.update_record(collection_name, record_id, data)
            except RuntimeError:
                pass
        return self.create_record(collection_name, data)

