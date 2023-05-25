
if command -v yabai && command -v skhd &> /dev/null; then
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
