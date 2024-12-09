local ds=$(debugScope $0)

export GCFP_COMMIT_TYPES=("feat" "fix" "chore")
if command -v gum &> /dev/null; then
  function gcfpcommit {

    # Commit these changes if user confirms
    if ! [ -z $GCFP_ALL_FLAG ]; then
      gum confirm "Stage all and commit changes?" && git commit -a -m "$GCFP_SUMMARY" -m "$GCFP_DESCRIPTION"
    else
      gum confirm "Commit changes?" && git commit -m "$GCFP_SUMMARY" -m "$GCFP_DESCRIPTION"
    fi
  }

  function gcfpformat {
    # Read summary and description
    SUMMARY=$(gum input --value "$GCFP_PREFIX" --placeholder "Summary of this change")
    DESCRIPTION=$(gum write --placeholder "Details of this change")

    GCFP_SUMMARY="$SUMMARY" GCFP_DESCRIPTION="$DESCRIPTION" gcfpcommit
  }

  function gcfpc {
    # Decide on the type of conventional commig
    local TYPE=$(gum choose $GCFP_COMMIT_TYPES)

    # Detect scope from workspaces
    local SCOPE=""

    if command -v yarn &> /dev/null && command -v jq &> /dev/null; then
      if yarn --version | grep -E "1\.\d+\.\d+" &> /dev/null; then
        local workspaces=($(yarn workspaces info --json | tail -n+2 | ghead -n-1 | jq -r "keys[]"))
        SCOPE=$(gum choose $workspaces)
      else
        local workspaces=($(yarn workspaces list --json | jq -r ".name"))
        SCOPE=$(gum choose $workspaces)
      fi
    fi

    test -n "$SCOPE" && SCOPE="($SCOPE)"

    # Detect ticket number
    local TICKET=""
    if ! [ -z $GCFP_TICKET_PATTERN ] && command -v rg &> /dev/null; then
      TICKET=$(git branch | rg "[^\/]\/(${GCFP_TICKET_PATTERN})" -or '$1')
    fi

    test -n "$TICKET" && TICKET="$TICKET "

    GCFP_PREFIX="$TYPE$SCOPE: $TICKET" gcfpformat
  }

  function gcfpj {
    # Detect ticket number
    local TICKET=""
    if ! [ -z $GCFP_TICKET_PATTERN ] && command -v rg &> /dev/null; then
      TICKET=$(git branch | rg "[^\/]\/(${GCFP_TICKET_PATTERN})" -or '$1')
    fi

    if [ -z "$TICKET" ]; then
      TICKET=$(gum input --placeholder "Ticket number")
    fi

    GCFP_PREFIX="$TICKET: " gcfpformat
  }

  function gcfp {
    if ! [ -z $GCFP_USE_CONVENTIONAL ]; then
      gcfpc $@
    else
      gcfpj $@
    fi
  }

  function gcafp {
    GCFP_ALL_FLAG=true gcfp $@
  }
fi
