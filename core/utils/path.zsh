function _updatePath {
  ZDS=$0 debug Updating path with $1
  export PATH="$PATH:$1"
  ZDS=$0 debug New Path: $PATH
}
_cleanup _updatePath
