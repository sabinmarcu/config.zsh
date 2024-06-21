alias gopen="git remote -v | sed 's/\t/ /g' | cut -d ' ' -f2 | uniq | sed 's/:/\//' | sed 's/^git@/https:\/\//' | sed 's/.git$//' | xargs -n1 open"
