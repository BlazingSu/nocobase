import csv
import logging
from .client import NocoBaseClient
from .sql_utils import parse_sql_file
from .json_utils import parse_json_file

"""批量操作工具函数

包含从 SQL 创建数据表和从 CSV 导入数据的实现。"""


def create_tables_from_sql(
    client: NocoBaseClient, sql_path: str, data_source_key: str = "main"
):
    """根据 SQL 文件创建集合和字段"""
    logging.debug("Parsing SQL file %s", sql_path)
    tables = parse_sql_file(sql_path)
    logging.debug("Tables to create: %s", tables)
    for table in tables:
        # table 为解析后的结构，包括集合名称和字段列表
        logging.info("Creating collection %s", table["name"])
        client.create_collection(table["name"], data_source_key=data_source_key)

        # 使用 create_field 逐个创建字段，确保写入 dataSourcesFields
        for field in table["fields"]:
            client.create_field(
                table["name"], field, data_source_key=data_source_key
            )

        fields_after = client.list_fields(
            table["name"], data_source_key=data_source_key
        )
        logging.debug(
            "Fields of %s after creation: %s", table["name"], fields_after
        )

    client.refresh_data_source(data_source_key)


def import_csv(client: NocoBaseClient, collection: str, csv_path: str):
    """将 CSV 数据导入指定集合"""
    logging.debug("Importing CSV %s into %s", csv_path, collection)
    with open(csv_path, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            # 每一行作为字典传递给 API 创建记录
            logging.debug("Creating record: %s", row)
            client.create_record(collection, row)



def create_tables_from_json(
    client: NocoBaseClient, json_path: str, data_source_key: str = "main"
):
    """根据 JSON 文件创建集合和字段"""
    logging.debug("Parsing JSON file %s", json_path)
    tables = parse_json_file(json_path)
    logging.debug("Tables to create: %s", tables)

    for table in tables:
        collection_name = table.get("name")
        logging.info("Creating collection %s", collection_name)
        resp = client.create_collection(
            collection_name, data_source_key=data_source_key
        )
        logging.debug("Collection response: %s", resp)
        if table.get("fields"):
            for field in table["fields"]:
                client.create_field(
                    collection_name, field, data_source_key=data_source_key
                )
            fields_after = client.list_fields(
                collection_name, data_source_key=data_source_key
            )
            logging.debug(
                "Fields of %s after creation: %s", collection_name, fields_after
            )

    client.refresh_data_source(data_source_key)
