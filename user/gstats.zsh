function gstats() {
  git log --numstat --pretty="%H" --author="Sabin Marcu" ${1}..HEAD | awk 'NF==3 {plus+=$1; minus+=$2} END {printf("+%d, -%d\n", plus, minus)}'
}
