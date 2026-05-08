# ====================================
# Login Shell Environment (.zprofile)
# Runs once at login — PATH and env setup only
# ====================================

# --------- Homebrew ---------
eval "$(/opt/homebrew/bin/brew shellenv)"

# --------- OrbStack ---------
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# --------- Visual Studio Code ---------
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
