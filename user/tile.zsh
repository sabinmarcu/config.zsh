
if command -v yabai &> /dev/null && command -v skhd &> /dev/null; then
  function tile {
    case $1 in
      restart)
        if result=$(launchctl list | grep yabai); then
          tile stop
          tile start
        else
          tile start
        fi
        ;;
      start)
        info "Starting tiling"
        yabai --start-service
        ZDS=$0 debug "Starting yabai"
        skhd --start-service
        ZDS=$0 debug "Starting skhd"
        if command -v defaults &> /dev/null; then
          ZDS=$0 debug "Stopping StageManager (macos)"
          defaults write com.apple.WindowManager GloballyEnabled -bool false
        fi
        ;;
      stop)
        warn "Stopping tiling"
        ZDS=$0 debug "Stopping yabai"
        yabai --stop-service
        ZDS=$0 debug "Stopping skhd"
        skhd --stop-service
        if command -v defaults &> /dev/null; then
          ZDS=$0 debug "Starting StageManager (macos)"
          defaults write com.apple.WindowManager GloballyEnabled -bool true
        fi
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
