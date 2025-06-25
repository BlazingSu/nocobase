#!/bin/bash

set -e

echo "🚀 正在安装 NocoBase 所需依赖（适配 Ubuntu 24.04 LTS）..."

# 更新系统包
sudo apt update

# 安装 Python 及其依赖
if ! command -v python3 &>/dev/null; then
  echo "🐍 安装 Python3..."
  sudo apt install -y python3 python3-pip python3-venv python3-dev
else
  echo "✅ Python 已安装: $(python3 --version)"
fi

# 安装构建工具（某些 pip 包需要）
echo "🛠️ 安装构建工具..."
sudo apt install -y build-essential

# 安装 Yarn
if ! command -v yarn &>/dev/null; then
  echo "📦 安装 Yarn..."
  npm install -g yarn
else
  echo "✅ Yarn 已安装: $(yarn -v)"
fi

# 安装 PostgreSQL
if ! command -v psql &>/dev/null; then
  echo "📦 安装 PostgreSQL..."
  sudo apt install -y postgresql postgresql-contrib
else
  echo "✅ PostgreSQL 已安装"
fi

# 启动 PostgreSQL（兼容无 systemd 环境）
echo "⚙️ 尝试启动 PostgreSQL 服务..."
if command -v service &>/dev/null; then
  sudo service postgresql start || echo "⚠️ PostgreSQL 启动失败，请手动启动。"
else
  echo "⚠️ 无法使用 systemctl/service 启动 PostgreSQL，请确认环境或手动运行："
  echo "   /usr/lib/postgresql/16/bin/pg_ctl -D /var/lib/postgresql/16/main start"
fi

echo "✅ 所有依赖已安装完毕，你现在可以开始部署 NocoBase 了！"
