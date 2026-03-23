#!/data/data/com.termux/files/usr/bin/bash
# rename.sh
# GitHub: github.com/lucivaantarez/rename

VERSION="1.4"
REMOTE_URL="https://raw.githubusercontent.com/lucivaantarez/rename/main/rename.sh"
SELF="$HOME/rename.sh"

export TERM=xterm
export COLUMNS=40

check_update() {
  REMOTE_VERSION=$(curl -sL "$REMOTE_URL" 2>/dev/null | grep '^VERSION=' | head -1 | cut -d'"' -f2)
  if [[ -z "$REMOTE_VERSION" ]]; then return; fi
  if [[ "$REMOTE_VERSION" != "$VERSION" ]]; then
    tput reset
    printf "Update v%s -> v%s\n" "$VERSION" "$REMOTE_VERSION"
    printf "Downloading...\n"
    curl -sL "$REMOTE_URL" | sed 's/\r//' > "$SELF"
    chmod +x "$SELF"
    sleep 1
    exec bash "$SELF"
    exit 0
  fi
}

check_update

show_menu() {
  tput reset
  CURRENT=$(su -c "settings get global device_name" 2>/dev/null)
  [[ -z "$CURRENT" ]] && CURRENT="(none)"
  printf "Device Rename v%s\n" "$VERSION"
  printf "Name: %s\n\n" "$CURRENT"
  printf "1. Rename\n"
  printf "0. Exit\n\n"
  printf ">> "
}

while true; do
  show_menu
  read CHOICE
  case "$CHOICE" in
    1)
      tput reset
      printf "New name: "
      read NEW_NAME
      if [[ -z "$NEW_NAME" ]]; then continue; fi
      su -c "settings put global device_name \"$NEW_NAME\""
      su -c "settings put secure bluetooth_name \"$NEW_NAME\""
      tput reset
      printf "Done: %s\n" "$NEW_NAME"
      sleep 2
      ;;
    0)
      tput reset
      exit 0
      ;;
    *)
      continue
      ;;
  esac
done
