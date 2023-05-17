_zsh_colors_local=(
  cyan 36
  lightBlue 94
  white 97
  magenta 35
  yellow 33
  darkGray 90
  lightGray 37
  lightCyan 96
  lightGreen 92
  black 30
  red 31
  blue 34
  default 39
  green 32
  lightMagenta 95
  lightYellow 93
  lightRed 91
)

function zsh_color {
  if result=$(access "_zsh_colors_local" $1); then
    echo $result
    return 0
  fi
  return 1
}
