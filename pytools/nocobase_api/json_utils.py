import json
import logging
from typing import List, Dict, Any

"""JSON 辅助函数，用于解析集合定义"""


def parse_json_file(path: str) -> List[Dict[str, Any]]:
    """解析 JSON 文件，返回集合及字段信息"""
    logging.debug("Reading JSON file: %s", path)
    with open(path, "r", encoding="utf-8") as f:
        data = json.load(f)

    # 既支持以列表为根节点的格式，也兼容常见的 `tables` 或 `collections` 键
    tables: List[Dict[str, Any]]
    if isinstance(data, list):
        tables = data
    else:
        tables = data.get("tables") or data.get("collections") or []

    logging.debug("Tables loaded: %s", tables)
    return tables
