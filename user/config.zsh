local ds=$(debugScope $0)
local findCommand=/usr/bin/find

_config_path=()
for candidatePath in $XDG_CONFIG_HOME/*; do 
  ZDS=$ds debug "Finding configs in $candidatePath"
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
  local mode="default"
  typeset -A paths=($_config_path)

  args=()
  while [ $OPTIND -le "$#" ]; do
    if getopts ":uls" option; then
      case $option in
        l) mode="list";;
        s) mode="status";;
        u) mode="update";;
      esac
    else
      args+=(${@:$OPTIND:1})
      ((OPTIND++))
    fi
  done

  ZDS=$ds debug "Mode: $mode"

  case $mode in
    list) 
        info "Supported configs are:"
        echo ${(k)paths}
      ;;
    status)
        configStatus
      ;;
    update)
        configUpdate
      ;;
    *)
      local request=${args:0:1}
      local tool=${${args:1:1}:-"$EDITOR"}
      if [ -z $paths[$request] ]; then
        error "No such config found ($request)"
        return 1
      fi
      if [ $tool = "cd" ]; then
        cd $paths[$request]
      else
        (cd $paths[$request] && eval "$tool")
      fi
    ;;
  esac
}

function configUpdateOne {
  typeset -A configs=($_config_path)
  local request=$1
  local configPath=$configs[$request]
  if [ -z $configPath ]; then
    error "No such config found ($request)"
    return 1
  fi
  ZDS=$ds debug "Updating $configPath $request"
  local originalPath=$(pwd)
  cd $configPath
  git pull
  returnValue=$?
  cd $originalPath &> /dev/null
  return $returnValue
}

function configUpdate {
  typeset -A configs=($_config_path)
  output=$(CONFIG_PRINT_NL=true configStatus)
  local code=$?
  ZDS=$ds debug "Output: $output (code: $code)"
  local needupdate=( $(echo $output | awk 'NR==1') )
  local refuseupdate=( $(echo $output | awk 'NR==2') )
  ZDS=$ds debug "Update needs: ${#needupdate} <${needupdate}>" 
  ZDS=$ds debug "Update refuse: ${#refuseupdate} <$refuseupdate>"
  if [ $code -eq 0 ] || ( [ ${#needupdate} -eq 0 ] && [ ${#refuseupdate} -gt 0 ] ); then
    success "Your configs are up to date with remote"
    if [ ${#refuseupdate} -gt 0 ]; then
      warn "Although the following are modified:"
      for config in $refuseupdate; do
        echo "  - $(style_text dim -- $config)"
      done
    fi
    return 0
  fi
  info "Updating configs"
  for key value in ${(kv)configs}; do
    if (($refuseupdate[(Ie)$key])); then
      warn "Config for $key ($value) is modified. Refusing to update"
    else
      ZDS=$ds debug "Checking if $key needs update"
      if (($needupdate[(Ie)$key])); then
        ZDS=$ds debug "Config $key is not up to date"
        info "Updating $key"
        output=$(configUpdateOne $key)
        local result=$?
        if ! [ $result -eq 0 ]; then
          error "There has been an error updating $key ($value)"
          echo $output
        else
          success "Updated $key"
        fi
      fi
    fi
  done
  info "Done"
}

function configStatus {
  local configs unclean notsync
  typeset -A configs=($_config_path)
  local originalPath=$(pwd)

  typeset -A unclean=()
  typeset -A notsync=()
  local needupdate=()

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
      local commits=$(git rev-list --left-right --count origin/${branch}...${branch})
      local remote=$(echo $commits | awk '{print $1}')
      local local=$(echo $commits | awk '{print $2}')
      local total=$(echo $commits | awk '{for(i=1;i<=NF;i++) t+=$i; print t; t=0}')
      ZDS=$ds debug "Config $key (branch: $branch), $commits commits out of sync"
      if [ $local -eq 0 ] && [ $remote -gt 0 ]; then
        needupdate+=($key)
      fi
      if ! [ $total -eq 0 ]; then
        ZDS=$ds debug "Adding $key to sync list"
        notsync+=(
          $key $commits
        )
      fi
    fi
  done

  cd $originalPath

  if ! [ -z $CONFIG_PRINT_NL ]; then
    local cantupdateInitial=(${(k)unclean} ${(k)notsync})
    local cantupdate=()
    for key in $cantupdateInitial; do
      if ! ((${needupdate[(Ie)$key]})); then
        cantupdate+=($key)
      fi
    done
    local all=($needupdate $cantupdate)
    if [ ${#all} -eq 0 ]; then
      return 0
    fi
    echo $needupdate
    echo $cantupdate | sed 's/ /\n/g' | sort | uniq | tr -s "\n" " "
    return 1
  fi

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
  if [ ${#words} -gt 2 ]; then 
    local exclude=$(compgen -abkA function | sort)
    local executables=$(
        comm -23 <(compgen -c) <(echo $exclude)
        type -tP $( comm -12 <(compgen -c) <(echo $exclude) )
    )
    local executables=( $(compgen -W "$executables" -- ${COMP_WORDS[COMP_CWORD]}) )
    _values+=($executables)
  else
    local configs
    typeset -A configs=($_config_path)
    _descriptions=(
      '-l list all configs'
      '-s get status of configs'
      '-u update configs'
    )
    _values=('-l' '-s' '-u')
    _values+=(${(k)configs})
  fi
  compadd -d _descriptions -a _values
}

compdef _config_autocomplete config
