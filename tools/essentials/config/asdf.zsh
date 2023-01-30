local ds=$(debugScope $0)

function _ensure_plugin {
  ZDS=$ds debug "Ensuring plugin $1"
  if ! asdf plugin list | grep "${1}" &> /dev/null; then
    ZDS=$ds debug "Installing $1 plugin"
    asdf plugin add $1 
  fi
}
_cleanup _ensure_plugin

function _get_latest {
  _ensure_plugin $1
  local latest=$(asdf latest $1)
  if ! asdf list $1 | grep $latest &> /dev/null; then
    ZDS=$ds debug Installing $1@latest
    asdf install $1 latest
    asdf global $1 latest
  else
    ZDS=$ds debug $1 is already @latest
  fi
}
_cleanup _get_latest

_get_latest nodejs
_get_latest yarn
