ZDS=$0 debug Loading shell defaults

# ZDS=$0 debug Setting VI mode
# set -o vi

ZDS=$0 debug Setting sensible pbcopy
if [[ ! $(command -v pbcopy) && $(command -v xclip) ]]; then
  alias pbcopy="xclip -sel clip"
fi
if [[ ! $(command -v pbcopy) && $(command -v xsel) ]]; then
  alias pbcopy="xsel --clipboard --input"
fi

ZDS=$0 debug Setting GPG_TTY
export GPG_TTY=$(tty)

ZDS=$0 debug Exporting LC/LANG 
export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
