#!/data/data/com.termux/files/usr/bin/bash
# rename.sh
# GitHub: github.com/lucivaantarez/rename

VERSION="1.3"
REMOTE_URL="https://raw.githubusercontent.com/lucivaantarez/rename/main/rename.sh"
SELF="$HOME/rename.sh"

check_update() {
  REMOTE_VERSION=$(curl -sL "$REMOTE_URL" 2>/dev/null | grep '^VERSION=' | head -1 | cut -d'"' -f2)
  if [[ -z "$REMOTE_VERSION" ]]; then
    return
  fi
  if [[ "$REMOTE_VERSION" != "$VERSION" ]]; then
    clear
    echo "[ UPDATE v$VERSION -> v$REMOTE_VERSION ]"
    curl -sL "$REMOTE_URL" | sed 's/\r//' > "$SELF"
    chmod +x "$SELF"
    sleep 1
    exec bash "$SELF"
    exit 0
  fi
}

check_update

show_menu() {
  clear
  CURRENT=$(su -c "settings get global device_name" 2>/dev/null)
  [[ -z "$CURRENT" ]] && CURRENT="(none)"
  echo "[ Device Rename v$VERSION ]"
  echo ""
  echo "Name: $CURRENT"
  echo ""
  echo "1. Rename"
  echo "0. Exit"
  echo ""
  printf ">> "
}

while true; do
  show_menu
  read CHOICE
  case "$CHOICE" in
    1)
      clear
      echo "[ Rename Device ]"
      echo ""
      printf "New name: "
      read NEW_NAME
      if [[ -z "$NEW_NAME" ]]; then
        continue
      fi
      su -c "settings put global device_name \"$NEW_NAME\""
      su -c "settings put secure bluetooth_name \"$NEW_NAME\""
      clear
      echo "[ Done: $NEW_NAME ]"
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
  esac
done
