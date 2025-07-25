import os
from typing import List
import requests

from . import csv_generator
from .noco_api import NocoAPI


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


def upload_images_in_folder(
    api_url: str,
    token: str,
    file_collection: str,
    folder_path: str,
) -> List[str]:
    """上传指定文件夹下的所有图片并返回 URL 列表。"""

    urls: List[str] = []
    for name in os.listdir(folder_path):
        file_path = os.path.join(folder_path, name)
        if os.path.isfile(file_path):
            url = upload_image(api_url, token, file_collection, file_path)
            urls.append(url)
    return urls


def download_files_csv(
    api: NocoAPI, file_collection: str, csv_file_path: str
) -> None:
    """获取文件管理器数据并写入 CSV 文件。"""

    fields = api.list_fields(file_collection)
    field_names = [f["name"] for f in fields]
    records = api.list_records(file_collection)
    csv_generator.generate_csv(csv_file_path, field_names, records)

