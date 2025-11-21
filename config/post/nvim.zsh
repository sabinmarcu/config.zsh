if command -v nvim &> /dev/null; then
  ZDS=$0 debug "Loading nvim"
  export NVIM_CUSTOM="$HOME/.config/nvim/lua/user"
fi
