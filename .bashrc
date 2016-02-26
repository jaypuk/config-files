#https://twitter.com/michaelhoffman/status/639178145673932800
HISTFILE="${HOME}/.history/$(date -u +%Y/%m/%d.%H.%M.%S)_${HOSTNAME_SHORT}_$$"

get_hash() {
    git rev-parse --short HEAD 2>/dev/null
}

PS1='\[\033]0;$MSYSTEM:${PWD//[^[:ascii:]]/?}\007\]' # set window title
PS1="$PS1"'\n'                 # new line
#PS1="$PS1"'\[\033[32m\]'       # change to green
#PS1="$PS1"'\u@\h '             # user@host<space>
#PS1="$PS1"'\[\033[35m\]'       # change to purple
#PS1="$PS1"'$MSYSTEM '          # show MSYSTEM
PS1="$PS1"'\[\033[33m\]'       # change to brownish yellow
PS1="$PS1"'\w'                 # current working directory
if test -z "$WINELOADERNOEXEC"
then
	GIT_EXEC_PATH="$(git --exec-path 2>/dev/null)"
	COMPLETION_PATH="${GIT_EXEC_PATH%/libexec/git-core}"
	COMPLETION_PATH="${COMPLETION_PATH%/lib/git-core}"
	COMPLETION_PATH="$COMPLETION_PATH/share/git/completion"
	if test -f "$COMPLETION_PATH/git-prompt.sh"
	then
		. "$COMPLETION_PATH/git-completion.bash"
		. "$COMPLETION_PATH/git-prompt.sh"
		PS1="$PS1"'\[\033[36m\]'  # change color to cyan
		PS1="$PS1"'`__git_ps1` '   # bash function
        PS1="$PS1"'\[\033[32m\]'   # change to green
        PS1="$PS1"'[`get_hash`] '   # bash function
	fi
fi
PS1="$PS1"'\[\033[0m\]'        # change color
PS1="$PS1"'\n'                 # new line
PS1="$PS1"'$ '                 # prompt: always $

#http://robertmuth.blogspot.co.uk/2012/08/better-bash-scripting-in-15-minutes.html

alias ll='ls -laFL'

alias gs='git status'
alias gc='git checkout'

# from http://stackoverflow.com/a/16710084
# ascii colours http://en.wikipedia.org/wiki/ANSI_escape_code#Colors
# Git Branch with Description
function gbd() {
  branches=$(git for-each-ref --format='%(refname)' refs/heads/ | sed 's|refs/heads/||')
  for branch in $branches; do
    desc=$(git config branch.$branch.description)
    if [ $branch == $(git rev-parse --abbrev-ref HEAD) ]; then
      branch="* \033[1;32m$branch\033[0m"
     else
       branch="  $branch"
     fi
     echo -e "$branch : \033[1;36m$desc\033[0m"
  done
#  echo -e "  \033[1;31mtfs/Default\033[0m : \033[1;30mHidden branch used by git-tfs\033[0m"
}

# from https://coderwall.com/p/euwpig
# see http://stackoverflow.com/a/15458378 for colour opts
alias gl='git --no-pager log --pretty=format:"%C(bold cyan)%h%Creset -%C(bold yellow)%d%Creset %s %C(bold green)(%cr) %C(bold magenta)<%an>%Creset" --abbrev-commit --graph -n 20'
alias gll='git --no-pager  log --oneline  --pretty=format:"%C(bold cyan)%h%Creset -%C(bold yellow)%d%Creset %s %C(bold green)(%cr) %C(bold magenta)<%an>%Creset" -n 15'

# http://durdn.com/blog/2012/11/22/must-have-git-aliases-advanced-examples/
#alias gll='git --no-pager log --pretty=format:"%C(bold cyan)%h%C(bold yellow)%d - %Creset%s %C(bold green)(%cr)%Creset %C(bold magenta)<%cn>" --decorate --numstat -n 3'


#alias dragon='/c/tools/gitscc/dragon.exe /c/git/4bim &'
alias dragon='/c/Program\ Files\ \(x86\)/Git/bin/dragon.exe /c/git/Engineering &'
alias cls='clear'

alias stageAllButConfig='git add --all && git reset -- "Hexagon3.5 Optimized/ASP.NET/WebApplication/Web.config" && gs'

alias gd='git difftool --dir-diff'
alias gds='git difftool --staged --dir-diff'
export PATH=$PATH:~/.local/bin/

alias np="/C/Program\ Files\ \(x86\)/Notepad++/notepad++.exe "

#
#http://www.subfocal.net/post/44278880990/stupid-bash-tricks-show-git-branch-in-your-window
#function git-title {
#   local title
#    if ! title="branch: `git rev-parse --abbrev-ref HEAD 2>/dev/null`"; then
#        # Not a git repository
#        title="`pwd`"
#    fi
#    echo -ne "\033]2;$title\007"
#}
#export PROMPT_COMMAND="git-title"
#

alias gensvg='git graphviz  | dot -Tsvg -o $(date +%F_%H%M).svg'

alias prune='git remote prune origin'

alias gb='git branch -vv'
alias gbr='git branch -r'
alias nuke='((git rm .gitattributes && git add -A) && git reset --hard) && git status'
alias gf='git fetch'

alias db='grep --color -H "Initial Catalog=[^;]*;" Hexagon3.5\ Optimized/ASP.NET/WebApplication/Web.config'
alias fixdb="echo --Before-- && db && sed 's/Initial Catalog=[^;]*;/Initial Catalog=4Projects_3G_T2T;/g' Hexagon3.5\ Optimized/ASP.NET/WebApplication/Web.config > web.config.tmp && mv web.config.tmp Hexagon3.5\ Optimized/ASP.NET/WebApplication/Web.config && echo --After-- && db"

alias bc="'c:/Program Files (x86)/Beyond Compare 3/bcompare.exe'"

#"cygpath '$@' | xargs -I jayp gitk --all 'jayp'"
myBlame() {
#    cygpath \'$1\' | xargs -I jayp gitk --all \'jayp\'
    cygpath $1 | xargs -t -I jayp echo \'jayp\'
}
alias blame=myBlame

alias reload="date && . ~/.bashrc"

