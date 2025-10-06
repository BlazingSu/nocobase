# Traefik + DNSPod 自动化部署指引

> 目标：使用 docker/app-postgres/docker-compose.yml 部署 NocoBase，并通过 Traefik v2 + DNSPod 自动申请 / 续期 Let’s Encrypt 证书，完成 `https://lwwl.cc` 访问。

## 前置信息
- 域名：`lwwl.cc`，注册商 NameSilo，DNS 托管在腾讯云 DNSPod。
- 必备凭据：DNSPod `login_token`（格式 `ID,Token`），Domain ID `98342086`，一个可公开访问的服务器 IPv4。
- Traefik 将通过 DNS-01 Challenge 申请 `lwwl.cc` 与 `*.lwwl.cc` 通配符证书，证书文件存储在 `docker/app-postgres/traefik/acme.json`。

## 环境变量准备
在项目根目录创建 / 更新 `.env`（或使用 `.env.example` 作为模板），至少配置以下变量：

```
TRAEFIK_DOMAIN=lwwl.cc
TRAEFIK_ACME_EMAIL=your-admin@lwwl.cc
TRAEFIK_DNSPOD_API_KEY=<ID,Token>
TRAEFIK_DNSPOD_DOMAIN_ID=98342086
TRAEFIK_TARGET_IP=<服务器公网 IP>
TRAEFIK_DASHBOARD_DOMAIN=dashboard.lwwl.cc               # 可选
# TRAEFIK_API_AUTH=Basic <Base64 编码凭据>              # 若开启 Traefik API 认证
# TRAEFIK_API_URL=http://traefik:8080/api/providers/reload # 默认即可
```

> 提示：`TRAEFIK_DNSPOD_API_KEY` 与 `acme.json` 含有敏感数据，应使用操作系统密钥管理或 CI Secret 存储；仓库中已将 `traefik/acme.json` 忽略。

## 初始化 Traefik 资料
1. 复制模板并设置适当权限：
   ```bash
   cp docker/app-postgres/traefik/acme.json.template docker/app-postgres/traefik/acme.json
   chmod 600 docker/app-postgres/traefik/acme.json        # Windows 可用 icacls 设置
   ```
2. 若需要访问 Traefik Dashboard，可在 DNS 中为 `dashboard.lwwl.cc` 创建 A 记录指向服务器。

## 启动 docker-compose
```bash
docker compose -f docker/app-postgres/docker-compose.yml up -d traefik postgres app
```
- `traefik`：监听 80/443，自动将 HTTP 重定向至 HTTPS。
- `app`：通过 Traefik 暴露在 `websecure` 入口；原本的 13000 端口不再直接对外开放。

初次启动后，访问 `https://lwwl.cc` 会触发 Traefik 自动申请证书；如需提前校验 DNS，可运行下方脚本。

## 使用脚本同步 DNSPod 记录
脚本位于 `scripts/traefik/dnspod-sync.mjs`，依赖 Node.js ≥ 18（无需额外包）：

```bash
node scripts/traefik/dnspod-sync.mjs \
  --domain lwwl.cc \
  --token <ID,Token> \
  --ip <服务器公网 IP> \
  --subdomains @,*,www
```

功能：
- `Record.List` → 判断现有 A 记录是否指向目标 IP。
- 若缺失或不一致，自动调用 `Record.Create` / `Record.Modify` 更新。
- 完成后调用 Traefik `providers/reload` 触发动态配置刷新（可用 `--skip-reload` 跳过）。

其他可用参数：
- `--dry-run`：仅输出计划动作，不写入 DNS。
- `--ttl 600`：自定义 TTL。
- `--traefik-reload-auth "Bearer <token>"`：为 Traefik API 增加认证头。

建议把该脚本放入 crontab（或 Windows 任务计划）每日运行一次，保障 DNS 记录与证书策略一致。

## 验证步骤
1. `docker compose logs -f traefik`，确认 `Successfully added certificate to certificate store` 日志。
2. 浏览器或 `curl -I https://lwwl.cc`，核对证书颁发机构为 Let’s Encrypt，SNI 与通配域名匹配。
3. 验证 Traefik Dashboard（若启用）：`https://dashboard.lwwl.cc`。

## 故障排查
- **证书申请失败**：检查 DNSPod API 权限、Token 是否只读、是否触发频率限制。必要时增加 `--dry-run` 观察请求负载。
- **DNS 未生效**：使用 `dig _acme-challenge.lwwl.cc txt` 或 `dig lwwl.cc a` 检查解析，确保 DNSPod 名字服务器 `cliff.dnspod.net` 与 `doris.dnspod.net` 已在注册商处设置。
- **Traefik API 403**：需要在 `TRAEFIK_API_AUTH` 中配置 Basic/Bearer 凭据，并在 Traefik Dashboard 上验证访问受限。
- **acme.json 权限错误**：证书请求会被 Traefik 拒绝，确保文件权限为 600，且只读挂载到容器内。

## 安全与扩展注意事项
- 将 `TRAEFIK_DNSPOD_API_KEY`、`acme.json` 存放于受控目录，并限制权限。
- 若未来需要多活或多节点，可将 Traefik 改为外部负载均衡，并使用远端 KV（Consul/Etcd）存储证书。
- 针对高流量场景，可在 Traefik 动态配置中增加速率限制、强制 TLS 1.2 以上、HSTS 等策略（目前模板已启用基本安全头）。
