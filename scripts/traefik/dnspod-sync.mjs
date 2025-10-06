#!/usr/bin/env node
import { argv, env, exit } from "node:process";
import { fileURLToPath } from "node:url";
import assert from "node:assert/strict";

const API_BASE = "https://dnsapi.cn";
const DEFAULT_SUBDOMAINS = ["@", "*", "www"];
const DEFAULT_TTL = 600;
const DEFAULT_TRAEFIK_RELOAD = "http://127.0.0.1:8080/api/providers/reload";

export function parseArgs(rawArgv = argv, envVars = env) {
  const args = rawArgv.slice(2);
  const options = {
    domain: envVars.TRAEFIK_DOMAIN || envVars.DNSPOD_DOMAIN,
    domainId: envVars.TRAEFIK_DNSPOD_DOMAIN_ID || envVars.DNSPOD_DOMAIN_ID,
    token: envVars.TRAEFIK_DNSPOD_API_KEY || envVars.DNSPOD_LOGIN_TOKEN,
    target: envVars.TRAEFIK_TARGET_IP || envVars.DNS_TARGET_IP,
    ttl: envVars.TRAEFIK_DNS_TTL ? Number(envVars.TRAEFIK_DNS_TTL) : DEFAULT_TTL,
    subdomains: DEFAULT_SUBDOMAINS.slice(),
    dryRun: false,
    traefikReloadUrl: envVars.TRAEFIK_API_URL || DEFAULT_TRAEFIK_RELOAD,
    traefikReloadAuth: envVars.TRAEFIK_API_AUTH || "",
    skipReload: false,
  };

  for (let i = 0; i < args.length; i += 1) {
    const arg = args[i];
    if (arg === "--domain" && args[i + 1]) {
      options.domain = args[i + 1];
      i += 1;
    } else if (arg === "--domain-id" && args[i + 1]) {
      options.domainId = args[i + 1];
      i += 1;
    } else if (arg === "--token" && args[i + 1]) {
      options.token = args[i + 1];
      i += 1;
    } else if ((arg === "--ip" || arg === "--target") && args[i + 1]) {
      options.target = args[i + 1];
      i += 1;
    } else if (arg === "--ttl" && args[i + 1]) {
      options.ttl = Number(args[i + 1]);
      i += 1;
    } else if (arg.startsWith("--subdomains=")) {
      const list = arg.split("=")[1];
      options.subdomains = list.split(",").map((s) => s.trim()).filter(Boolean);
      i += 0;
    } else if (arg === "--subdomains" && args[i + 1]) {
      options.subdomains = args[i + 1].split(",").map((s) => s.trim()).filter(Boolean);
      i += 1;
    } else if (arg === "--dry-run") {
      options.dryRun = true;
    } else if (arg === "--traefik-reload-url" && args[i + 1]) {
      options.traefikReloadUrl = args[i + 1];
      i += 1;
    } else if (arg === "--traefik-reload-auth" && args[i + 1]) {
      options.traefikReloadAuth = args[i + 1];
      i += 1;
    } else if (arg === "--skip-reload") {
      options.skipReload = true;
    } else if (arg === "--help") {
      options.help = true;
    }
  }

  return options;
}

export function assertOptions(opts) {
  if (opts.help) {
    return;
  }
  assert.ok(opts.token, "Missing DNSPod API token. Use --token or TRAEFIK_DNSPOD_API_KEY");
  assert.ok(opts.domain || opts.domainId, "Provide --domain or --domain-id (or TRAEFIK_DOMAIN / TRAEFIK_DNSPOD_DOMAIN_ID)");
  assert.ok(opts.target, "Missing target IP (use --ip or TRAEFIK_TARGET_IP)");
  if (!Array.isArray(opts.subdomains) || opts.subdomains.length === 0) {
    throw new Error("At least one subdomain is required");
  }
}

function buildBaseParams(opts) {
  return opts.domainId ? { domain_id: opts.domainId } : { domain: opts.domain };
}

export async function callDnsPod(path, params, opts, fetchImpl = fetch) {
  const body = new URLSearchParams({
    format: "json",
    lang: "en",
    ...buildBaseParams(opts),
    ...params,
  });
  body.set("login_token", opts.token);
  const response = await fetchImpl(`${API_BASE}${path}`, {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body,
  });
  if (!response.ok) {
    throw new Error(`DNSPod API ${path} failed with ${response.status}`);
  }
  const payload = await response.json();
  if (!payload.status || payload.status.code !== "1") {
    const message = payload.status?.message || "Unknown error";
    throw new Error(`DNSPod API ${path} error: ${message}`);
  }
  return payload;
}

