source ~/.bashrc

export EDITOR="code -w"
export PATH="$HOME/.cargo/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/xmoffatt/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/xmoffatt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/xmoffatt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/xmoffatt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

