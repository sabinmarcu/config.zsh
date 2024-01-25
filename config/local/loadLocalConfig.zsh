local ds=$(debugScope $0)

function loadLocalConfig {
  local pre=${1:-""}

  ZDS=$ds debug "Looking for local configs (prefix: '$pre')"
  if echo $HOME/${pre}.zshrc.*.local &> /dev/null; then
    ZDS=$ds debug "Found local configs, loading now"
    for localRc in $HOME/${pre}.zshrc.*.local; do
      ZDS=$ds debug "Loading local config (at: $localRc)"
      source $localRc
    done
  fi
}
_cleanup loadLocalConfig

