set -g -x PATH /usr/local/bin $HOME/bin $PATH
set -g -x LD_LIBRARY_PATH /usr/local/lib64/

source ~/.local/share/icons-in-terminal/icons.fish

alias cl='/opt/coreutils/bin/ls'
alias ll='ls -alhF'
alias la='ls -A'
alias l='ls -CF'
alias an='cd ~/code/ansible'
alias ad='cd ~/code/erezadmin'
alias hx='hexdump -C'
alias nv='cd ~/.config/nvim'
alias n='nvim'
alias nq='nvim-qt'
alias c='clear'
alias s='sudo'
alias venv='source ./venv/bin/activate.fish'

# Handle 'st' terminal from fish
if string match -q "st-*" "$TERM"
    set -e VTE_VERSION
end

# content has to be in .config/fish/config.fish
# if it does not exist, create the file
setenv SSH_ENV $HOME/.ssh/environment

function start_agent
    echo "Initializing new SSH agent ..."
    ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
    echo "succeeded"
    chmod 600 $SSH_ENV
    . $SSH_ENV > /dev/null
    ssh-add
end
#    ssh-add $HOME/.ssh/drodger_github_rsa 

function test_identities
    ssh-add -l | grep "The agent has no identities" > /dev/null
    if [ $status -eq 0 ]
        ssh-add
        if [ $status -eq 2 ]
            start_agent
        end
    end
end

if [ -n "$SSH_AGENT_PID" ]
    ps -ef | grep $SSH_AGENT_PID | grep ssh-agent > /dev/null
    if [ $status -eq 0 ]
        test_identities
    end
else
    if [ -f $SSH_ENV ]
        . $SSH_ENV > /dev/null
    end
    ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep ssh-agent > /dev/null
    if [ $status -eq 0 ]
        test_identities
    else
        start_agent
    end
end
