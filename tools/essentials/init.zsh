local ds=$(debugScope $0)
ZDS=$0 debug Determining essentials for OS="$ZSH_PLATFORM"

if ESSENTIALS_PATH=$(resolve "tools.essentials.${ZSH_PLATFORM}"); then
  ZDS=$0 debug Loading essentials from $ESSENTIALS_PATH
  source $ESSENTIALS_PATH
else
  echo $(error "Couldn't find essentials for your OS")
fi

function _runTools {
  ZDS=$ds debug Looking for tools
  if PLUGINS_PATH=$(resolve presets.tools); then 
    ZDS=$ds debug Loading tools from $PLUGINS_PATH
    source $PLUGINS_PATH
  fi

  ZDS=$ds debug Ensuring essential tools
  for tool package in ${(@kv)tools}; do
    if $(shouldUpdate); then
      ZDS=$ds debug "Ensuring $(style_text orange underlined -- $tool) (package: $(style_text orange dim -- $package))"
      if ! command -v $tool &> /dev/null; then
        echo $(warn "Tool $(style_text underlined -- $tool) is not installed. Installing package $(style_text dim -- $package) to fix")
        omninstall $package
      fi
    fi
    if config=$(resolve "tools.essentials.config.${tool}"); then
      ZDS=$ds debug "Configuring $(style_text underlined -- $tool)"
      source $config
    fi
  done
}
_cleanup _runTools
