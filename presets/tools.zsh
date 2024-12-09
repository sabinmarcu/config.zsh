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
  gdu-go gdu
  btm bottom
  zoxide zoxide
  tmuxinator tmuxinator
  op 1password-cli
  vipe moreutils
  luarocks luarocks
  luajit luajit
  gum gum
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

import presets.yazi
import presets.sesh
