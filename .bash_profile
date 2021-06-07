[ -r ~/.bashrc ] && source ~/.bashrc
export PATH="/usr/local/opt/ruby/bin:$PATH"
eval "$(rbenv init -)"

export IGNOREEOF=5

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

alias jfrog="grep BUNDLE_SAGEONEGEMS__JFROG__IO ~/.bundle/config"

source /Users/jayesh.patel/Library/Preferences/org.dystroy.broot/launcher/bash/br

[ -r ~/.creds_do_not_share ] && source ~/.creds_do_not_share

export SBC_NUGET_DEBUG_REPOSITORY_PATH="/Users/jayesh.patel/dev/SBC_NUGET_DEBUG_REPOSITORY"

alias cdorg="pushd ~/dev/sbc.core.organisation.service_git"
alias cdac="pushd ~/dev/sbc.core.accesscontrol.service_git"
alias dev="pushd ~/dev"

aws_login
