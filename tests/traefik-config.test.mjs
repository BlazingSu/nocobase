import { readFileSync } from "node:fs";
import { join } from "node:path";
import { test } from "node:test";
import assert from "node:assert/strict";

const root = process.cwd();

const traefikConfigPath = join(root, "docker", "app-postgres", "traefik", "traefik.yml");
const composePath = join(root, "docker", "app-postgres", "docker-compose.yml");

const traefikConfig = readFileSync(traefikConfigPath, "utf8");
const composeConfig = readFileSync(composePath, "utf8");

test("traefik config enables dnspod resolver", () => {
  assert.match(traefikConfig, /certificatesResolvers:\s+dnspod/);
  assert.match(traefikConfig, /dnsChallenge:\s+[\s\S]*provider: dnspod/);
  assert.match(traefikConfig, /entryPoints:\s+[\s\S]*websecure/);
});

test("docker compose wires traefik labels", () => {
  assert.match(composeConfig, /traefik\.http\.routers\.nocobase\.rule=Host/);
  assert.match(composeConfig, /traefik\.http\.routers\.nocobase\.tls\.certresolver=dnspod/);
  assert.match(composeConfig, /traefik\.http\.routers\.nocobase\.middlewares=nocobase-compress@file,nocobase-security-headers@file/);
});
