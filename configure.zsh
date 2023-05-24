#!/usr/bin/env zsh

local $XDG_CUSTOM_HOME=${XDG_CUSTOM_HOME:-"$HOME/.config"}
export ZSH_CUSTOM=${ZSH_CUSTOM:-"$XDG_CUSTOM_HOME/zsh"}
local ZSH_RC="$HOME/.zshrc"

function warn() {
  echo "\033[33m⚠ ${@}\033[0m"
}

function info() {
  echo "\033[34m ${@}\033[0m"
}

function success() {
  echo "\033[32m✓ ${@}\033[0m"
}

echo $(info Linking config)

function backup() {
  if [ -e $1 ]; then
    echo $(warn $1 exists. Saving to $1.old)
    mv $1 $1.old
  fi
}

backup $ZSH_RC
ln -s $ZSH_CUSTOM/init.zsh $ZSH_RC

echo $(success Linked config)

echo $(info Starting first run)
ZSH_CUSTOM_UPDATE=true zsh
echo $(success "First run successful!")

echo $(success "All done!")
