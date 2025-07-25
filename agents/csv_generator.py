import csv
from typing import Any, Dict, Iterable, List, Optional

from .noco_api import NocoAPI


def generate_csv(
    csv_file_path: str,
    field_names: List[str],
    records: Iterable[Dict[str, Any]],
    image_field: Optional[str] = None,
    image_url: Optional[str] = None,
) -> None:
    """根据记录生成 CSV 文件。

    参数
    ----------
    csv_file_path: str
        输出 CSV 文件的路径
    field_names: List[str]
        字段名称列表（列头）
    records: Iterable[Dict[str, Any]]
        记录字典的可迭代对象
    image_field: Optional[str]
        用于放置图片链接的字段名
    image_url: Optional[str]
        当提供 ``image_field`` 时，插入到每条记录的图片地址
    """
    with open(csv_file_path, "w", newline="", encoding="utf-8") as csvfile:
        writer = csv.DictWriter(
            csvfile, fieldnames=field_names, extrasaction="ignore"
        )
        writer.writeheader()
        for record in records:
            row = {key: record.get(key) for key in field_names}
            if image_field and image_url:
                row[image_field] = image_url
            writer.writerow(row)


def generate_template(
    csv_file_path: str,
    collection_name: str,
    api: NocoAPI,
    *,
    include_data: bool = False,
) -> None:
    """为指定集合生成 CSV 模板。

    参数
    ----------
    csv_file_path: str
        模板 CSV 的输出路径
    collection_name: str
        要读取字段信息的集合名称
    api: NocoAPI
        已认证的 API 客户端
    include_data: bool, optional
        如果为 ``True``，模板中会包含现有记录
    """
    fields = api.list_fields(collection_name)

    relation_interfaces = {
        "o2o",
        "oho",
        "obo",
        "o2m",
        "m2o",
        "m2m",
        "linkTo",
        "mbm",
        "subTable",
    }
    relation_types = {
        "belongsTo",
        "hasOne",
        "hasMany",
        "belongsToMany",
        "linkTo",
    }

    field_names = [
        f["name"]
        for f in fields
        if f.get("interface") not in relation_interfaces
        and f.get("type") not in relation_types
        and f.get("interface") != "formula"
        and f.get("type") != "formula"
    ]

    records: Iterable[Dict[str, Any]] = []
    if include_data:
        records = api.list_records(collection_name)
    generate_csv(csv_file_path, field_names, records)

