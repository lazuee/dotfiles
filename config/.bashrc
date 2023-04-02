# If not running interactively, don"t do anything
[[ $- != *i* ]] && return

export STARSHIP_CONFIG=$HOME/.config/starship.toml
export STARSHIP_DISTRO="SKY "
eval "$(starship init bash)"

alias code="codium"
alias py="python"
alias cls="clear"

if [ -f $HOME/.bash_aliases ]; then
    . $HOME/.bash_aliases
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

clear

neofetch
