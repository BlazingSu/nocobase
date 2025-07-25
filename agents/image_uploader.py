import os
import requests


def upload_image(api_url: str, token: str, file_collection: str, file_path: str) -> str:
    """上传图片到 NocoBase 并返回其 URL。

    参数
    ----------
    api_url: str
        API 基础地址
    token: str
        认证 Token
    file_collection: str
        文件集合名称，如 'attachments'
    file_path: str
        要上传的本地图片路径
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

