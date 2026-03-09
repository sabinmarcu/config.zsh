if command -v bob &> /dev/null; then
  ZDS=$0 debug "Loading bob"
  _updatePath "$HOME/.local/share/bob/nvim-bin"
fi
