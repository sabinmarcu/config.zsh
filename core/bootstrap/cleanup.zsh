cleanupFunctions=()
cleanupSymbols=()

function _cleanup {
  for arg in $@; do
    if typeset -p $arg &> /dev/null; then
      if ! (($cleanupSymbols[(Ie)$arg])); then
        cleanupSymbols=($cleanupSymbols $arg)
      fi
    else 
      if ! (($cleanupFunctions[(Ie)$arg])); then
        cleanupFunctions=($cleanupFunctions $arg)
      fi
    fi
  done
}

function _runCleanup {
  _cleanup _cleanup _runCleanup
  if ! (env | grep ZSH_DEBUG &> /dev/null); then
    for function in $cleanupFunctions; do
      unfunction $function
    done
    for symbol in $cleanupSymbols; do
      unset $symbol
    done
  else
    ZDS=cleanup debug "Cleanup Functions: ${cleanupFunctions}"
    ZDS=cleanup debug "Cleanup Symbols: ${cleanupSymbols}"
  fi
}
