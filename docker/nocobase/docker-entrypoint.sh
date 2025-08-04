#!/bin/sh
set -e

echo "COMMIT_HASH: $(cat /app/commit_hash.txt 2>/dev/null || echo 'unknown')"

export NOCOBASE_RUNNING_IN_DOCKER=true

# 解压 LibreOffice
if [ -f /opt/libreoffice24.8.zip ] && [ ! -d /opt/libreoffice24.8 ]; then
  echo "Unzipping /opt/libreoffice24.8.zip..."
  unzip /opt/libreoffice24.8.zip -d /opt/
fi

# 解压 Oracle Instant Client
if [ -f /opt/instantclient_19_25.zip ] && [ ! -d /opt/instantclient_19_25 ]; then
  echo "Unzipping /opt/instantclient_19_25.zip..."
  unzip /opt/instantclient_19_25.zip -d /opt/
  echo "/opt/instantclient_19_25" > /etc/ld.so.conf.d/oracle-instantclient.conf
  ldconfig
fi

# 创建 NocoBase 目录
if [ ! -d "/app/nocobase" ]; then
  mkdir nocobase
fi

# 解压 tar 包
if [ ! -f "/app/nocobase/package.json" ]; then
  echo 'Copying NocoBase app...'
  tar -zxf /app/nocobase.tar.gz --absolute-names -C /app/nocobase
  touch /app/nocobase/node_modules/@nocobase/app/dist/client/index.html
fi

# 初始化配置
cd /app/nocobase && yarn nocobase create-nginx-conf
cd /app/nocobase && yarn nocobase generate-instance-id
rm -rf /etc/nginx/sites-enabled/nocobase.conf
ln -s /app/nocobase/storage/nocobase.conf /etc/nginx/sites-enabled/nocobase.conf

# ⬇️ 加入发布步骤
cd /app/nocobase
echo "Running yarn release:force..."
yarn release:force --registry $VERDACCIO_URL || echo "⚠️ yarn release 失败，跳过..."

# 启动 nginx
nginx
echo 'nginx started';

# 执行自定义脚本（可选）
if [ -d "/app/nocobase/storage/scripts" ]; then
  for f in /app/nocobase/storage/scripts/*.sh; do
    echo "Running $f"
    sh "$f"
  done
fi

# 启动 NocoBase 服务
cd /app/nocobase && yarn start --quickstart

# 可选命令转发
if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ] || { [ -f "${1}" ] && ! [ -x "${1}" ]; }; then
  set -- node "$@"
fi

exec "$@"
