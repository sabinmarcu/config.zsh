local ds=$(debugScope $0)
local findCommand=/usr/bin/find

configList=()
configPath=()
for candidatePath in $XDG_CONFIG_HOME/*; do 
  ZDS=$ds debug "Finding configs in $XDG_CONFIG_HOME"
  if [ -d $candidatePath ]; then
    ZDS=$ds debug "Analysing $candidatePath"
    local candidate=$(basename $candidatePath)
    local target=$candidatePath
    local candidateFile=$($findCommand $candidatePath -depth 1 -iname "$candidate.*")
    if [ ! -z $candidateFile ]; then
      ZDS=$ds debug "Found candidate for config @ $candidateFile$ds debug "Found candidate for config @ $candidateFile$ds debug "Found candidate for config @ $candidateFile$ds debug "Found candidate for config @ $candidateFile""""
      target=$candidateFile
    fi
    ZDS=$ds debug "Exporting config path $candidate => $candidatePath"
    configPath+=(
      $candidate $candidatePath
    )
    ZDS=$ds debug "Exporting config $candidate => $target"
    configList+=(
      $candidate $target
    )
  fi
done

function config {
  local list_mode=false
  typeset -A configs=($configList)
  while getopts ":l" flag; do
    case $flag in
      l) list_mode=true;;
    esac
  done
  if [ $list_mode = true ]; then
    info "Supported configs are:"
    echo ${(k)configs}
  else
    local request=${1}
    if [ ! -z $configs[$request] ]; then
      $EDITOR $configs[$request]
    else
      error "No such config found ($request)"
    fi
  fi
}

function cdconfig {
  local list_mode=false
  typeset -A configs=($configPath)
  while getopts ":l" flag; do
    case $flag in
      l) list_mode=true;;
    esac
  done
  if [ $list_mode = true ]; then
    info "Supported configs are:"
    echo ${(k)configs}
  else
    local request=${1}
    if [ ! -z $configs[$request] ]; then
      cd $configs[$request]
    else
      error "No such config found ($request)"
    fi
  fi
}

function _config_autocomplete {
  local -a _descriptions _values
  typeset -A configs=($configList)
  _descriptions=(
    'list all configs'
  )
  _values=('-l')
  _values+=(${(k)configs})
  compadd -d _descriptions -a _values
}

compdef _config_autocomplete config
compdef _config_autocomplete cdconfig
