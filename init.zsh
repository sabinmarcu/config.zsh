local SOURCE_PATH=${(%):-%N} || $0
local SCRIPT_PATH=$(cd -- "$(dirname -- "$(readlink -f "${SOURCE_PATH}" || ${SOURCE_PATH})" )" &> /dev/null && pwd)

# export ZSH_DEBUG=true
export ZSH_CUSTOM=$SCRIPT_PATH

source $ZSH_CUSTOM/core/init.zsh

plugins=()

import tools
import config

_runPlugins
_runCleanup
