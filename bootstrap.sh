#!/usr/bin/env zsh
# bootstrap.sh — full new machine setup

set -euo pipefail

DOTFILES_REPO="git@github.com:seifscape/macos-dot-files.git"
DOTFILES_DIR="$HOME/Development/macos-dot-files"

GREEN='\033[0;32m'; YELLOW='\033[0;33m'; RED='\033[0;31m'; BOLD='\033[1m'; NC='\033[0m'

info()    { echo "${GREEN}[info]${NC}  $*"; }
warn()    { echo "${YELLOW}[warn]${NC}  $*"; }
error()   { echo "${RED}[error]${NC} $*"; exit 1; }
section() { echo "\n${BOLD}══ $* ══${NC}"; }

# ── 1. Xcode CLI tools ────────────────────────────────────────────────────
section "Xcode CLI Tools"
if ! xcode-select -p &>/dev/null; then
  info "Installing Xcode CLI tools..."
  xcode-select --install
  info "Follow the prompt, then re-run this script."
  exit 0
else
  info "Already installed."
fi

# ── 2. Homebrew ───────────────────────────────────────────────────────────
section "Homebrew"
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  info "Already installed."
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ── 3. Clone dotfiles ─────────────────────────────────────────────────────
section "Dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
  info "Cloning dotfiles..."
  mkdir -p "$HOME/Development"
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
  info "Already cloned — pulling latest..."
  git -C "$DOTFILES_DIR" pull --ff-only
fi

cd "$DOTFILES_DIR"

# ── 4. Homebrew packages ──────────────────────────────────────────────────
section "Homebrew Packages"
info "Running brew bundle..."
brew bundle --file=homebrew/Brewfile

# ── 5. Sheldon plugins ───────────────────────────────────────────────────
section "Sheldon Plugins"
if command -v sheldon &>/dev/null; then
  info "Locking sheldon plugins..."
  sheldon lock
else
  warn "sheldon not found — was brew bundle successful?"
fi

# ── 6. Stow dotfiles ─────────────────────────────────────────────────────
section "Stow Dotfiles"
"$DOTFILES_DIR/install.sh"

# ── 8. Catppuccin delta theme ─────────────────────────────────────────────
section "Catppuccin Delta Theme"
if [ ! -d "$HOME/.config/delta-themes" ]; then
  info "Cloning catppuccin/delta..."
  git clone https://github.com/catppuccin/delta.git "$HOME/.config/delta-themes"
else
  info "Already cloned."
fi

# ── 9. Git identity ───────────────────────────────────────────────────────
section "Git Identity"
if [ ! -f "$HOME/.gitconfig.local" ]; then
  echo ""
  echo "  Enter your git identity (stored in ~/.gitconfig.local, not tracked):"
  echo ""
  read "git_name?  Name:  "
  read "git_email?  Email: "
  cat > "$HOME/.gitconfig.local" << EOF
[user]
    name = $git_name
    email = $git_email
EOF
  info "Written to ~/.gitconfig.local"
else
  info "~/.gitconfig.local already exists, skipping."
fi

# ── 10. mise ─────────────────────────────────────────────────────────────
section "mise"
if command -v mise &>/dev/null; then
  info "Installing mise runtimes..."
  mise install
else
  warn "mise not found — was brew bundle successful?"
fi

# ── done ──────────────────────────────────────────────────────────────────
echo ""
echo "${BOLD}${GREEN}All done!${NC}"
echo ""
echo "  Open a new terminal or run: source ~/.zshrc"
echo ""
