# If not running interactively, don"t do anything
[[ $- != *i* ]] && return

export STARSHIP_CONFIG=$HOME/.config/starship.toml
export STARSHIP_DISTRO="SKY "
eval "$(starship init bash)"

alias code="codium"
alias cls="clear"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f $HOME/.bash_aliases ]; then
    . $HOME/.bash_aliases
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

clear

neofetch
