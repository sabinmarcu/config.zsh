ZDS=$0 debug Selecting \$EDITOR

if command -v nvim &> /dev/null; then
  export EDITOR="nvim"
elif command -v vim &> /dev/null; then
  export EDITOR="vim"
elif command -v code &> /dev/null; then
  export EDITOR="code --wait"
else 
  export EDITOR='nano'
fi

ZDS=$0 debug \$EDITOR=$EDITOR

ZDS=$0 debug Setting edit commands

if command -v vim &> /dev/null; then
  alias vimconfig="$EDITOR ~/.vimrc"
fi

if command -v nvim &> /dev/null; then
    alias nvimconfig="$EDITOR ~/.config/nvim/lua/user"
fi
