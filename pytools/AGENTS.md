官方开发文档地址：
```
./nocobase_doc/AGENTS.md
```
官方API文档地址：
```
./nocobase_api/AGENTS.md
```
根据你的新增需求和提供的表格字段信息，我将重新编写一份详细的 `AGENTS.md` 文件。此文件包含代理的职责、所需操作、文件结构、编码规范、测试、验证方法及与代理的沟通方式。具体步骤如下：

---

# AGENTS.md

## 1. 代理概述

### 代理职责

此代理负责以下任务：
* **处理身份验证**：将身份验证所需的信息直接写入代码，不需要在命令中写明，
*   API地址：http://erp.vdnet.top:13000/api
*   用户名：admin@nocobase.com
*   密码：qaz123456@ products
*   authenticator：basic
*   上传的文件地址以及下载CSV文件地址：C:\Users\Administrator\Desktop\
* **导出表格数据结构为CSV文件**：通过获取NocoBase中的各个表格（collections）和字段（fields）以及字段记录，将其导出为CSV文件，便于人工填写数据。
* **插入记录数据**：在填写好CSV记录后，上传数据，通过API解析，判断应该更新数据还是插入数据，如果字段id有值，则更新对应表格中对应id值的记录；如果id没有值，则将记录插入到NocoBase数据库中的对应表格。
* **上传图片并关联**：上传文件夹中所有图片并返回文件管理器中所有的文件相关数据存入到一个CSV文件中，确保数据上传和解析时能够正常处理图片。

### 数据结构与字段

根据提供的数据结构，NocoBase中存在多个表格（collections）及其字段（fields），我们需要：
* **获取所有表格**：使用NocoBase API接口获取所有表格的数据结构。
* **获取每个表格的字段信息**：对于每个表格，获取它的字段信息，以便生成对应的CSV文件。
* **上传数据**：生成的CSV文件需要通过API上传并解析，填充到对应的表格中，如果CSV文件中id字段有值，则需要启动Update数据API，对数据进行更新处理；如果CSV文件中id字段没有值，则启动Create数据API，对数据进行新建处理。

### 需要使用的API

请查询文件地址：/nocobase_api/AGENTS.md

## 2. 文件和文件夹结构

以下是相关文件和文件夹的结构：

```
/project-root/
    /agents/
        /file_upload/
            image_uploader.py      # 上传文件夹中所有图片并生成文件数据管理器中所有文件的相关信息CSV
        /data_processing/
            csv_generator.py       # 生成CSV文件并插入URL
            data_uploader.py       # 将CSV数据上传到NocoBase
        auth.py                    # 负责身份验证的逻辑
        noco_api.py                # 与NocoBase API交互的接口
    /tests/
        test_auth.py               # 身份验证测试
        test_noco_api.py           # 测试与NocoBase API交互的代码
        test_csv_generator.py      # 测试CSV生成和URL插入
        test_image_uploader.py     # 测试图片上传
        test_data_uploader.py      # 测试CSV数据上传
    main.py
```

## 3. 编码规范

### 一般规则

* 使用PEP 8 编码规范，确保代码的可读性和一致性。
* 使用有意义的函数和变量名，避免使用单个字母（除非在简单迭代中，如 `i` 或 `x`）。
* 所有的函数和类都应该有适当的文档字符串（docstrings），以便于理解其功能，docstring使用中文。
* 必要的位置添加好调试代码，调试代码最终输出为中文
* 
### 函数和变量命名

* 函数名使用小写字母和下划线命名方式（例如 `authenticate_user()`）。
* 变量名应简洁且具有描述性（例如 `auth_token`, `csv_file_path`）。

### 错误处理

* 使用 `try-except` 语句进行异常处理。
* 错误信息应详细并具备调试信息，确保日志清晰明了。

```python
try:
    response = requests.post(AUTH_URL, json={"username": username, "password": password})
    response.raise_for_status()  # 检查请求是否成功
except requests.exceptions.RequestException as e:
    print(f"Request failed: {e}")
    raise  # 重新抛出异常以便上层调用捕获
```

## 4. 处理流程

### 任务1: 导出表格数据结构为CSV

1. 获取NocoBase中所有表格（collections）的数据结构。
2. 获取每个表格的字段信息（fields）。
3. 将表格字段写入CSV文件（以表格字段作为CSV表头）。

### 任务2: 处理上传记录

1. 用户填写CSV文件中的记录数据。
2. 使用API接口将CSV数据上传到NocoBase。
3. API解析数据并将记录插入对应的数据库表格中。

### 任务3: 上传图片

1. 上传一个文件夹中的图片到NocoBase，文件夹地址可以由用户指定。
2. 通过API，获取文件管理器中所有的文件数据，并下载到一个新的CSV，文件管理器的在服务器中地址：storage/uploads/

## 5. 验证和测试

### 验证步骤

* **CSV生成验证**：检查CSV表格的生成，确保表格的字段和数据结构正确。
* **数据上传验证**：测试上传数据到NocoBase的过程，确保数据能够正确插入数据库。
* **图片上传验证**：测试上传图片，获取文件管理器中所有的文件数据，确保CSV文件中有该图片的所有数据

### 测试

* 所有功能都需要进行单元测试，包括：

  * **身份验证测试**：验证身份验证的有效性和错误处理。
  * **API接口测试**：确保与NocoBase API的交互正常，能够成功获取数据结构、上传图片并插入记录。
  * **CSV生成测试**：确保CSV文件按预期生成。
  * **数据上传测试**：确保从CSV上传的数据能够成功插入到NocoBase的对应表格中，确保CSV上传的数据能够成功的更新到对应表格对应id的记录中。

可以使用 `pytest` 来编写和运行测试：

```bash
$ pytest tests/test_noco_api.py
```

## 6. 与代理的沟通方式

### 变更管理

* 所有的代码变更都应通过 **Git** 提交。
* 每个提交必须有详细的说明，说明变更的目的和影响。
* 所有变更应先经过开发环境测试，确认没有破坏现有功能后再进行合并。

### 代码审查

* 所有新的功能或改动都必须经过代码审查。团队成员应评审代码，确保代码质量并减少bug。







