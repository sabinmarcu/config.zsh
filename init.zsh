if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

local SOURCE_PATH=${(%):-%N} || $0
local SCRIPT_PATH=$(cd -- "$(dirname -- "$(readlink -f "${SOURCE_PATH}" || ${SOURCE_PATH})" )" &> /dev/null && pwd)

# export ZSH_DEBUG=true
export ZSH_CUSTOM=$SCRIPT_PATH

source $ZSH_CUSTOM/core/init.zsh

plugins=()

import tools
import config

_runPlugins

import config.post

_cleanupImportCache
_runCleanup
