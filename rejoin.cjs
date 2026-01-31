const { exec } = require("child_process");

const PLACE_ID = "123456789"; // 🔴 THAY PLACE ID
const CHECK_INTERVAL = 5000;
const REJOIN_DELAY = 3000;
const ROBLOX_PACKAGE = "com.roblox.client";

let lastOnline = true;
let isRejoining = false;

function checkInternet(cb) {
  exec("ping -c 1 8.8.8.8", err => cb(!err));
}

function closeRoblox() {
  return new Promise(res => {
    exec(`am force-stop ${ROBLOX_PACKAGE}`, () => res());
  });
}

function openRoblox() {
  return new Promise(res => {
    exec(`am start -a android.intent.action.VIEW -d "roblox://placeId=${PLACE_ID}"`, () => res());
  });
}

async function rejoinFlow() {
  if (isRejoining) return;
  isRejoining = true;
  await closeRoblox();
  await new Promise(r => setTimeout(r, REJOIN_DELAY));
  await openRoblox();
  isRejoining = false;
}

setInterval(() => {
  checkInternet(async online => {
    if (online && !lastOnline) {
      await rejoinFlow();
    }
    lastOnline = online;
  });
}, CHECK_INTERVAL);

console.log("🚀 Roblox Auto Rejoin đang chạy...");
process.stdin.resume();
