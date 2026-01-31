#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "🚀 Roblox Auto Rejoin - Online Installer"

BASE_DIR="$HOME/roblox-auto-rejoin"
REPO_URL="https://github.com/buithanhquang052008-cloud/roblox-auto-rejoin.git"

# fix dpkg prompt
pkg update -y -o Dpkg::Options::="--force-confold"

pkg install -y nodejs git tsu sqlite

if [ -d "$BASE_DIR/.git" ]; then
  echo "🔄 Update tool..."
  cd "$BASE_DIR"
  git pull
else
  echo "📥 Clone tool..."
  git clone "$REPO_URL" "$BASE_DIR"
  cd "$BASE_DIR"
fi

npm install --silent || true
chmod +x rejoin.cjs

echo "✅ Cài đặt hoàn tất!"
node rejoin.cjs
