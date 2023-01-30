local ANTIDOTE_INIT=$ANTIDOTE_HOME/antidote.zsh
local ds=$(debugScope $0)

ZDS=$ds debug Ensuring antidote is installed
if [ ! -f $ANTIDOTE_INIT ]; then
  echo $(warn Antidote not installed. Installing now!)
  git clone --depth=1 https://github.com/mattmc3/antidote.git $ANTIDOTE_HOME
fi

ZDS=$ds debug Loading Antidote
source ${ANTIDOTE_INIT}

function _runPlugins {
  local ZSH_PLUGINS=${ZDOTDIR:-$HOME}/.zsh_plugins.zsh
  local ZSH_PLUGINS_SRC=${ZSH_PLUGINS:r}.txt

  if $(shouldUpdate); then
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

    ZDS=$ds debug Ensuring plugins source file
    [[ -f $ZSH_PLUGINS_SRC ]] || touch $ZSH_PLUGINS_SRC

    ZDS=$ds debug Setting up antidote autoload
    fpath+=(${ZDOTDIR:-~}/.antidote)
    autoload -Uz $fpath[-1]/antidote

    ZDS=$ds debug Plugins: ${plugins}
    ZDS=$ds debug Removing old plugins
    echo "" > $ZSH_PLUGINS_SRC
    for plugin in $plugins; do 
      echo $plugin >> $ZSH_PLUGINS_SRC
    done
    
    ZDS=$ds debug Compiling plugins file
    if [[ ! $ZSH_PLUGINS -nt $ZSH_PLUGINS_SRC ]]; then
      (antidote bundle <$ZSH_PLUGINS_SRC >|$ZSH_PLUGINS)
    fi
  fi

  # Source your static plugins file.
  ZDS=$ds debug Loading Antidote Plugins
  source $ZSH_PLUGINS
}
_cleanup _runPlugins

