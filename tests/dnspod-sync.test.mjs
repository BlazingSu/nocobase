import { test } from "node:test";
import assert from "node:assert/strict";
import {
  parseArgs,
  syncDns,
  reloadTraefik,
  run,
} from "../scripts/traefik/dnspod-sync.mjs";

function createFetchMock() {
  const calls = [];
  const fetchMock = async (url, options = {}) => {
    const { pathname } = new URL(url);
    let entries = [];
    if (options.body instanceof URLSearchParams) {
      entries = [...options.body.entries()];
    } else if (typeof options.body === "string") {
      entries = [...new URLSearchParams(options.body).entries()];
    }
    const params = Object.fromEntries(entries);
    calls.push({ pathname, params });

    if (pathname === "/Record.List") {
      if (params.sub_domain === "@") {
        return new Response(JSON.stringify({
          status: { code: "1" },
          records: [
            {
              id: "100",
              name: "@",
              type: "A",
              ttl: "600",
              value: "1.1.1.1",
              line_id: "0",
            },
          ],
        }), { status: 200 });
      }
      return new Response(JSON.stringify({ status: { code: "1" }, records: [] }), { status: 200 });
    }

    if (pathname === "/Record.Modify") {
      return new Response(JSON.stringify({ status: { code: "1" }, record: { id: params.record_id } }), { status: 200 });
    }

    if (pathname === "/Record.Create") {
      return new Response(JSON.stringify({ status: { code: "1" }, record: { id: "200" } }), { status: 200 });
    }

    if (pathname === "/api/providers/reload") {
      return new Response(null, { status: 200 });
    }

    throw new Error(`Unhandled fetch path ${pathname}`);
  };
  return { fetchMock, calls };
}

test("parseArgs merges cli and env", () => {
  const options = parseArgs([
    "node",
    "script",
    "--domain",
    "example.com",
    "--ip",
    "8.8.8.8",
    "--subdomains",
    "@,api",
    "--dry-run",
  ], {
    TRAEFIK_DNSPOD_API_KEY: "1,token",
  });
  assert.equal(options.domain, "example.com");
  assert.equal(options.target, "8.8.8.8");
  assert.deepEqual(options.subdomains, ["@", "api"]);
  assert.equal(options.dryRun, true);
  assert.equal(options.token, "1,token");
});

test("syncDns updates existing records and creates missing ones", async () => {
  const { fetchMock, calls } = createFetchMock();
  const opts = {
    domain: "example.com",
    token: "1,token",
    target: "8.8.8.8",
    ttl: 600,
    subdomains: ["@", "*"],
    dryRun: false,
  };
  const results = await syncDns(opts, fetchMock);
  assert.equal(results[0].action, "updated");
  assert.equal(results[1].action, "created");
  assert.equal(calls.filter((call) => call.pathname === "/Record.Modify").length, 1);
  assert.equal(calls.filter((call) => call.pathname === "/Record.Create").length, 1);
});

test("run executes with reload", async () => {
  const { fetchMock, calls } = createFetchMock();
  const result = await run([
    "node",
    "dnspod-sync.mjs",
    "--domain",
    "example.com",
    "--token",
    "1,token",
    "--ip",
    "8.8.8.8",
    "--subdomains",
    "@",
    "--traefik-reload-url",
    "http://localhost:8080/api/providers/reload",
  ], {}, fetchMock);
  assert.equal(result.dnsResults[0].action, "updated");
  const reloadCalls = calls.filter((call) => call.pathname === "/api/providers/reload");
  assert.equal(reloadCalls.length, 1);
});

test("reloadTraefik skips when configured", async () => {
  const { fetchMock } = createFetchMock();
  const result = await reloadTraefik({ skipReload: true }, fetchMock);
  assert.equal(result.skipped, true);
});
