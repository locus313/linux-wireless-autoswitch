#!/usr/bin/env bash
# Usage: sudo ./install.sh [i|up|ui]
set -euo pipefail

SCRIPT_NAME="70-wifi-autoswitch"
DEST="/etc/NetworkManager/dispatcher.d/${SCRIPT_NAME}"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/${SCRIPT_NAME}"

if [[ $EUID -ne 0 ]]; then
  exec sudo "$0" "$@"
fi

install_script() {
  install -m 755 -o root -g root "$SRC" "$DEST"
  command -v restorecon >/dev/null 2>&1 && restorecon "$DEST"
  echo "Installed $DEST"
}

case "${1:-}" in
  i | up) install_script ;;
  ui)
    rm -f "$DEST"
    echo "Removed $DEST"
    ;;
  *)
    echo "Usage: $0 {i|up|ui}  (install | update | uninstall)"
    exit 1
    ;;
esac
