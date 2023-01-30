function compileVariable {
  local accumulator=$1
  local envPrefix=$2
  local name=$3
  local value=$4
  local mapName=$(echo $name | awk '{ printf "%s", tolower($1); for (i=2; i<=NF; i++) printf "%s%s", toupper(substr($i,1,1)), tolower(substr($i,2)); print ""; }')

  # Create a new value for <accumulator>
  local updatedAccumulator=(${(Pkv)accumulator} $mapName $value)
  # Set the value of our original accumulator to current
  set -A $1 ${(kv)updatedAccumulator}

  if env | grep ZSH_DEBUG &> /dev/null; then
    local envName=$(echo $name | awk '{ gsub(/ +/, "_"); print toupper($0) }')
    export "${envPrefix}${envName}"="$value"
  fi
}
