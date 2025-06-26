import csv
import logging
from .client import NocoBaseClient
from .sql_utils import parse_sql_file

"""批量操作工具函数

包含从 SQL 创建数据表和从 CSV 导入数据的实现。"""


def create_tables_from_sql(client: NocoBaseClient, sql_path: str):
    """根据 SQL 文件创建集合和字段"""
    tables = parse_sql_file(sql_path)
    for table in tables:
        # table 为解析后的结构，包括集合名称和字段列表
        logging.info("Creating collection %s", table["name"])
        client.create_collection(table["name"], table["fields"])


def import_csv(client: NocoBaseClient, collection: str, csv_path: str):
    """将 CSV 数据导入指定集合"""
    with open(csv_path, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            # 每一行作为字典传递给 API 创建记录
            logging.debug("Creating record: %s", row)
            client.create_record(collection, row)

