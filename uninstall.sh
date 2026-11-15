#!/usr/bin/env bash
# kaldir ve kaldir-gui'yi kaldırır. Koruma listen (~/.config/kaldir) silinmez.
set -euo pipefail

BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"
APP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/applications"

rm -fv "$BIN_DIR/kaldir" "$BIN_DIR/kaldir-gui" "$APP_DIR/kaldir-gui.desktop"
echo "Koruma listen yerinde bırakıldı: ${XDG_CONFIG_HOME:-$HOME/.config}/kaldir/korunan.txt"
