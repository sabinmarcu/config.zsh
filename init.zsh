if ! [ -z $ZSH_CUSTOM_UPDATE ]; then
  echo "\033[2;34m Updating plugins and tools\033[0m"
else
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
fi

local SOURCE_PATH=${(%):-%N} || $0
local SCRIPT_PATH=$(cd -- "$(dirname -- "$(readlink -f "${SOURCE_PATH}" || ${SOURCE_PATH})" )" &> /dev/null && pwd)

# export ZSH_DEBUG=true
export ZSH_CUSTOM=$SCRIPT_PATH

source $ZSH_CUSTOM/core/init.zsh

plugins=()
tools=()

import config.local.pre
import tools
import config
import config.local.post

_runPlugins
_runTools

import config.post

_cleanupImportCache
_runCleanup
