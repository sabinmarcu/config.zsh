local ZSH_DEBUG_SCOPE=zplug
local ZPLUG_INIT=$ZPLUG_HOME/init.zsh
local ds=$(debugScope $0)

ZDS=$ds debug Ensuring zplug is installed
if [ ! -f $ZPLUG_INIT ]; then
  echo $(warn ZPlug not installed. Installing now!)
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
fi

ZDS=$ds debug Initializing zplug
source $ZPLUG_INIT

function _runZplug {
  ZDS=$ds debug Looking for plugins
  if PLUGINS_PATH=$(resolve plugins); then 
    ZDS=$ds debug Loading plugins from $PLUGINS_PATH
    source $PLUGINS_PATH
  fi

  if [[ ${#plugins} -eq 0 ]]; then
    echo $(warn Plugins not defined)
    echo $(info Consider adding some at:)
    echo "\t- $(style_text blue underlined -- $ZSH_CUSTOM/plugins.zsh)"
    echo "\t- $(style_text blue underlined -- $ZSH_CUSTOM/plugins/init.zsh)"
    echo "\t- $(style_text blue underlined -- $HOME/$ZSH_CUSTOM)"
    echo $(warn "Append / Replace the '$(style_text blue underlined -- plugins)$(style_text yellow -- "' variable")")
    return 0
  fi

  ZDS=$ds debug Plugins: ${plugins}
  for plugin in $plugins; do 
    zplug $plugin
  done

  local ZPLUG_ARGS=""
  if [ ! -z $ZSH_DEBUG ]; then
    ZPLUG_ARGS="--verbose"
  fi

  ZDS=$ds debug Bootstrapping zplug
  if ! zplug check $ZPLUG_ARGS; then
    echo $(info New plugin configuration detected. Updating!)
    zplug install
  fi

  ZDS=$ds debug Loading zplug
  zplug load $ZPLUG_ARGS
}

