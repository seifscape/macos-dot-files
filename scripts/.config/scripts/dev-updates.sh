#!/usr/bin/env zsh

# 🧼 Show Homebrew update reminder (non-blocking)
if command -v brew &>/dev/null; then
  if brew outdated | grep -q .; then
    echo "🧼 Homebrew updates available. Run: brew upgrade"
  fi
fi

# 🔁 Auto upgrade mise weekly
MISE_UPGRADE_CHECK="$HOME/.cache/last_mise_upgrade"
# zstat instead of stat: `stat -f` is BSD-only and this also runs on Linux.
zmodload -F zsh/stat b:zstat
if [ ! -f "$MISE_UPGRADE_CHECK" ] || [ $(($(date +%s) - $(zstat +mtime "$MISE_UPGRADE_CHECK"))) -ge 604800 ]; then
  echo "🔄 Running mise upgrade..."
  mise upgrade --yes
  touch "$MISE_UPGRADE_CHECK"
fi

