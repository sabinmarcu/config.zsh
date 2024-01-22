ZDS=$0 debug "Attempting TMUX init"

if [[ $TERM_PROGRAM == "vscode" ]]; then
  export ZSH_NO_TMUX=true
fi

if [ -z $ZSH_NO_TMUX ]; then 
  ZDS=$0 debug "TMUX opt-out not found"
  if [ -z $NVIM ]; then 
    ZDS=$0 debug "Not in NVIM"
    if [ -z $TMUX ]; then
      ZDS=$0 debug "Also not in a session"
      tmux attach || tmux
    fi
  fi
fi
