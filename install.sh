#!/usr/bin/env zsh
# install.sh — macos-dot-files bootstrap

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
GREEN='\033[0;32m'; YELLOW='\033[0;33m'; BOLD='\033[1m'; NC='\033[0m'

info() { echo "${GREEN}[info]${NC}  $*"; }
warn() { echo "${YELLOW}[warn]${NC}  $*"; }

# ── preflight ─────────────────────────────────────────────────────────────
if ! command -v stow &>/dev/null; then
  warn "stow not found — installing via Homebrew..."
  brew install stow
fi

# ── stow packages ─────────────────────────────────────────────────────────
PACKAGES=(zsh git nvim delta starship ghostty scripts homebrew btop atuin tmux gh-dash mise)

for pkg in "${PACKAGES[@]}"; do
  if [ -d "$DOTFILES_DIR/$pkg" ]; then
    stow --dir="$DOTFILES_DIR" --target="$HOME" --restow "$pkg"
    info "Stowed $pkg"
  else
    warn "Package not found, skipping: $pkg"
  fi
done

# ── manual steps ──────────────────────────────────────────────────────────
echo ""
echo "${BOLD}Manual steps required on a new machine:${NC}"
echo ""
echo "  TPM (tmux Plugin Manager):"
echo "    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
echo "    # Then inside tmux: prefix + I to install plugins"
echo ""
echo "  Catppuccin theme for git-delta:"
echo "    git clone https://github.com/catppuccin/delta.git ~/.config/delta-themes"
echo ""
echo "  Git identity (not tracked — create on each machine):"
echo "    cat > ~/.gitconfig.local << 'EOF'"
echo "    [user]"
echo "        name = Your Name"
echo "        email = you@example.com"
echo "    EOF"
echo ""
echo "  Oh My Zsh plugins:"
echo "    git clone https://github.com/zsh-users/zsh-autosuggestions \\"
echo "      \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
echo "    git clone https://github.com/zsh-users/zsh-syntax-highlighting \\"
echo "      \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
echo "    git clone https://github.com/djui/alias-tips \\"
echo "      \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/alias-tips"
echo "    git clone https://github.com/Aloxaf/fzf-tab \\"
echo "      \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab"
echo ""
info "Done. Open a new terminal or: source ~/.zshrc"
