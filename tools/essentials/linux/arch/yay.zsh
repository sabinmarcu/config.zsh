
ZDS=$0 debug Ensuring yay is installed
if ! command -v yay &> /dev/null; then
  echo $(warn Yay not installed)
  # Official installation type
  sudo pacman -S --needed git base-devel
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
  cd ../
  rm -rf yay
fi


