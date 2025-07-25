import ast
import csv
from typing import Any, Dict

from .noco_api import NocoAPI


def sanitize_row(row: Dict[str, Any], *, parse_lists: bool = True) -> Dict[str, Any]:
    """返回清理后的 CSV 行数据副本。

    空字符串会被替换为 ``None``。当 ``parse_lists`` 为 ``True`` 时，
    类似列表字面量的字符串会通过 :func:`ast.literal_eval` 转换为真正的列表。
    """

    sanitized: Dict[str, Any] = {}
    for key, value in row.items():
        if value == "":
            sanitized[key] = None
            continue

        if parse_lists and isinstance(value, str):
            text = value.strip()
            if text.startswith("[") and text.endswith("]"):
                try:
                    sanitized[key] = ast.literal_eval(text)
                    continue
                except (ValueError, SyntaxError):  # pragma: no cover - safety
                    pass

        sanitized[key] = value

    return sanitized


def upload_csv_data(
    csv_file_path: str,
    collection_name: str,
    api: NocoAPI,
    *,
    encoding: str = "utf-8",
    use_upsert: bool = False,
) -> None:
    """将 CSV 文件中的记录上传到 NocoBase 指定集合。

    参数
    ----------
    csv_file_path: str
        CSV 文件路径
    collection_name: str
        目标集合名称
    api: NocoAPI
        已认证的 API 客户端
    encoding: str, optional
        读取 ``csv_file_path`` 时使用的编码
    use_upsert: bool, optional
        当为 ``True`` 且 CSV 包含 ``id`` 列时，调用 :meth:`NocoAPI.upsert_record`，
        否则使用 :meth:`NocoAPI.create_record`
    """
    with open(csv_file_path, newline="", encoding=encoding) as csvfile:
        reader = csv.DictReader(csvfile)
        reader.fieldnames = [name.lower() for name in reader.fieldnames]
        for row in reader:
            sanitized = sanitize_row(row)
            if (
                use_upsert
                and any(k.lower() == "id" for k in row)
                and sanitized.get("id") is not None
            ):
                record_id = sanitized.pop("id")
                api.upsert_record(collection_name, record_id, sanitized)
            else:
                api.create_record(collection_name, sanitized)

