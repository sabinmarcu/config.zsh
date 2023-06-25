local ds=$(debugScope $0)
local findCommand=/usr/bin/find

_config_path=()
for candidatePath in $XDG_CONFIG_HOME/*; do 
  ZDS=$ds debug "Finding configs in $XDG_CONFIG_HOME"
  if [ -d $candidatePath ]; then
    if [ -d $candidatePath/.git ]; then
      ZDS=$ds debug "Analysing $candidatePath"
      local candidate=$(basename $candidatePath)
      ZDS=$ds debug "Exporting config path $candidate => $candidatePath"
      _config_path+=(
        $candidate $candidatePath
      )
    fi
  fi
done

function config {
  local list_mode=false status_mode=false
  typeset -A paths=($_config_path)

  args=()
  while [ $OPTIND -le "$#" ]; do
    if getopts ":ls" option; then
      case $option in
        l) list_mode=true;;
        s) status_mode=true;;
      esac
    else
      args+=(${@:$OPTIND:1})
      ((OPTIND++))
    fi
  done

  if [ $list_mode = true ]; then
    info "Supported configs are:"
    echo ${(k)paths}
  elif [ $status_mode = true ]; then
    configStatus
  else
    local request=${args:0:1}
    local tool=${${args:1:1}:-"$EDITOR"}
    if [ ! -z $paths[$request] ]; then
      if [ $tool = "cd" ]; then
        cd $paths[$request]
      else
        (cd $paths[$request] && $tool)
      fi
    else
      error "No such config found ($request)"
    fi
  fi
}

function configStatus {
  local configs unclean notsync
  typeset -A configs=($_config_path)
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
  typeset -A configs=($_config_path)
  _descriptions=(
    'list all configs'
  )
  _values=('-l')
  _values+=(${(k)configs})
  compadd -d _descriptions -a _values
}

compdef _config_autocomplete config
compdef _config_autocomplete cdconfig

