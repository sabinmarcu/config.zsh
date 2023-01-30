ZDS=$0 debug Detecting starship

if command -v starship &> /dev/null; then
  ZDS=$0 debug Loading starship
  eval "$(starship init zsh)"
fi
