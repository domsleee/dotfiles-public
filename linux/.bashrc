alias l='exa --all --group-directories-first --icons'
alias ll='l --long --git --header'
alias cd=z
alias gl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gaa='git add -A'
alias gco='git checkout'
alias gp='git push'
alias gc='git commit'
export STARSHIP_CONFIG="$HOME/git/dotfiles/linux/starship.toml"

function mr() {
    prog=$1
    shift
    make $prog -j && $prog "$@"
}
# . "$HOME/.cargo/env"
shell=bash
unamestr=$(uname)
if [[ "$unamestr" == 'Darwin' ]]; then
    shell=zsh
fi

eval "$(zoxide init $shell)"
eval "$(starship init $shell)"
