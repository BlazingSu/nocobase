[English](./README.md) | 简体中文 | [日本語](./README.ja-JP.md)
 
https://github.com/user-attachments/assets/ff1e4b3d-fc22-415d-a983-0c97ebc14096

<p align="center">
<a href="https://trendshift.io/repositories/4112" target="_blank"><img src="https://trendshift.io/api/badge/repositories/4112" alt="nocobase%2Fnocobase | Trendshift" style="width: 250px; height: 55px;" width="250" height="55"/></a>
<a href="https://www.producthunt.com/posts/nocobase?embed=true&utm_source=badge-top-post-topic-badge&utm_medium=badge&utm_souce=badge-nocobase" target="_blank"><img src="https://api.producthunt.com/widgets/embed-image/v1/top-post-topic-badge.svg?post_id=456520&theme=light&period=weekly&topic_id=267" alt="NocoBase - Scalability&#0045;first&#0044;&#0032;open&#0045;source&#0032;no&#0045;code&#0032;platform | Product Hunt" style="width: 250px; height: 54px;" width="250" height="54" /></a>
</p>

## NocoBase 是什么

NocoBase 是一个极易扩展的 AI 无代码开发平台。

完全掌控，无限扩展，AI 协同。  
让你的团队快速响应变化，大幅降低成本。  
无需多年研发，无需数百万投入。  
花几分钟部署 NocoBase，立即拥有一切。  



中文官网：  
https://www.nocobase.com/cn

在线体验：  
https://demo.nocobase.com/new

文档：  
https://docs-cn.nocobase.com/

社区：  
https://forum.nocobase.com/

用户故事：  
https://www.nocobase.com/cn/blog/tags/customer-stories

## 发布日志
我们的[博客](https://www.nocobase.com/cn/blog/timeline)会及时更新发布日志，并每周进行汇总。

## 与众不同之处

### 1. 数据模型 驱动，而非表单/表格驱动
NocoBase 采用 数据模型驱动 的方式，将数据结构与用户界面分离，突破了传统表单或表格驱动开发的限制，释放无限可能。

- 界面与数据结构彻底解耦
- 同一个表或记录可以创建任意数量、任意形式的区块和操作
- 支持主数据库、外部数据库以及第三方 API 作为数据源

![model](https://static-docs.nocobase.com/model.png)

### 2. AI 员工，融入你的业务系统
不同于停留在演示层面的 AI，NocoBase 让你能够将 AI 能力无缝集成到交互界面、业务流程和数据上下文中，让 AI 真正落地于企业场景。

- 定义 AI 员工，担任翻译员、分析员、调研员或助手等角色
- AI 与人工无缝协同于交互界面和业务流程
- 确保 AI 的使用符合企业的安全、透明和定制化需求

![AI-employee](https://static-docs.nocobase.com/ai-employee-home.png)

### 3. 所见即所得，极易上手
NocoBase 能够开发复杂而独特的业务系统，但使用体验却简单直观。

- 一键切换使用模式与配置模式
- 页面即画布，可随意拖拽区块和操作，像 Notion 一样搭建界面
- 配置模式面向普通用户设计，而非仅限程序员

![wysiwyg](https://static-docs.nocobase.com/wysiwyg.gif)

### 4. 一切皆 插件，为扩展而生
仅仅堆叠无代码功能，永远无法覆盖所有业务场景。NocoBase 基于 插件化微内核架构，为扩展而设计。

- 所有功能都是插件，类似于 WordPress
- 插件安装即用
- 页面、区块、操作、API、数据源等都可以通过插件扩展
  
![plugins](https://static-docs.nocobase.com/plugins.png)

## 安装

NocoBase 支持三种安装方式：

- <a target="_blank" href="https://docs-cn.nocobase.com/welcome/getting-started/installation/docker-compose">Docker 安装（推荐）</a>

   适合无代码场景，不需要写代码。升级时，下载最新镜像并重启即可。

- <a target="_blank" href="https://docs-cn.nocobase.com/welcome/getting-started/installation/create-nocobase-app">create-nocobase-app 安装</a>

   项目的业务代码完全独立，支持低代码开发。

- <a target="_blank" href="https://docs-cn.nocobase.com/welcome/getting-started/installation/git-clone">Git 源码安装</a>

   如果你想体验最新未发布版本，或者想参与贡献，需要在源码上进行修改、调试，建议选择这种安装方式，对开发技术水平要求较高，如果代码有更新，可以走 git 流程拉取最新代码。

## 一键部署

通过云厂商一键部署 NocoBase，并享受多种部署选项的灵活性：

- [阿里云](https://computenest.console.aliyun.com/service/instance/create/default?type=user&ServiceName=NocoBase%20%E7%A4%BE%E5%8C%BA%E7%89%88)
### 使用 main.py 示例

仓库根目录的 `main.py` 提供了导出模板和上传 CSV 数据的功能，适合快速批量处理数据。

1. 生成模板：
   ```bash
   python main.py template <集合名称> <输出文件> --include-data
   ```
   上述命令会创建包含现有字段（可选现有记录）的 CSV 文件。
2. 上传数据：
   ```bash
   python main.py upload <集合名称> <CSV 文件> --use-upsert
   ```
   读取本地 CSV 并写入集合，若文件中含有 `id` 列且使用 `--use-upsert`，会根据 `id` 更新或新增记录。

完整示例：
```bash
pip install requests
python main.py template posts posts.csv
# 编辑 posts.csv 后
python main.py upload posts posts.csv --use-upsert
```

### 批量上传图片

若需要一次性上传文件夹中的所有图片，可使用 `agents.image_uploader`
提供的 `upload_images_in_folder` 函数，并可配合 `download_files_csv`
导出文件管理器数据：

```python
from agents import config
from agents.auth import authenticate_user
from agents.noco_api import NocoAPI
from agents.image_uploader import upload_images_in_folder, download_files_csv

token = authenticate_user()
api = NocoAPI(config.API_URL, token)

# 上传文件夹中的所有图片到 attachments 集合
urls = upload_images_in_folder(config.API_URL, token, "attachments", "./images")

# 可选：将文件管理器中的数据保存为 CSV
download_files_csv(api, "attachments", "files.csv")
print(urls)
```
