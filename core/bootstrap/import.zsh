local ds=$(debugScope $0)

function errorPath {
  ZDS=$ds ZSH_DEBUG=true debug "'\033[0;31m$1\033[0m'\033[0;33m ${@:2}\033[0m"
}
_cleanup errorPath

function zsh_resolve {
  if [ -f $1 ]; then
    echo $1
  elif [ -f $1.zsh ]; then
    echo $1.zsh
  elif [ -f $1/init.zsh ]; then
    echo $1/init.zsh 
  else
    return 1
  fi
  return 0
}
_cleanup zsh_resolve

declare -A cache
function zsh_import {
  if importPath=$(zsh_resolve "$1"); then
    if ! (($+cache[$importPath])); then
      ZDS=$ds debug importing $importPath
      cache[$importPath]=true
      source $importPath
    fi
  else
    errorPath $1 "isn't a valid file"
    return 1
  fi
  return 0
}
_cleanup zsh_import

function _cleanupImportCache {
  cache=()
}
_cleanup _cleanupImportCache

function resolve {
  local request=$(echo $1 | sed 's/\./\//g')
  local import="$ZSH_CUSTOM/$request"
  if resolution=$(zsh_resolve "$import"); then
    echo $resolution
  else
    return 1
  fi
  return 0
}
_cleanup resolve

function import {
  if resolution=$(resolve $1); then
    zsh_import $resolution
    return 0
  else
    errorPath $1 "is not a valid module"
    return 1
  fi
}
_cleanup import

