_zsh_text_style_local=(
    dim 2
    blinking 5
    bold 1
    normal 0
    invisible 8
    reverse 7
    underlined 4
    italic 3
)
_cleanup _zsh_text_style_local

function zsh_text_style {
  if result=$(access "_zsh_text_style_local" $1); then
    echo $result
    return 0
  fi
  return 1
}
_cleanup zsh_text_style
