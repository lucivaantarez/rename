#!/data/data/com.termux/files/usr/bin/bash
# rename.sh
# Changes Android device name & Bluetooth name via root
# GitHub: github.com/lucivaantarez/rename

VERSION="1.2"
REMOTE_URL="https://raw.githubusercontent.com/lucivaantarez/rename/main/rename.sh"
SELF="$HOME/rename.sh"

check_update() {
  REMOTE_VERSION=$(curl -sL "$REMOTE_URL" 2>/dev/null | grep '^VERSION=' | head -1 | cut -d'"' -f2)
  if [[ -z "$REMOTE_VERSION" ]]; then
    return
  fi
  if [[ "$REMOTE_VERSION" != "$VERSION" ]]; then
    clear
    echo "================================"
    echo "Update tersedia!"
    echo "Local : v$VERSION"
    echo "Remote: v$REMOTE_VERSION"
    echo "================================"
    echo ""
    echo "Mengunduh versi baru..."
    curl -sL "$REMOTE_URL" | sed 's/\r//' > "$SELF"
    chmod +x "$SELF"
    echo "Selesai. Memuat ulang..."
    sleep 1
    exec bash "$SELF"
    exit 0
  fi
}

check_update

show_menu() {
  clear
  CURRENT=$(su -c "settings get global device_name" 2>/dev/null)
  [[ -z "$CURRENT" ]] && CURRENT="(tidak ditemukan)"
  echo "================================"
  echo "Device Name Changer v$VERSION"
  echo "================================"
  echo ""
  echo "Current: $CURRENT"
  echo ""
  echo "1. Change Device Name"
  echo "0. Exit"
  echo ""
  echo "================================"
  printf "Pilih: "
}

while true; do
  show_menu
  read CHOICE
  case "$CHOICE" in
    1)
      clear
      echo "================================"
      echo "Change Device Name"
      echo "================================"
      echo ""
      printf "Nama baru: "
      read NEW_NAME
      if [[ -z "$NEW_NAME" ]]; then
        continue
      fi
      su -c "settings put global device_name \"$NEW_NAME\""
      su -c "settings put secure bluetooth_name \"$NEW_NAME\""
      clear
      echo "================================"
      echo "Berhasil diubah ke: $NEW_NAME"
      echo "================================"
      sleep 2
      ;;
    0)
      clear
      exit 0
      ;;
    *)
      continue
      ;;
  esac
done
      exit 0
      ;;
    *)
      continue
      ;;
  esac
done
