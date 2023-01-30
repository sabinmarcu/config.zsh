import core.utils.compileVariable 

local COLOR_PREFIX="ZSH_COLOR_"

declare -A _zsh_colors_local
rawColors=(
  Default 39
  Black 30
  Red 31
  Green 32
  Yellow 33
  Blue 34
  Magenta 35
  Cyan 36
  "Light Gray" 37
  "Dark Gray" 90
  "Light Red" 91
  "Light Green" 92
  "Light Yellow" 93
  "Light Blue" 94
  "Light Magenta" 95
  "Light Cyan" 96
  White 97
)

for k v ("${(@kv)rawColors}") compileVariable _zsh_colors_local $COLOR_PREFIX $k $v

_zsh_colors_export=(${(kv)_zsh_colors_local})
_cleanup _zsh_colors_export

function zsh_color {
  if result=$(access "_zsh_colors_export" $1); then
    echo $result
    return 0
  fi
  return 1
}
_cleanup zsh_color
