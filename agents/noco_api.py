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
            response = requests.get(url, headers=self._headers())
            response.raise_for_status()
            return response.json().get("data", [])
        except requests.RequestException as exc:
            raise RuntimeError(f"Failed to list fields: {exc}") from exc

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

