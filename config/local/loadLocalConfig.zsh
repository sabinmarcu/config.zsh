local ds=$(debugScope $0)

function loadLocalConfig {
  local pre=${1:-""}

  ZDS=$ds debug "Looking for local configs (prefix: '$pre')"
  local localConfig="$HOME/${pre}.zshrc.local"
  if [[ -e localConfig ]] &> /dev/null; then
    ZDS=$ds debug "Found main local config ($localConfig), loading now"
    source $localConfig
  fi
  local potentialLocalConfigs=$(ls -a $HOME | grep -E "^${pre}.zshrc" | grep -E ".local$")
  if [[ ! -z $potentialLocalConfigs ]] &> /dev/null; then
    ZDS=$ds debug "Found local configs, loading now"
    local localConfigs=($(echo $potentialLocalConfigs))
    for localRc in $localConfigs; do
      local localConfig="$HOME/$localRc"
      ZDS=$ds debug "Loading local config (at: $localConfig)"
      source $localConfig
    done
  fi
}
_cleanup loadLocalConfig

