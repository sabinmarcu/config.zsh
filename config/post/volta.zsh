if command -v volta &> /dev/null; then
  if $(shouldUpdate); then
    ZDS=$0 debug Installing nodejs
    volta install node@${VOLTA_VERSION_NODE:-latest}
    
    ZDS=$0 debug Installind yarn
    volta install yarn@${VOLTA_VERSION_YARN:-latest}

    ZDS=$0 debug Setting up volta
    volta setup
  fi
fi


