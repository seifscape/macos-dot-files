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
PACKAGES=(zsh git nvim delta starship ghostty scripts homebrew btop atuin tmux gh-dash mise sheldon
          omniwm vicinae aube)

for pkg in "${PACKAGES[@]}"; do
  if [ -d "$DOTFILES_DIR/$pkg" ]; then
    stow --dir="$DOTFILES_DIR" --target="$HOME" --restow "$pkg"
    info "Stowed $pkg"
  else
    warn "Package not found, skipping: $pkg"
  fi
done

# ── unregistered directories ──────────────────────────────────────────────
# A package folder that is not listed in PACKAGES above is silently never
# stowed. Warn so a newly added config cannot go unnoticed. NOT_PACKAGES
# lists directories that intentionally live here without being deployed.
NOT_PACKAGES=(screenshots .claude .git)

for dir in "$DOTFILES_DIR"/*(/N) "$DOTFILES_DIR"/.*(/N); do
  name="${dir:t}"
  [[ "$name" == "." || "$name" == ".." ]] && continue
  (( ${PACKAGES[(I)$name]} )) && continue
  (( ${NOT_PACKAGES[(I)$name]} )) && continue
  warn "Unregistered directory (not in PACKAGES): $name"
done

# ── Claude Code statusline ────────────────────────────────────────────────
# ~/.claude/settings.json belongs to Claude Code (it rewrites it for
# permissions, plugins and MCP servers), so it is not stowed. Merge in only
# the statusLine key, which renders the claude-code profile in starship.toml.
# linux-dot-files does the same with a chezmoi modify_ template.
if ! command -v jq &>/dev/null; then
  warn "jq not found — installing via Homebrew..."
  brew install jq
fi
claude_settings="$HOME/.claude/settings.json"
mkdir -p "${claude_settings:h}"
[ -s "$claude_settings" ] || echo '{}' > "$claude_settings"
merged=$(jq '.statusLine = {type: "command", command: "starship statusline claude-code", padding: 0}' "$claude_settings")
print -r -- "$merged" > "$claude_settings"   # write in place: keeps the file's mode
info "Set Claude Code statusLine to starship"

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
echo "  Sheldon plugins:"
echo "    sheldon lock"
echo ""
echo "  OmniWM (tiling window manager) — grant on first launch:"
echo "    Accessibility and Input Monitoring (required)"
echo "    Screen Recording (optional — overview thumbnails only)"
echo ""
info "Done. Open a new terminal or: source ~/.zshrc"
