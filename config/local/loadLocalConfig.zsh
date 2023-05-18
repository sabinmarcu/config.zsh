function loadLocalConfig {
  local pre=${1:-""}

  ZDS=$0 debug Looking for local config
  if [ -e $HOME/${1}.zshrc.local ]; then
    ZDS=$0 debug "Loading local config"
    source $HOME/${1}.zshrc.local 
  fi

  ZDS=$0 debug Looking for extra local configs
  for localRc in $HOME/${pre}.zshrc.*.local; do
    ZDS=$0 debug "Loading extra local config (at: $localRc)"
    source $localRc
  done
}
_cleanup loadLocalConfig