async function findRecord(subDomain, type, opts, fetchImpl) {
  const data = await callDnsPod("/Record.List", {
    sub_domain: subDomain,
    record_type: type,
  }, opts, fetchImpl);
  const [record] = data.records || [];
  return record || null;
}

async function createRecord(subDomain, type, value, ttl, opts, fetchImpl, dryRun) {
  if (dryRun) {
    return { action: "planned", record_id: null, sub_domain: subDomain, value, type };
  }
  const result = await callDnsPod("/Record.Create", {
    sub_domain: subDomain,
    record_type: type,
    value,
    ttl: String(ttl),
    record_line_id: "0",
  }, opts, fetchImpl);
  return { action: "created", record_id: result.record?.id || null, sub_domain: subDomain, value, type };
}

async function modifyRecord(record, value, ttl, opts, fetchImpl, dryRun) {
  if (dryRun) {
    return { action: "planned", record_id: record.id, sub_domain: record.name, value, type: record.type };
  }
  const result = await callDnsPod("/Record.Modify", {
    record_id: record.id,
    sub_domain: record.name,
    value,
    record_type: record.type,
    ttl: String(ttl),
    record_line_id: record.line_id || "0",
  }, opts, fetchImpl);
  return { action: "updated", record_id: result.record?.id || record.id, sub_domain: record.name, value, type: record.type };
}

export async function ensureRecord(subDomain, type, value, ttl, opts, fetchImpl = fetch) {
  const record = await findRecord(subDomain, type, opts, fetchImpl);
  if (!record) {
    return createRecord(subDomain, type, value, ttl, opts, fetchImpl, opts.dryRun);
  }
  if (record.value === value && Number(record.ttl) === Number(ttl)) {
    return { action: "unchanged", record_id: record.id, sub_domain: record.name, value, type: record.type };
  }
  return modifyRecord(record, value, ttl, opts, fetchImpl, opts.dryRun);
}

export async function syncDns(opts, fetchImpl = fetch) {
  const results = [];
  for (const sub of opts.subdomains) {
    const type = opts.recordType || "A";
    const outcome = await ensureRecord(sub, type, opts.target, opts.ttl, opts, fetchImpl);
    results.push(outcome);
  }
  return results;
}

export async function reloadTraefik(opts, fetchImpl = fetch) {
  if (opts.skipReload || !opts.traefikReloadUrl) {
    return { skipped: true };
  }
  const headers = {};
  if (opts.traefikReloadAuth) {
    headers.Authorization = opts.traefikReloadAuth;
  }
  const response = await fetchImpl(opts.traefikReloadUrl, {
    method: "POST",
    headers,
  });
  if (!response.ok) {
    throw new Error(`Traefik reload failed with status ${response.status}`);
  }
  return { skipped: false, status: response.status };
}

export async function run(rawArgv = argv, envVars = env, fetchImpl = fetch) {
  const options = parseArgs(rawArgv, envVars);
  if (options.help) {
    console.log(`Usage: node dnspod-sync.mjs [options]
  --domain <domain>              Root domain (e.g. lwwl.cc)
  --domain-id <id>               DNSPod domain ID
  --token <id,token>             DNSPod login token (id,token)
  --ip <address>                 Target IPv4 address for A records
  --subdomains a,b,c             Comma separated subdomains (@,*,www)
  --ttl <seconds>                TTL in seconds (default ${DEFAULT_TTL})
  --dry-run                      Do not perform write operations
  --skip-reload                  Do not call Traefik reload endpoint
  --traefik-reload-url <url>     Traefik management endpoint (default ${DEFAULT_TRAEFIK_RELOAD})
  --traefik-reload-auth <value>  Authorization header value for Traefik reload
`);
    return { skipped: true };
  }

  assertOptions(options);
  const dnsResults = await syncDns(options, fetchImpl);
  let reloadResult = { skipped: true };
  try {
    reloadResult = await reloadTraefik(options, fetchImpl);
  } catch (error) {
    if (!options.skipReload) {
      throw error;
    }
  }
  return { dnsResults, reloadResult };
}

if (fileURLToPath(import.meta.url) === process.argv[1]) {
  run().then((result) => {
    if (result.skipped) {
      exit(0);
    }
    console.log("DNS sync results:", JSON.stringify(result.dnsResults, null, 2));
    console.log("Traefik reload:", result.reloadResult);
    exit(0);
  }).catch((error) => {
    console.error(error.message);
    exit(1);
  });
}
