plugins+=(
  "willghatch/zsh-saneopt"
  "akash329d/zsh-alias-finder"
  "wfxr/forgit kind:defer"
  "MichaelAquilina/zsh-auto-notify"
  "hlissner/zsh-autopair"
  "zsh-users/zsh-autosuggestions"
  "zsh-users/zsh-syntax-highlighting"
  "fdellwing/zsh-bat kind:defer"
  "zpm-zsh/colorize"
  "unixorn/fzf-zsh-plugin"
  "aeons/omz-git"
  "wfxr/emoji-cli"
  "reegnz/jq-zsh-plugin kind:defer"
  "mdumitru/last-working-dir"
  "joshskidmore/zsh-fzf-history-search"
  "redxtech/zsh-show-path kind:defer"
  "trystan2k/zsh-tab-title kind:defer"
  "jeffreytse/zsh-vi-mode"
  "Aloxaf/fzf-tab"
  "cowboyd/zsh-volta"
  "romkatv/powerlevel10k"
  "ptavares/zsh-direnv"
)

if command -v pacman &> /dev/null; then
  ZDS=$0 debug "Detected ArchLinux. Adding extra plugins"
  plugins+=(redxtech/zsh-aur-install)
fi

if ! [ -z $CODESTATS_API_KEY ]; then
  ZDS=$0 debug "Detected CodeStats key. Adding plugin"
  plugins+=(
    'https://gitlab.com/code-stats/code-stats-zsh.git path:codestats.plugin.zsh'
  )
fi

if [ -f $HOME/.wakatime.cfg ]; then
  ZDS=$0 debug "Detected wakastats. Adding plugin"
  plugins+=(
    'sobolevn/wakatime-zsh-plugin'
  )
fi

if ! command -v zoxide &> /dev/null; then
  plugins+=(  
    "changyuheng/fz kind:defer"
    "rupa/z path:z.sh"
  )
fi

# if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
#   ZDS=$0 debug "Detected iTerm. Adding plugin"
#   plugins+=(
#     "laggardkernel/zsh-iterm2"
#   )
# fi
