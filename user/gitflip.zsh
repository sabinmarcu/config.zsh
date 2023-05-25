function gitflip() {
  local currentOrigin=$(git remote -v | grep origin | awk '$1=$1' | cut -d " " -f2 | uniq)
  local shortHand=$(echo $currentOrigin | sed -E 's/.*(\/|:)([^\/]+\/[^\/]+).git$/\2/')
  local host=$(echo $currentOrigin | sed -E 's/(git@|https:\/\/)([^\/:]+)[\/:].*/\2/')
  local newOrigin
  if [ -n "$(echo $currentOrigin | grep https)" ]; then
    newOrigin="git@${host}:${shortHand}.git"
  else
    newOrigin="https://${host}/${shortHand}.git"
  fi
  info "Old origin: $(style_text dim -- $currentOrigin)"
  info "New origin: $(style_text bold -- $newOrigin)"
  if read -qs "?Change origin remote? "; then
    echo $REPLY
    git remote rm origin
    git remote add origin $newOrigin
    success Done!
  else 
    echo $REPLY
    warn Aborted
  fi
}

