[ -r ~/.bashrc ] && source ~/.bashrc
export PATH="/usr/local/opt/ruby/bin:$PATH"
eval "$(rbenv init -)"


test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

