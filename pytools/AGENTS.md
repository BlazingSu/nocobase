官方开发文档地址：
```
./nocobase_doc/AGENTS.md
```
官方API文档地址：
```
./nocobase_api/AGENTS.md
```

为了帮助你编写适用于此Python脚本的 `AGENTS.md` 文件，我们需要定义以下内容：

1. **代理的职责**：此代理将负责身份验证、获取数据结构、上传图片以及生成和管理CSV文件。
2. **文件结构**：哪些文件和文件夹与代理的工作相关。
3. **编码规范**：编写清晰、结构化的代码，包括命名规范和注释。
4. **验证和测试**：如何验证更改，进行单元测试和集成测试。
5. **与代理的沟通方式**：如何确保代理可以协同工作并提供更新。

以下是针对你的需求而编写的 `AGENTS.md` 文件的一个示例：

---

# AGENTS.md

## 1. 代理概述

### 代理职责

此代理负责以下任务：

* 完成用户身份验证。
* 获取NocoBase主数据源中各个表格的数据结构，并根据数据结构生成CSV文件。
* 上传图片到NocoBase，并返回对应的图片URL。
* 根据数据结构生成的CSV文件，可以手动或自动插入上传的图片URL。

### 工作文件

以下文件和文件夹与代理的工作相关：

* **`auth.py`**: 处理身份验证逻辑。
* **`noco_api.py`**: 包含调用NocoBase API的函数。
* **`csv_generator.py`**: 生成CSV文件并插入图片URL的功能。
* **`image_uploader.py`**: 上传图片并返回图片URL的函数。

## 2. 编码规范

### 一般规则

* 使用PEP 8 编码规范，确保代码的可读性和一致性。
* 使用有意义的函数和变量名，避免使用单个字母（除非在简单迭代中，如 `i` 或 `x`）。
* 所有的函数和类都应该有适当的文档字符串（docstrings），以便于理解其功能。

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

## 3. 文件和文件夹结构

以下是相关文件和文件夹的结构：

```
/project-root/
    /agents/
        auth.py                # 负责身份验证的逻辑
        noco_api.py            # 与NocoBase API交互的接口
        csv_generator.py       # 生成CSV文件并插入URL
        image_uploader.py      # 上传图片并返回URL
    /tests/
        test_auth.py           # 身份验证测试
        test_noco_api.py       # 测试与NocoBase API交互的代码
        test_csv_generator.py  # 测试CSV生成和URL插入
        test_image_uploader.py # 测试图片上传
```

## 4. 验证和测试

### 验证步骤

* **身份验证**：确保使用提供的用户名和密码正确地获取认证令牌。
* **数据结构提取**：验证从NocoBase API获取的数据结构与预期一致。
* **CSV生成**：检查生成的CSV文件，确保表头符合NocoBase数据库的字段结构。
* **图片上传**：确保上传图片后返回的URL是有效的，并且可以在CSV文件中正确插入。

### 测试

* 所有功能都需要进行单元测试，包括：

  * **身份验证测试**：验证身份验证的有效性和错误处理。
  * **API接口测试**：确保与NocoBase API的交互正常，能够成功获取数据结构和上传图片。
  * **CSV生成测试**：确保CSV文件按预期生成，并能正确插入图片URL。

可以使用 `pytest` 来编写和运行测试：

```bash
$ pytest tests/test_noco_api.py
```

## 5. 与代理的沟通方式

### 变更管理

* 所有的代码变更都应通过 **Git** 提交。
* 每个提交必须有详细的说明，说明变更的目的和影响。
* 所有变更应先经过开发环境测试，确认没有破坏现有功能后再进行合并。

### 代码审查

* 所有新的功能或改动都必须经过代码审查。团队成员应评审代码，确保代码质量并减少bug。






