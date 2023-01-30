
import core.utils.compileVariable

local TEXT_STYLE_PREFIX="ZSH_TEXT_STYLE_"

declare -A _zsh_text_style_local
local rawTextStyle=(
    Normal 0
    Bold 1
    Dim 2
    Italic 3
    Underlined 4
    Blinking 5
    Reverse 7
    Invisible 8
)

for k v ("${(@kv)rawTextStyle}") compileVariable "_zsh_text_style_local" $TEXT_STYLE_PREFIX $k $v

_zsh_text_style_export=(${(kv)_zsh_text_style_local})
_cleanup _zsh_text_style_export

function zsh_text_style {
  if result=$(access "_zsh_text_style_export" $1); then
    echo $result
    return 0
  fi
  return 1
}
_cleanup zsh_text_style
