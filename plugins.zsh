plugins+=(
  "willghatch/zsh-saneopt"
  "akash329d/zsh-alias-finder"
  "wfxr/forgit, defer:1"
  "redxtech/zsh-asdf-direnv"
  "MichaelAquilina/zsh-auto-notify"
  "hlissner/zsh-autopair"
  "zsh-users/zsh-syntax-highlighting"
  "zsh-users/zsh-autosuggestions"
  "zsh-users/zsh-history-substring-search, defer:1"
  "fdellwing/zsh-bat"
  "zpm-zsh/colorize"
  "unixorn/fzf-zsh-plugin"
  "changyuheng/fz, defer:1"
  "rupa/z, use:z.sh"
  "mdumitru/git-aliases"
  "wfxr/emoji-cli"
  "reegnz/jq-zsh-plugin"
  "mdumitru/last-working-dir"
  "joshskidmore/zsh-fzf-history-search"
  "jimhester/per-directory-history"
  "redxtech/zsh-show-path"
  "trystan2k/zsh-tab-title"
  "jeffreytse/zsh-vi-mode"
)

if command -v pacman &> /dev/null; then
  ZDS=$0 debug "Detected ArchLinux. Adding extra plugins"
  plugins+=(redxtech/zsh-aur-install)
fi

if ! [ -z $CODESTATS_API_KEY ]; then
  ZDS=$0 debug "Detected CodeStats key. Adding plugin"
  plugins+=(
    'code-stats/code-stats-zsh, from:gitlab, use:"codestats.plugin.zsh"'
  )
fi

# if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
#   ZDS=$0 debug "Detected iTerm. Adding plugin"
#   plugins+=(
#     "laggardkernel/zsh-iterm2"
#   )
# fi
