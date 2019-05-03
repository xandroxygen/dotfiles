#!/usr/bin/env bash

# Lots of stuff taken from http://tldp.org/LDP/abs/html/sample-bashrc.html

# Colors
    restore='\033[0m'

    black='\033[0;30m'
    red='\033[0;31m'
    green='\033[0;32m'
    brown='\033[0;33m'
    blue='\033[0;34m'
    purple='\033[0;35m'
    cyan='\033[0;36m'
    light_gray='\033[0;37m'
    dark_gray='\033[1;30m'
    light_red='\033[1;31m'
    light_green='\033[1;32m'
    yellow='\033[1;33m'
    light_blue='\033[1;34m'
    light_purple='\033[1;35m'
    light_cyan='\033[1;36m'
    white='\033[1;37m'

    # LESS man page colors (makes Man pages more readable).
        export LESS_TERMCAP_mb=$'\E[01;31m'
        export LESS_TERMCAP_md=$'\E[01;31m'
        export LESS_TERMCAP_me=$'\E[0m'
        export LESS_TERMCAP_se=$'\E[0m'
        export LESS_TERMCAP_so=$'\E[01;44;33m'
        export LESS_TERMCAP_ue=$'\E[0m'
        export LESS_TERMCAP_us=$'\E[01;32m'

# Find a file with a pattern in name:
function ff() { find . -type f -iname '*'"$*"'*' -ls ; }

function vaulted_status() {
  if [[ -z "${VAULTED_ENV}" ]]; then
    echo -n ""
  else
    exp=$(date -j -f "%Y-%m-%dT%H:%M:%S%z" "${VAULTED_ENV_EXPIRATION/Z/+0000}" +%s)
    now=$(date +%s)
    rem=$(date -j -f "%s" "$(($exp - $now))" +%H:%M:%S)
    echo -n "${VAULTED_ENV} (${rem})"
  fi
}

# prompt / shell settings
    function set_prompt {
        GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null);
        GIT_COMMIT_HASH=$(git rev-parse --short=8 HEAD 2>/dev/null);
        if [[ -n "$GIT_BRANCH" ]]; then GIT_STATUS="$GIT_BRANCH: $GIT_COMMIT_HASH"; else GIT_STATUS=""; fi
        if [[ -n "$GIT_BRANCH" ]]
        then
            GIT_USER=$(git config --get user.email | cut -f1 -d@)
        else
            GIT_USER=""
        fi

        GIT_DIFF=""
        if [[ -n $(git diff HEAD 2>/dev/null) ]]; then GIT_DIFF="${GIT_DIFF}Δ"; else
            if [[ -n `git status -s 2>/dev/null` ]]; then GIT_DIFF="${GIT_DIFF}u"; fi
        fi
        if [[ -n "$GIT_DIFF" ]]; then GIT_DIFF=" ${GIT_DIFF}"; fi

        GIT_STATUS="\[$green\]$GIT_STATUS\[$light_green\]$GIT_DIFF \[$purple\]$GIT_USER"
        AWS_CREDS_STATUS="\[$white\]$(vaulted_status)"
        export PS1="\n\[$cyan\]\A \[$yellow\]\w $GIT_STATUS $AWS_CREDS_STATUS\[$restore\]\n\$ "
    }
    PROMPT_COMMAND=set_prompt

    export HISTCONTROL=ignoreboth
    # export HISTSIZE=10000

    alias l='command ls -GF'
    alias ls='command ls -GF'
    alias ll='command ls -GlhF'
    alias la='ll -A'
    alias tree='tree -Cf --matchdirs --ignore-case --dirsfirst'

    # Prevents accidentally clobbering files:
        alias rm='rm -i'
        alias cp='cp -i'
        alias mv='mv -i'

    alias mkdir='mkdir -p'
    alias rmdir='rmdir -p'
    alias ..='cd ..'

    alias path='echo -e ${PATH//:/\\n}'
    alias edit='code -w'

    alias du='du -kh' # Makes a more readable output.

    alias q="exit"
    alias g="git status -s"
    alias ga='git amend'
    alias gb='git branch -v'
    function gc() {
        if [[ -z $(git diff HEAD 2>/dev/null) ]]; then
            git checkout $@
        else
            echo "Can't git-checkout; branch is dirty:"
            # git diff HEAD --stat
            g
        fi
    }
    alias gnew='gc -b'
    alias gdel='gb -D'
    alias gd='git diff --find-renames' #--word-diff --ignore-space-change'
    alias gg='git graph'
    alias gl='git l'
    alias gll='git ll'
    alias gs='git show --find-renames'
    alias gu='git add -u && git status'
    alias gr='git rebase'
    alias gpush='git push origin HEAD:refs/for/master'
    alias gpull='git pull --rebase origin master'
    alias grebase='git checkout master && gpull && git checkout - && git rebase master'
    alias grim='git rebase -i master'
    alias gane='ga --no-edit'

    alias dc='docker-compose'
    alias dcr='dc run --rm'
    alias dce='dc exec'


    alias bashrc="edit ~/.bashrc \
                  && source ~/.bashrc \
                  && echo '~/.bashrc has been updated and re-sourced'"
    alias gitconfig="edit ~/.gitconfig"


echo "common.bashrc loaded"

export LSCOLORS="gxfxcxdxbxegedabagacad" # make directory names actually visible

export PATH="/Users/xmoffatt/miniconda3/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin:~/go/bin

# dinghy env vars
export DOCKER_HOST=tcp://192.168.64.3:2376
export DOCKER_CERT_PATH=/Users/xmoffatt/.docker/machine/machines/dinghy
export DOCKER_TLS_VERIFY=1
export DOCKER_MACHINE_NAME=dinghy

eval "$(rbenv init -)"
# Other relevant customizations are found in ~/.inputrc and ~/.profile

export VAULT_ADDR=https://vault.insops.net
vault-login() { vault login -method=ldap username=$(whoami) ; }
consul-role() {
    local new_token=$( vault read -field token consul/creds/"$1" )
    if [[ -n $new_token ]]; then
        export CONSUL_HTTP_TOKEN="$new_token"
        export CONSUL_HTTP_ADDR=api.consul.insops.net:443
        export CONSUL_HTTP_SSL=true
        export CONSUL_HTTP_SCHEME=https
    fi
}
