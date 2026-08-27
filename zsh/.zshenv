# ====================================
# Universal Shell Environment (.zshenv)
# Loaded for all shell types — login, interactive, and scripts
# ====================================

# --------- uv (Python package manager) ---------
export PATH="$HOME/.local/bin:$PATH"

# --------- misc ---------
# Read by Claude Code; lives here so GUI/non-interactive launches see it.
export ENABLE_LSP_TOOLS=1
