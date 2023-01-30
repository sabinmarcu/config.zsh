import core.utils.compileVariable 

local COLOR_PREFIX="ZSH_BACKGROUND_COLOR_"

declare -A _zsh_background_colors_local
rawColors=(
  Default 49
  Black 40
  Red 41
  Green 42
  Yellow 43
  Blue 44
  Magenta 45
  Cyan 46
  "Light Gray" 47
  "Dark Gray" 100
  "Light Red" 101
  "Light Green" 102
  "Light Yellow" 103
  "Light Blue" 104
  "Light Magenta" 105
  "Light Cyan" 106
  White 107
)

for k v ("${(@kv)rawColors}") compileVariable _zsh_background_colors_local $COLOR_PREFIX "Bg $k" $v

_zsh_background_colors_export=(${(kv)_zsh_background_colors_local})
_cleanup _zsh_background_colors_export

function zsh_background_color {
  if result=$(access "_zsh_background_colors_export" $1); then
    echo $result
    return 0
  fi
  return 1
}
_cleanup zsh_background_color
