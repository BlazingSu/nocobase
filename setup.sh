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

# 安装 Docker（简化方式）
if ! command -v docker &>/dev/null; then
  echo "🐳 安装 Docker..."
  sudo apt install -y docker.io
  sudo systemctl enable docker
  sudo systemctl start docker
else
  echo "✅ Docker 已安装: $(docker --version)"
fi

# 安装 docker-compose 到 $HOME/bin（绕过 noexec 问题）
echo "🔧 安装 docker-compose 到 ~/bin 目录..."
mkdir -p "$HOME/bin"

COMPOSE_URL="https://github.com/docker/compose/releases/download/v2.24.6/docker-compose-$(uname -s)-$(uname -m)"
curl -fsSL "$COMPOSE_URL" -o "$HOME/bin/docker-compose"
chmod +x "$HOME/bin/docker-compose"

# 添加到 PATH（若未配置）
if ! echo "$PATH" | grep -q "$HOME/bin"; then
  echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
  export PATH="$HOME/bin:$PATH"
  echo "📌 已将 ~/bin 添加到 PATH。请重启终端或执行： source ~/.bashrc"
fi

# 检查是否安装成功
if command -v docker-compose &>/dev/null; then
  echo "✅ docker-compose 安装成功: $(docker-compose --version)"
else
  echo "❌ docker-compose 安装失败，请手动检查 ~/bin/docker-compose 是否可执行"
fi

echo "✅ 所有依赖已安装完毕，你现在可以开始部署 NocoBase 了！"
