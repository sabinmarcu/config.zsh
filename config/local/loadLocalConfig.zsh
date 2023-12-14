local ds=$(debugScope $0)

function loadLocalConfig {
  local pre=${1:-""}

  ZDS=$ds debug Looking for local config
  if [ -e $HOME/${1}.zshrc.local ]; then
    ZDS=$0 debug "Loading local config"
    source $HOME/${1}.zshrc.local 
  fi

  ZDS=$ds debug Looking for extra local configs
  for localRc in $HOME/${pre}.zshrc.*.local; do
    ZDS=$ds debug "Loading extra local config (at: $localRc)"
    source $localRc
  done
}
_cleanup loadLocalConfig

