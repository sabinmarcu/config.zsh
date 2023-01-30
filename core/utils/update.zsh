function shouldUpdate {
  if ! [ -z $ZSH_CUSTOM_UPDATE ]; then
    return 0
  fi
  return 1
}
_cleanup shouldUpdate

function triggerUpdate {
  export ZSH_CUSTOM_UPDATE=true
}
_cleanup triggerUpdate

function zshCustomUpdate {
  ZSH_CUSTOM_UPDATE=true exec zsh
  source $ZSH_CONFIG
}
