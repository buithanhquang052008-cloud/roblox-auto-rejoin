#!/data/data/com.termux/files/usr/bin/bash

APP_DIR="$HOME/roblox-auto-rejoin"
LOG_DIR="$APP_DIR/logs"
PID_FILE="$APP_DIR/rejoin.pid"
LOG_FILE="$LOG_DIR/daemon.log"

mkdir -p "$LOG_DIR"

start_daemon() {
  echo $$ > "$PID_FILE"
  echo "[DAEMON] Started at $(date)" >> "$LOG_FILE"

  while true; do
    echo "[DAEMON] Launch rejoin.cjs $(date)" >> "$LOG_FILE"
    node "$APP_DIR/rejoin.cjs" >> "$LOG_DIR/rejoin.log" 2>&1
    echo "[DAEMON] rejoin.cjs crashed, restart in 5s..." >> "$LOG_FILE"
    sleep 5
  done
}

start_daemon
