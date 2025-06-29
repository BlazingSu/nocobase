import json
import logging
from typing import List, Dict, Any

"""JSON 辅助函数，用于解析集合定义"""


def parse_json_file(path: str) -> List[Dict[str, Any]]:
    """解析 JSON 文件，返回集合及字段信息"""
    logging.debug("Reading JSON file: %s", path)
    with open(path, "r", encoding="utf-8") as f:
        data = json.load(f)
    tables = data.get("tables", [])
    logging.debug("Tables loaded: %s", tables)
    return tables
