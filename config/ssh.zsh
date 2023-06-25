local ds=$(debugScope $0)
export SSH_ENV="$HOME/.ssh/agent-environment"

function start_agent {
    ZDS=$ds debug "Initialising new SSH agent..."
    $(which ssh-agent) | sed 's/^echo/#echo/' > "${SSH_ENV}"
    ZDS=$ds debug succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    $(which ssh-add);
}

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
