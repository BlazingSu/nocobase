import os
import requests


def upload_image(api_url: str, token: str, file_collection: str, file_path: str) -> str:
    """Upload an image to NocoBase and return its URL.

    Parameters
    ----------
    api_url: str
        Base API URL.
    token: str
        Authentication token.
    file_collection: str
        Collection name for files (e.g., 'attachments').
    file_path: str
        Local path to the image to upload.
    """
    url = f"{api_url}/{file_collection}:create"
    headers = {"Authorization": f"Bearer {token}"}

    with open(file_path, "rb") as file_obj:
        files = {"file": (os.path.basename(file_path), file_obj)}
        try:
            response = requests.post(url, headers=headers, files=files)
            response.raise_for_status()
            return response.json()["data"]["url"]
        except (requests.RequestException, KeyError) as exc:
            raise RuntimeError(f"Image upload failed: {exc}") from exc

