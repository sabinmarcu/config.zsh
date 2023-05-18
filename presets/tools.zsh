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

if [ $ZSH_PLATFORM = 'macos' ]; then
  tools+=(
    yabai koekeishiya/formulae/yabai
    skhd koekeishiya/formulae/skhd
  )
  function tile {
    case $1 in
      start)
        info "Starting tiling"
        yabai --start-service
        skhd --start-service
        ;;
      stop)
        warn "Stopping tiling"
        yabai --stop-service
        skhd --stop-service
        ;;
      *)
        if result=$(launchctl list | grep yabai); then
          tile stop
        else
          tile start
        fi
    esac
  }
fi
