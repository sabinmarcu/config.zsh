if command -v proto &> /dev/null; then
  if $(shouldUpdate); then
    ZDS=$0 debug Installing nodejs
    proto install node@${PROTO_VERSION_NODE:-latest}
    
    ZDS=$0 debug Installind yarn
    proto install yarn@${PROTO_VERSION_YARN:-latest}

    ZDS=$0 debug Setting up proto
    proto setup
  fi
else
  ZDS=$0 debug "Proto not found. Installing"
  curl -fsSL https://moonrepo.dev/install/proto.sh | bash
fi


