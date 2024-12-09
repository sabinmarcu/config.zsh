if command -v pacman &> /dev/null; then
  tools+=(sesh sesh)
fi

if [ $ZSH_PLATFORM = 'macos' ]; then
  tools+=(sesh joshmedeski/sesh/sesh)
fi
