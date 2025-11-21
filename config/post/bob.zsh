if command -v bob &> /dev/null; then
  ZDS=$0 debug "Loading bob"
  export PATH="$PATH:$HOME/.local/share/bob/nvim-bin"
fi
