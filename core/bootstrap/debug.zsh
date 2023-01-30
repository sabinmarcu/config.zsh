function debug {
  if [ ! -z $ZSH_DEBUG ]; then 
    local prefix=""
    SCP=${ZDS:-$ZSH_DEBUG_SCOPE}
    if [ ! -z $SCP ]; then 
      local scope=$SCP
      if [[ "$scope" == *\/* ]]; then
        scope=$(debugScope $scope)
      fi
      if ! [[ "$ZSH_DEBUG" == "true" ]]; then
        echo $scope | grep -E "^(${ZSH_DEBUG})" &> /dev/null
        if ! [[ $? -eq 0 ]]; then
          return 0
        fi
      fi
      prefix="\033[2m[$scope]\033[0m "
    fi
    echo ${prefix}${@}
  fi
}
_cleanup debug

function debugScope {
  local scope=$(echo $1 | awk -vzshcustom="$ZSH_CUSTOM" '{ sub(zshcustom, ""); sub(/^\/?/, ""); gsub(/\//, ":"); sub(/(:init)?\.zsh$/, ""); print $0 }')
  echo $scope
}
_cleanup debugScope
