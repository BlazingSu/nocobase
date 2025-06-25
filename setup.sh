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

# 安装构建工具
echo "🛠️ 安装构建工具..."
sudo apt install -y build-essential

# 安装 Node.js 和 npm（使用 apt 安装默认版本）
if ! command -v node &>/dev/null; then
  echo "📦 安装 Node.js 和 npm..."
  sudo apt install -y nodejs npm
else
  echo "✅ Node.js 已安装: $(node -v)"
fi

# 安装 Yarn
if ! command -v yarn &>/dev/null; then
  echo "📦 安装 Yarn..."
  npm install -g yarn
else
  echo "✅ Yarn 已安装: $(yarn -v)"
fi

# 安装 PostgreSQL
if ! command -v psql &>/dev/null; then
  echo "🐘 安装 PostgreSQL..."
  sudo apt install -y postgresql postgresql-contrib
else
  echo "✅ PostgreSQL 已安装"
fi

# 启动 PostgreSQL
echo "⚙️ 尝试启动 PostgreSQL 服务..."
if command -v service &>/dev/null; then
  sudo service postgresql start || echo "⚠️ PostgreSQL 启动失败，请手动启动。"
else
  echo "⚠️ 无法使用 systemctl/service 启动 PostgreSQL，请确认环境或手动运行："
  echo "   /usr/lib/postgresql/16/bin/pg_ctl -D /var/lib/postgresql/16/main start"
fi

# 安装 Docker
if ! command -v docker &>/dev/null; then
  echo "🐳 安装 Docker..."
  sudo apt install -y docker.io
  sudo systemctl enable docker
  sudo systemctl start docker
else
  echo "✅ Docker 已安装: $(docker --version)"
fi

# 安装 Docker Compose 插件
if ! docker compose version &>/dev/null; then
  echo "📦 安装 Docker Compose 插件..."
  sudo apt install -y docker-compose-plugin
fi

# 验证 Docker Compose
if docker compose version &>/dev/null; then
  echo "✅ Docker Compose 已安装: $(docker compose version)"
else
  echo "❌ Docker Compose 安装失败，请检查日志"
fi

echo "✅ 所有依赖已安装完毕，你现在可以开始部署 NocoBase 了，！"
