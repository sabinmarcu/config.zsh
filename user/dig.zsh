function digme() {
  local domain=$1
  echo "Digging domain: $domain"
  echo "CAA:"
  dig -t CAA +noall +ans $domain 
  echo "Google:"
  dig @8.8.8.8 +short A $domain
  dig @8.8.8.8 +short CNAME www.$domain
  echo "CloudFlare:"
  dig @1.1.1.1 +short A $domain
  dig @1.1.1.1 +short CNAME www.$domain
}
