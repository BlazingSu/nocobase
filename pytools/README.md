# NocoBase Python 工具

该目录提供了一套使用 Python 调用 NocoBase REST API 的简单脚本，
可以根据 SQL 或 JSON 文件创建集合，并将 CSV 数据导入到指定集合中。
创建集合和字段时使用的是最新的接口路径，如 `collections:create`
和 `collections/<collection>/fields:create`。

## 使用方法

在命令行中直接运行模块（`--base-url` 末尾应包含 `/api`，如未提供会自
动补全）：

```bash
python -m nocobase_api --base-url http://localhost:13000/api \
    --username admin --password secret \
    --authenticator goout \
    --sql schema.sql \
    --json schema.json \
    --csv data.csv --collection posts \
    --debug
```

参数说明：

- `--base-url`：API 地址，例如 `http://localhost:13000/api`。若未以
  `/api` 结尾，脚本会自动补全。
- `--username`：登录用户名。
- `--password`：登录密码。
- `--authenticator`：登录方式标识，默认为 `basic`，根据后台配置选择
  `goout` 等值。
- `--sql`：包含 `CREATE TABLE` 语句的 SQL 文件，可根据其中定义创建集合。
- `--json`：包含集合定义的 JSON 文件，可批量创建集合及字段。
- `--csv`：要导入的 CSV 文件。
- `--collection`：CSV 数据要导入的集合名称。
- `--debug`：输出调试信息，便于排查脚本执行过程中的问题。
- `--refresh`：创建或导入完成后刷新数据源，使界面立刻反映最新结构，
  默认启用，可使用 `--no-refresh` 关闭。

在 JSON 文件中可以为字段设置诸如 `title`、`required`、`unique`、
`primaryKey` 等属性，脚本会原样传递这些配置以创建相应字段。
JSON 根节点既可以是集合数组，也可以包含 `tables` 或 `collections`
字段，脚本都会自动识别。
在执行命令时附加 `--debug` 参数即可看到完整的请求与响应，便于调试。
开启调试后，每创建一个字段都会立即请求并输出该集合当前的字段列表，
可快速验证字段是否真正保存成功。

根据需要选择参数：只创建集合时可提供 `--sql` 或 `--json`；仅导入数据时需要同时指定 `--csv` 与 `--collection`。

运行成功后脚本会依次创建集合并导入数据，方便在 NocoBase 中快速初始化测试数据。

完成数据表及字段的创建后，需要调用 `dataSources:refresh` 接口刷新数据源，
否则在 NocoBase UI 中可能无法立即看到新的集合或字段。命令行工具默认
会在操作结束后自动执行该步骤。

