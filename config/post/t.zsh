local T_PLUGIN_PATH="$XDG_CONFIG_HOME/tmux/t-smart-tmux-session-manager/bin"

ZDS=$0 debug "Checking for T at $T_PLUGIN_PATH"
if [ -d $T_PLUGIN_PATH ]; then
  ZDS=$0 debug "T found, adding to path"
  export PATH="$T_PLUGIN_PATH:$PATH"
fi
