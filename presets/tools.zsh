tools+=(
  nvim neovim
  lazygit lazygit
  bat bat
  fzf fzf
  rg ripgrep
  delta git-delta
  exa exa
  fd fd
  jq jq
  gdu gdu
  btm bottom
)

if command -v pacman &> /dev/null; then
  ZDS=$0 debug "Detected ArchLinux. Adding extra tools"
  tools+=(xsel xsel)
fi
