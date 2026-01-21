# Proto Config
export PROTO_HOME="$HOME/.proto";
export PATH="$PROTO_HOME/shims:$PROTO_HOME/bin:$PATH";

export __ORIG_PATH="$PATH"

_proto_activate_hook() {
  trap '' SIGINT
  output=$(proto activate zsh --export)
  if [ -n "$output" ]; then
    eval "$output";
  fi
  trap - SIGINT
}

typeset -ag chpwd_functions
if (( ! ${chpwd_functions[(I)_proto_activate_hook]} )); then
  chpwd_functions=(_proto_activate_hook $chpwd_functions)
fi

_proto_activate_hook

# Auto-install config
export PROTO_AUTO_INSTALL=true

# Install Proto if it doesn't exist
if ! command -v proto &> /dev/null; then
  ZDS=$0 debug "Proto not found. Installing"
  bash <(curl -fsSL https://moonrepo.dev/install/proto.sh) --yes --no-profile
fi

# Install some defaults
if $(shouldUpdate); then
  ZDS=$0 debug Installing nodejs
  proto install node ${PPROTO_DEFAULT_VERSION_NODE:-latest}
  
  ZDS=$0 debug Installing yarn
  proto install yarn ${PPROTO_DEFAULT_VERSION_YARN:-latest}

  ZDS=$0 debug Setting up proto
  proto setup
fi

# Go paths
if ! [ -z $GOBIN ]; then
  export PATH="$PATH:$GOBIN"
  export PATH="$PATH:$GOBIN/bin"
  export PATH="$PATH:$HOME/go/bin"
fi

if ! [ -z $GOPATH ]; then
  export PATH="$PATH:$GOPATH/bin"
fi

# Node paths
export PATH="$PATH:$HOME/.proto/tools/node/globals/bin"

# Python (experimental)
export PATH="$PATH:$HOME/.local/bin"

# Bun
export PATH="$PATH:$HOME/.bun/bin"

# Deno
if ! [ -z $DENO_INSTALL_ROOT ]; then
  export PATH="$PATH:$DENO_INSTALL_ROOT/bin"
fi
if ! [ -z $DENO_HOME ]; then
  export PATH="$PATH:$DENO_HOME/bin"
fi
export PATH="$PATH:$HOME/.deno/bin"
