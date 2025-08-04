# ----------- 构建阶段 ------------
FROM node:20-bookworm-slim as builder

# 构建参数：NocoBase 脚手架版本 和 私有 npm 仓库 URL
ARG CNA_VERSION
ARG VERDACCIO_URL

# 工作目录
WORKDIR /app

# 输出调试信息
RUN echo "Using CNA_VERSION=${CNA_VERSION}"
RUN echo "Using VERDACCIO_URL=${VERDACCIO_URL}"

# 安装依赖并构建 NocoBase 应用
RUN cd /app \
  && yarn config set network-timeout 600000 -g \
  && npx -y create-nocobase-app@${CNA_VERSION} my-nocobase-app --skip-dev-dependencies -a -e APP_ENV=production \
  && cd /app/my-nocobase-app \
  && yarn config set registry "$VERDACCIO_URL" \
  && yarn install --production \
  # ⚠️ 发布操作放在运行时执行，避免构建时失败
  # && yarn release:force --registry "$VERDACCIO_URL" \
  && rm -rf yarn.lock \
  && find node_modules -type f -name "yarn.lock" -delete \
  && find node_modules -type f -name "bower.json" -delete \
  && find node_modules -type f -name "composer.json" -delete

# 打包 NocoBase 应用为 tar 包
RUN cd /app \
  && rm -rf nocobase.tar.gz \
  && tar -zcf ./nocobase.tar.gz -C /app/my-nocobase-app .

# ----------- 运行阶段 ------------
FROM node:20-bookworm-slim

# 安装运行时依赖
RUN ARCH= && dpkgArch="$(dpkg --print-architecture)" \
  && case "${dpkgArch##*-}" in \
  amd64) ARCH='x64';; \
  ppc64el) ARCH='ppc64le';; \
  s390x) ARCH='s390x';; \
  arm64) ARCH='arm64';; \
  armhf) ARCH='armv7l';; \
  i386) ARCH='x86';; \
  *) echo "unsupported architecture"; exit 1 ;; \
  esac \
  && set -ex \
  && apt-get update && apt-get install -y nginx libaio1

# 清除默认 nginx 配置
RUN rm -rf /etc/nginx/sites-enabled/default

# 解压 tar 包到工作目录
COPY --from=builder /app/nocobase.tar.gz /app/nocobase.tar.gz

WORKDIR /app/nocobase

# 解压 tar 包
RUN tar -zxf /app/nocobase.tar.gz -C .

# 复制启动脚本
COPY docker-entrypoint.sh /app/

# 暴露 Web 端口
EXPOSE 80/tcp

# 启动服务（通过 docker-entrypoint.sh）
CMD ["/app/docker-entrypoint.sh"]
