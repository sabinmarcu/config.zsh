ZDS=$0 debug "Attempting TMUX init"

if [[ $TERM_PROGRAM == "vscode" ]]; then
  export ZSH_NO_TMUX=true
fi

if [[ $TERM_PROGRAM == "Apple_Terminal" ]]; then
  export ZSH_NO_TMUX=true
fi

if [[ $TERM_PROGRAM == "WarpTerminal" ]]; then
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

alias tmux-kill-others="tmux list-sessions | cut -d: -f1 | grep -v \$(tmux display-message -p '#S') | xargs -n 1 tmux kill-session -t"
