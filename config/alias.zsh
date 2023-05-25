ZDS=$0 debug Loading aliases

alias zshc="$EDITOR $ZSH_CONFIG"
alias zshcl="$EDITOR $ZSH_LOCAL"
alias zshr="source $ZSH_CONFIG"
alias zshconfig="$EDITOR $ZSH_CUSTOM"

alias lg="lazygit"
if command -v nvim &> /dev/null; then
  alias vimdiff="nvim -d"
fi
