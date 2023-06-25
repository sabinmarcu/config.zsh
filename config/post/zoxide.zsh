if command -v zoxide &> /dev/null; then
  ZDS=$0 debug "Loading zoxide"
  eval "$(zoxide init zsh)"
fi
