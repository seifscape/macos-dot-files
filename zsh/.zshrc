# Initialisation
eval "$(sheldon source)"
eval "$(zoxide init zsh)"
eval "$(mise activate zsh)"
eval "$(fnox activate zsh)"
eval "$(atuin init zsh)"
eval "$(starship init zsh)"

# Source custom configs
[ -f ~/.exports ] && source ~/.exports
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.functions ] && source ~/.functions
[ -f ~/.zsh_bindings ] && source ~/.zsh_bindings

# Dev tool update checks (brew + mise)
~/.config/scripts/dev-updates.sh

fastfetch

# print extra white line
echo
