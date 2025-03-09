local ds=$(debugScope $0)

function _brew_install {
  ZDS="$ds:brew" debug Installing "$@"
  brew install $@ 
}
_cleanup _brew_install

function _yay_install {
  ZDS="$ds:yay" debug Installing "$@"
  yes | yay -S $@
}
_cleanup _yay_install

function _apt_get_install {
  ZDS="$ds:apt-get" debug Installing "$@"
  apt-get install $@
}
_cleanup _apt_get_install

function _rpm_ostree_install {
  ZDS="$ds:rpm-ostree" debug Installing "$@"
  rpm-ostree install $@
}

function _linux_install {
  if command -v rpm-ostree; then
    _rpm_ostree_install $@
    return 0
  fi
  if command -v apt-get; then
    _apt_get_install $@
    return 0
  fi
  if command -v yay; then
    _yay_install $@
    return 0
  fi
  echo  $(error "Don't know what to install this with (even if I know you're on linux)")
}
_cleanup _linux_install

function omninstall {
  ZDS=$ds debug Installing "$@"
  case $ZSH_PLATFORM in
    macos*) _brew_install $@;;
    linux*) _linux_install $@;;
    *) echo $(error "Don't know what to install this with!");;
  esac
}
_cleanup omninstall
