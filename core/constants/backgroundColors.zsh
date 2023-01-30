_zsh_background_colors_local=(
  bgWhite 107
  bgLightYellow 103
  bgLightRed 101
  bgCyan 46
  bgLightGray 47
  bgLightCyan 106
  bgDefault 49
  bgYellow 43
  bgLightGreen 102
  bgRed 41
  bgDarkGray 100
  bgBlack 40
  bgLightMagenta 105
  bgMagenta 45
  bgBlue 44
  bgGreen 42
  bgLightBlue 104
)
_cleanup _zsh_background_colors_local

function zsh_background_color {
  if result=$(access "_zsh_background_colors_local" $1); then
    echo $result
    return 0
  fi
  return 1
}
_cleanup zsh_background_color
