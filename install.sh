#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
BK="$HOME/_backup_dotfiles_$(date +%F_%H%M%S)"
mkdir -p "$BK"

backup_and_link () {
  local src="$REPO_DIR/$1"
  local dst="$HOME/$1"

  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mkdir -p "$BK/$(dirname "$1")"
    mv "$dst" "$BK/$1" 2>/dev/null || true
  fi
  ln -s "$src" "$dst"
}

backup_and_link ".config/hypr"
backup_and_link ".config/kitty"
backup_and_link ".config/quickshell/noctalia-shell"
[ -f "$REPO_DIR/.config/noctalia/settings.json" ] && backup_and_link ".config/noctalia/settings.json"
[ -f "$REPO_DIR/.config/noctalia/plugins.json" ] && backup_and_link ".config/noctalia/plugins.json"
[ -f "$REPO_DIR/.config/starship.toml" ] && backup_and_link ".config/starship.toml"

[ -f "$REPO_DIR/.zshrc" ] && backup_and_link ".zshrc"
[ -f "$REPO_DIR/.zprofile" ] && backup_and_link ".zprofile"
[ -f "$REPO_DIR/.zshenv" ] && backup_and_link ".zshenv"

echo "✅ Installed. Backup of previous files is in: $BK"
