# NocoBase Python 工具

该目录提供了一套使用 Python 调用 NocoBase REST API 的简单脚本，
可以根据 SQL 文件创建集合，并将 CSV 数据导入到指定集合中。

## 使用方法

在命令行中直接运行模块：

```bash
python -m nocobase_api --base-url http://localhost:13000/api \
    --username admin --password secret \
    --sql schema.sql \
    --csv data.csv --collection posts
```

参数说明：

- `--base-url`：API 地址，例如 `http://localhost:13000/api`。
- `--username`：登录用户名。
- `--password`：登录密码。
- `--sql`：包含 `CREATE TABLE` 语句的 SQL 文件，可根据其中定义创建集合。
- `--csv`：要导入的 CSV 文件。
- `--collection`：CSV 数据要导入的集合名称。

根据需要选择参数：只创建集合时只需提供 `--sql`；仅导入数据时需要同时指定 `--csv` 与 `--collection`。

运行成功后脚本会依次创建集合并导入数据，方便在 NocoBase 中快速初始化测试数据。

