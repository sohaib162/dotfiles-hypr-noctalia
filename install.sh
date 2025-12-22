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

backup_and_link ".local/bin"

# Install coding dependencies
echo "Installing coding dependencies..."

# Install code-oss if not present
if ! command -v code-oss &> /dev/null && ! command -v code &> /dev/null; then
  echo "Installing VS Code..."
  sudo dnf install -y code
fi

# Install gitg
if ! command -v gitg &> /dev/null; then
  sudo dnf install -y gitg
fi

# Install python tools
sudo dnf install -y python3-pip python3-venv

# Install nodejs if not
if ! command -v node &> /dev/null; then
  sudo dnf install -y nodejs npm
fi

# Make scripts executable
chmod +x "$REPO_DIR/.local/bin/"*

echo "Coding tools installed."

echo "✅ Installed. Backup of previous files is in: $BK"
