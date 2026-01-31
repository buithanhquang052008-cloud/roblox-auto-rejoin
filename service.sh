#!/data/data/com.termux/files/usr/bin/bash

APP_DIR="$HOME/roblox-auto-rejoin"
PID_FILE="$APP_DIR/rejoin.pid"

start() {
  if [ -f "$PID_FILE" ] && kill -0 "$(cat $PID_FILE)" 2>/dev/null; then
    echo "🟢 Service đã chạy (PID $(cat $PID_FILE))"
    exit 0
  fi

  nohup bash "$APP_DIR/daemon.sh" >/dev/null 2>&1 &
  sleep 1
  echo "✅ Service đã khởi động"
}

stop() {
  if [ -f "$PID_FILE" ]; then
    kill "$(cat $PID_FILE)" 2>/dev/null
    rm -f "$PID_FILE"
    echo "🛑 Service đã dừng"
  else
    echo "⚠️ Service chưa chạy"
  fi
}

status() {
  if [ -f "$PID_FILE" ] && kill -0 "$(cat $PID_FILE)" 2>/dev/null; then
    echo "🟢 Service đang chạy (PID $(cat $PID_FILE))"
  else
    echo "🔴 Service không chạy"
  fi
}

case "$1" in
  start) start ;;
  stop) stop ;;
  restart) stop; sleep 1; start ;;
  status) status ;;
  *)
    echo "Dùng:"
    echo "  ./service.sh start"
    echo "  ./service.sh stop"
    echo "  ./service.sh restart"
    echo "  ./service.sh status"
    ;;
esac
