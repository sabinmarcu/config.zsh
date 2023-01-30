ZDS=$0 debug Looking for local config

if [ -e $ZSH_LOCAL ]; then
  ZDS=$0 debug Loading local config
  source $ZSH_LOCAL
fi

