#!/usr/bin/env zsh

export ZSH_CUSTOM=${ZSH_CUSTOM:-"$HOME/.zsh_custom"}
local ZSH_CUSTOM_REPO_SSH_URL="git@github.com:sabinmarcu/zshrc.zplug.git"
local ZSH_CUSTOM_REPO_ARCHIVE_URL="http://github.com/sabinmarcu/zshrc.zplug/archive/master.zip"

function warn() {
  echo "\033[33m⚠ ${@}\033[0m"
}

function info() {
  echo "\033[34m ${@}\033[0m"
}

function success() {
  echo "\033[32m✓ ${@}\033[0m"
}

echo $(info Installing config)

if [ -d $ZSH_CUSTOM ]; then
  echo $(warn ${ZSH_CUSTOM} already exists. Saving to ${ZSH_CUSTOM}.old)
  mv $ZSH_CUSTOM $ZSH_CUSTOM.old
fi

if [ $(command -v git) ]; then
  echo $(info Installing with git)
  git clone $ZSH_CUSTOM_REPO_SSH_URL $ZSH_CUSTOM
else 
  if [ $(command -v curl) ]; then 
    sh -c "$(curl -OL $ZSH_CUSTOM_REPO_ARCHIVE_URL)"
  else
    sh -c "$(wget $ZSH_CUSTOM_REPO_ARCHIVE_URL)"
  fi
  unzip master.zip
  mv zshrc-master $ZSH_CUSTOM
  rm master.zip
fi

echo $(success Installed config)
echo $(info Linking config)

function backup() {
  if [ -e $1 ]; then
    echo $(warn $1 exists. Saving to $1.old)
    mv $1 $1.old
  fi
}

local ZSH_RC="$HOME/.zshrc"
backup $ZSH_RC
ln -s $ZSH_CUSTOM/init.zsh $ZSH_RC

echo $(success Linked config)
echo $(info Linking starship config)

mkdir -p $HOME/.config
local STARSHIP_RC="$HOME/.config/starship.toml"
backup $STARSHIP_RC
ln -s $ZSH_CUSTOM/starship.toml $STARSHIP_RC

echo $(success Linked starship config)

echo $(info Starting first run)
ZSH_CUSTOM_UPDATE=true zsh
echo $(success "First run successful!")

echo $(success "All done!")
