local ds=$(debugScope $0)

export GCFP_COMMIT_TYPES=("feat" "fix" "chore")
if command -v gum &> /dev/null; then
  function gcfpc {
    # Decide on the type of conventional commig
    local TYPE=$(gum choose $GCFP_COMMIT_TYPES)

    # Detect scope from workspaces
    local SCOPE=""

    if command -v yarn &> /dev/null; then
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

    # Read summary and description
    SUMMARY=$(gum input --value "$TYPE$SCOPE: $TICKET" --placeholder "Summary of this change")
    DESCRIPTION=$(gum write --placeholder "Details of this change")

    # Commit these changes if user confirms
    gum confirm "Commit changes?" && echo -m "$SUMMARY" -m "$DESCRIPTION"
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

    # Read summary and description
    SUMMARY=$(gum input --value "$TICKET: " --placeholder "Summary of this change")
    DESCRIPTION=$(gum write --placeholder "Details of this change")

    # Commit these changes if user confirms
    gum confirm "Commit changes?" && echo -m "$SUMMARY" -m "$DESCRIPTION"
  }

  function gcfp {
    if $GCFP_USE_CONVENTIONAL; then
      gcfpc $@
    else
      gcfpj $@
    fi
  }
fi
