#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "🚀 Roblox Auto Rejoin PRO – Installer"

# ====== Chuẩn bị ======
pkg update -y
pkg install -y nodejs git dos2unix tmux

# ====== Setup storage ======
termux-setup-storage || true

# ====== Thư mục cài ======
INSTALL_DIR=$HOME/roblox-auto-rejoin
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# ====== Clone repo ======
echo "📥 Đang tải tool từ GitHub..."
git clone https://github.com/buithanhquang052008-cloud/roblox-auto-rejoin.git .
  
# ====== Fix line ending ======
dos2unix *.sh *.cjs 2>/dev/null || true

# ====== Cài package node ======
echo "📦 Cài npm dependencies..."
npm install axios cli-table3 figlet boxen screenshot-desktop

# ====== Quyền chạy ======
chmod +x rejoin.cjs install.sh install-online.sh

# ====== Hoàn tất ======
echo ""
echo "✅ CÀI ĐẶT HOÀN TẤT!"
echo "▶️ Chạy tool bằng:"
echo "   cd ~/roblox-auto-rejoin && node rejoin.cjs"
echo ""
echo "🔥 Chạy nền 24/7 (khuyên dùng):"
echo "   tmux new -s rejoin"
echo "   node rejoin.cjs"
echo "   (Ctrl+B rồi D để thoát)"
