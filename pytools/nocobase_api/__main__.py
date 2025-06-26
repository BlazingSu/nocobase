import argparse
import logging
from .client import NocoBaseClient
from .bulk_tools import create_tables_from_sql, import_csv

"""NocoBase 命令行工具

该模块提供命令行接口，方便在终端中批量创建数据表并导入 CSV 数据。
"""


def main():
    """命令行入口函数"""
    parser = argparse.ArgumentParser(description="NocoBase API 工具")
    # 基础参数，指定接口地址和账号密码
    parser.add_argument("--base-url", required=True, help="API 地址，例如 http://localhost:13000/api")
    parser.add_argument("--username", required=True, help="登录用户名")
    parser.add_argument("--password", required=True, help="登录密码")
    parser.add_argument(
        "--authenticator",
        default="basic",
        help="登录方式标识，例如 basic/goout",
    )
    # 选项：指定 SQL 文件创建数据表
    parser.add_argument("--sql", help="包含建表语句的 SQL 文件")
    # 选项：导入 CSV 数据及对应集合名称
    parser.add_argument("--csv", help="要导入的 CSV 文件")
    parser.add_argument("--collection", help="CSV 数据对应的集合名称")
    parser.add_argument(
        "--debug",
        action="store_true",
        help="输出调试信息",
    )
    args = parser.parse_args()

    logging.basicConfig(
        level=logging.DEBUG if args.debug else logging.INFO,
        format="%(message)s",
    )

    logging.debug("Arguments: %s", vars(args))

    logging.info("Connecting to NocoBase at %s", args.base_url)

    client = NocoBaseClient(
        args.base_url, args.username, args.password, authenticator=args.authenticator
    )
    logging.debug("Client initialized")
    # 登录以获取 token
    client.sign_in()
    logging.info("Signed in successfully")

    if args.sql:
        # 根据 SQL 文件创建数据表
        logging.info("Creating collections from %s", args.sql)
        create_tables_from_sql(client, args.sql)

    if args.csv and args.collection:
        # 将 CSV 文件中的记录导入指定集合
        logging.info("Importing %s into %s", args.csv, args.collection)
        import_csv(client, args.collection, args.csv)


if __name__ == "__main__":
    main()

