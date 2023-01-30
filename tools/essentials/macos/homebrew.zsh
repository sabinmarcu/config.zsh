ZDS=$0 debug Ensuring homebrew is installed
if ! command -v brew &> /dev/null; then
  echo $(warn Homebrew not installed)
  # Official installation type
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$($(which brew) shellenv)"

