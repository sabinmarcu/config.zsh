_exa_ignore=(
  "*node_modules*"
)
function __exa_ignores {
  echo ${(j:|:)_exa_ignore}
}
export TIME_STYLE="${TIME_STYLE:-long-iso}"

alias ls="exa -Fgh --color-scale --git --group-directories-first --icons --ignore-glob=\"$(__exa_ignores)\""
alias l.='ls -d .*'
alias lD='ls -D'
alias lS='ls -1'

alias ll="ls -l"
alias la='ll -a'

alias lA='ll --sort=acc'
alias lC='ll --sort=cr'
alias lM='ll --sort=mod'
alias lS='ll --sort=size'
alias lX="ll --sort=ext"
alias llm='lM'

alias l='la -a'
alias lsa='l'
alias lx='l -HSUimu'
alias lxa='lx -@'

alias lt='ls -T --git-ignore'
alias tree='lt'    

alias lla="$original --color"
alias lll="lla -al"
