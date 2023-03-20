ZDS=$0 debug Loading linux essentials

if command -v pacman &> /dev/null; then
  ZDS=$0 debug Detected Arch Linux
  import tools.essentials.linux.arch
fi
