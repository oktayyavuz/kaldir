#!/usr/bin/env bash
# kaldir ve kaldir-gui kurulumu (yalnızca kullanıcı klasörüne, sudo gerekmez)
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"

BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"
APP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/kaldir"

eksik=()
command -v pacman >/dev/null || { echo "Bu araç Arch tabanlı dağıtımlar içindir (pacman bulunamadı)." >&2; exit 1; }
python3 -c 'import PyQt6' 2>/dev/null || eksik+=(python-pyqt6)
command -v fzf >/dev/null || eksik+=(fzf)
command -v pkexec >/dev/null || eksik+=(polkit)
if (( ${#eksik[@]} )); then
    echo "Eksik paketler: ${eksik[*]}"
    echo "Kurmak için: sudo pacman -S --needed ${eksik[*]}"
    echo
fi

install -Dm755 kaldir "$BIN_DIR/kaldir"
install -Dm755 kaldir-gui "$BIN_DIR/kaldir-gui"
sed "s|@BIN_DIR@|$BIN_DIR|g" kaldir-gui.desktop.in > kaldir-gui.desktop.tmp
install -Dm644 kaldir-gui.desktop.tmp "$APP_DIR/kaldir-gui.desktop"
rm -f kaldir-gui.desktop.tmp

if [ ! -f "$CONFIG_DIR/korunan.txt" ]; then
    install -Dm644 korunan.txt.ornek "$CONFIG_DIR/korunan.txt"
fi

echo "Kuruldu:"
echo "  $BIN_DIR/kaldir"
echo "  $BIN_DIR/kaldir-gui"
echo "  $APP_DIR/kaldir-gui.desktop"
echo "  $CONFIG_DIR/korunan.txt (kendi koruma listen)"

case ":$PATH:" in
    *":$BIN_DIR:"*) ;;
    *) echo
       echo "Not: $BIN_DIR komut yolunda (PATH) değil. Kabuk ayar dosyana şunu ekle:"
       echo "  export PATH=\"$BIN_DIR:\$PATH\"" ;;
esac
