tools+=(
  yazi yazi
  ffmpegthumbnailer ffmpegthumbnailer
  jq jq
  fd fd
  pdfinfo poppler
  rg ripgrep
  fzf fzf
  zoxide zoxide
  magick imagemagick
  xsel xsel
)

if command -v pacman &> /dev/null; then
  tools+=(7z p7zip)
fi

if [ $ZSH_PLATFORM = 'macos' ]; then
  tools+=(7zz sevenzip)
fi
