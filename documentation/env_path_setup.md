Create a file where you will store all your environment variables, named for example ~/.config/env_variables. In this file, add export lines, like this:

# This file is meant to compatible with multiple shells, including:
# bash, zsh and fish. For this reason, use this syntax:
#    export VARNAME=value

export EDITOR=vim
export LESS="-M"
export GOPATH="$HOME/.local/share/gopath/"
export PATH="$PATH:/custom/bin/"
In your ~/.config/fish/config.fish file, include:

source ~/.config/env_variables
In your ~/.bashrc file, include:

source ~/.config/env_variables