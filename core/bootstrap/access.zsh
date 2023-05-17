function access {
  local result=""
  for k v (${(Pkv)${1}}) [[ $k == $2 ]] && result=$v
  if [[ "$result" != "" ]]; then
    echo $result
    return 0
  fi
  return 1
}
