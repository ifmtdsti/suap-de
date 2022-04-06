#
alias git-fetch-all-pull='git fetch --all --prune && git pull origin $(git branch | sed -n -e "s/^\* \(.*\)/\1/p")'
