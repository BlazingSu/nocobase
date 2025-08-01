FROM node:20-bookworm-slim as builder

# 构建参数：NocoBase 脚手架版本和 Verdaccio 私有 npm registry 地址
ARG CNA_VERSION
ARG VERDACCIO_URL

WORKDIR /app

# 输出调试信息，验证环境变量传入成功
RUN echo "Using CNA_VERSION=${CNA_VERSION}"
RUN echo "Using VERDACCIO_URL=${VERDACCIO_URL}"

# 设置 yarn 超时，创建 NocoBase 应用并安装依赖
RUN cd /app \
  && yarn config set network-timeout 600000 -g \
  && npx -y create-nocobase-app@${CNA_VERSION} my-nocobase-app --skip-dev-dependencies -a -e APP_ENV=production \
  && cd /app/my-nocobase-app \
  && yarn config set registry "$VERDACCIO_URL" \
  && yarn install --production \
  && yarn release:force --registry "$VERDACCIO_URL" \
  && rm -rf yarn.lock \
  && find node_modules -type f -name "yarn.lock" -delete \
  && find node_modules -type f -name "bower.json" -delete \
  && find node_modules -type f -name "composer.json" -delete

# 打包 NocoBase 应用为 tar 文件
RUN cd /app \
  && rm -rf nocobase.tar.gz \
  && tar -zcf ./nocobase.tar.gz -C /app/my-nocobase-app .

# 第二阶段镜像（最终运行用）
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

# 清理默认 nginx 配置
RUN rm -rf /etc/nginx/sites-enabled/default

# 解压打包好的应用
COPY --from=builder /app/nocobase.tar.gz /app/nocobase.tar.gz

WORKDIR /app/nocobase

# 启动脚本
COPY docker-entrypoint.sh /app/

EXPOSE 80/tcp

CMD ["/app/docker-entrypoint.sh"]
