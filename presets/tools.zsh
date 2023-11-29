tools+=(
  nvim neovim
  lazygit lazygit
  bat bat
  fzf fzf
  rg ripgrep
  delta git-delta
  eza eza
  fd fd
  jq jq
  gdu gdu
  btm bottom
  zoxide zoxide
)

if command -v pacman &> /dev/null; then
  ZDS=$0 debug "Detected ArchLinux. Adding extra tools"
  tools+=(xsel xsel)
fi

if [ $ZSH_PLATFORM = 'macos' ]; then
  tools+=(
    yabai koekeishiya/formulae/yabai
    skhd koekeishiya/formulae/skhd
  )
fi
