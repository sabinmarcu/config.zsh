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
    local candidateFile=$($findCommand $candidatePath -depth 1 \( -iname "${candidate}.*" -o -iname "${candidate}rc" \))
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
  local configs
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

function configStatus {
  local configs unclean notsync
  typeset -A configs=($configPath)
  local originalPath=$(pwd)

  typeset -A unclean=()
  typeset -A notsync=()

  for key value in ${(kv)configs}; do
    ZDS=$ds debug "Trying $key (@ $value)"
    if [ -d $value/.git ]; then 
      ZDS=$ds debug "Processing $key"
      cd $value

      # Determine if repo is unclean
      local files=$(git status --porcelain)
      local hasFiles=$(if [ -n "$files" ]; then echo 0; else echo 1; fi)
      ZDS=$ds debug "Exit code: $hasFiles with files: \n${files}"
      if [ $hasFiles -eq 0 ]; then
        ZDS=$ds debug "Adding $key to unclean list"
        unclean+=(
          $key $value
        )
      fi

      # Determine if repo is unsynced
      local branch=$(git rev-parse --abbrev-ref HEAD)
      local commits=$(git rev-list --left-right --count origin/${branch}...${branch} | awk '{for(i=1;i<=NF;i++) t+=$i; print t; t=0}')
      ZDS=$ds debug "Config $key (branch: $branch), $commits commits out of sync"
      if [ ! $commits -eq 0 ]; then
        ZDS=$ds debug "Adding $key to sync list"
        notsync+=(
          $key $commits
        )
      fi
    fi
  done

  cd $originalPath

  local toPrint=(${(k)unclean} ${(k)notsync})
  if [ ${#toPrint} -eq 0 ]; then
    success "All configs are clean!"
  else 
    warn "The following configs require your attention"
    for key in ${(u)toPrint}; do
      info " " $(style_text bold -- $key) @ $(style_text dim -- ${configs[$key]})
      if [[ "${unclean[$key]}" != "" ]]; then
        echo "  - $(style_text dim -- 'is unclean')"
      fi
      if [[ "${notsync[$key]}" != "" ]]; then
        echo "  - $(style_text dim -- 'is not synced')"
      fi
    done
  fi
}

function _config_autocomplete {
  local -a _descriptions _values
  local configs
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

