#!/usr/bin/env node
'use strict';

/*
 * ROBLOX AUTO REJOIN – UPD PRO
 * Stable | Public | Termux
 */

const { exec, spawn } = require("child_process");
const fs = require("fs");
const path = require("path");

// ===== USER CONFIG =====
const PLACE_ID = "2753915549";   // đổi game nếu muốn
const LINK_CODE = "";            // private server nếu có
const BASE_DELAY = 20;           // delay gốc (giây)
const MAX_DELAY = 120;           // delay tối đa

// ===== LOG =====
const LOG_DIR = path.join(process.cwd(), "logs");
const LOG_FILE = path.join(LOG_DIR, "rejoin.log");

if (!fs.existsSync(LOG_DIR)) fs.mkdirSync(LOG_DIR, { recursive: true });

function log(msg, color = "\x1b[37m") {
  const time = new Date().toLocaleString();
  const line = `[${time}] ${msg}`;
  console.log(color + line + "\x1b[0m");
  fs.appendFileSync(LOG_FILE, line + "\n");
}

const sleep = ms => new Promise(r => setTimeout(r, ms));

// ===== ROBLOX =====
function isRobloxRunning() {
  return new Promise(resolve => {
    exec("pgrep -f roblox", (err, stdout) => {
      resolve(Boolean(stdout && stdout.trim()));
    });
  });
}

function closeRoblox() {
  return new Promise(resolve => {
    exec("pkill -f roblox || true", () => {
      log("🔴 Đã đóng Roblox", "\x1b[33m");
      resolve();
    });
  });
}

function openRoblox() {
  let url = `roblox://placeId=${PLACE_ID}`;
  if (LINK_CODE) url += `&linkCode=${LINK_CODE}`;

  exec(`am start -a android.intent.action.VIEW -d "${url}"`, () => {
    log("🟢 Đã mở Roblox", "\x1b[32m");
  });
}

// ===== CHECK NETWORK =====
function checkNetwork() {
  return new Promise(resolve => {
    exec("ping -c 1 roblox.com", err => {
      resolve(!err);
    });
  });
}

// ===== MAIN =====
async function main() {
  log("🚀 Roblox Auto Rejoin PRO STARTED", "\x1b[35m");

  let failCount = 0;

  while (true) {
    const networkOK = await checkNetwork();
    const robloxRunning = await isRobloxRunning();

    if (!networkOK || !robloxRunning) {
      failCount++;
      const delay = Math.min(BASE_DELAY + failCount * 10, MAX_DELAY);

      log(`❌ Phát hiện lỗi (${failCount}) → Rejoin`, "\x1b[31m");

      await closeRoblox();
      await sleep(3000);
      openRoblox();

      log(`⏳ Delay ${delay}s (retry thông minh)`, "\x1b[36m");
      await sleep(delay * 1000);
    } else {
      failCount = 0;
      log("✅ Roblox đang hoạt động ổn định", "\x1b[90m");
      await sleep(BASE_DELAY * 1000);
    }
  }
}

process.on("SIGINT", () => {
  log("🛑 Tool stopped", "\x1b[33m");
  process.exit(0);
});

main();
