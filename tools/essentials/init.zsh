ZDS=$0 debug Determining essentials for OS="$ZSH_PLATFORM"

if ESSENTIALS_PATH=$(resolve "tools.essentials.${ZSH_PLATFORM}"); then
  ZDS=$0 debug Loading essentials from $ESSENTIALS_PATH
  source $ESSENTIALS_PATH
else
  echo $(error "Couldn't find essentials for your OS")
fi

essentials=(
  nvim nvim
  lazygit lazygit
  bat bat
  fzf fzf
  rg ripgrep
  delta git-delta
  exa exa
  fd fd
  jq jq
  starship starship
)
ZDS=$0 debug Ensuring the rest of dependencies
for tool package in ${(@kv)essentials}; do
  ZDS=$0 debug "Ensuring $(style_text orange underlined -- $tool) (package: $(style_text orange dim -- $package))"
  if ! command -v $tool &> /dev/null; then
    echo $(warn "Tool $(style_text underlined -- $tool) is not installed. Installing package $(style_text dim -- $package) to fix")
    omninstall $package
  fi
  if config=$(resolve "tools.essentials.config.${tool}"); then
    ZDS=$0 debug "Configuring $(style_text underlined -- $tool)"
    source $config
  fi
done
