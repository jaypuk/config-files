#https://twitter.com/michaelhoffman/status/639178145673932800
HISTFILE="${HOME}/.history/$(date -u +%Y-%m-%d)_${HOSTNAME_SHORT}_$$"
touch ${HISTFILE}

get_hash() {
    git rev-parse --short HEAD 2>/dev/null
}

get_email() {
    E=$(git config user.email)
    if [ $E != "jayesh.patel@viewpoint.com" ]; then
        echo $E
    fi
}

# http://stackoverflow.com/a/3278427
branch_status() {
    local repo=$(git rev-parse --show-toplevel 2> /dev/null)

    if [[ ! -e "$repo" ]]; then
        echo ""
    else
        LOCAL=$(git rev-parse @)
        REMOTE=$(git rev-parse @{u} 2> /dev/null)
        BASE=$(git merge-base @ @{u} 2> /dev/null)

        if [ -z $REMOTE ]; then
            echo " NO REMOTE"
        elif [ $LOCAL = $REMOTE ]; then
            echo "" #"Up-to-date"
        elif [ $LOCAL = $BASE ]; then
            echo " PULL"
        elif [ $REMOTE = $BASE ]; then
            echo " PUSH"
        else
            echo " Diverged"
        fi
    fi
}

# ansi colors codes =>    http://bluesock.org/~willg/dev/ansi.html

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
        PS1="$PS1"'[`get_hash`'
        PS1="$PS1"'\[\033[35m\]'   # change to cyan
        PS1="$PS1"'`branch_status`'
        PS1="$PS1"'\[\033[32m\]'   # change to green
        PS1="$PS1"'] '
        PS1="$PS1"'`get_email` ' # email
	fi
fi
PS1="$PS1"'\[\033[0m\]'        # reset color
PS1="$PS1"'\n'                 # new line
PS1="$PS1"'\[\033[33m\]'       # change to brownish yellow
PS1="$PS1"'\t$ '                 # prompt: HH:MM:SS followed by $
PS1="$PS1"'\[\033[0m\]'        # reset color

# http://bneijt.nl/blog/post/add-a-timestamp-to-your-bash-prompt/

#http://robertmuth.blogspot.co.uk/2012/08/better-bash-scripting-in-15-minutes.html

alias ll='ls -laFhs'

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
alias gl='git --no-pager log --pretty=format:"%C(bold cyan)%h%Creset%C(bold yellow)%d%Creset %s %C(bold green)%cr %C(bold magenta)%an%Creset" --abbrev-commit --graph -n 20'
alias gll='git --no-pager  log --oneline  --pretty=format:"%C(bold cyan)%h%Creset%C(bold yellow)%d%Creset %s %C(bold green)%cr %C(bold magenta)%an%Creset" -n 20'

# http://durdn.com/blog/2012/11/22/must-have-git-aliases-advanced-examples/
#alias gll='git --no-pager log --pretty=format:"%C(bold cyan)%h%C(bold yellow)%d - %Creset%s %C(bold green)(%cr)%Creset %C(bold magenta)<%cn>" --decorate --numstat -n 3'


#alias dragon='/c/tools/gitscc/dragon.exe /c/git/4bim &'
alias dragon='/c/Program\ Files\ \(x86\)/Git/bin/dragon.exe /c/git/Engineering &'
alias cls='clear'

alias stageAllButConfig='git add --all && git reset -- "Hexagon3.5 Optimized/ASP.NET/WebApplication/Web.config" && gs'

alias gd='git difftool --dir-diff'
alias gds='git difftool --staged --dir-diff'
export PATH=$PATH:~/.local/bin/

alias np="/C/Program\ Files/Notepad++/notepad++.exe "

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

gitbranchremote() {
    if [ $# -ge 1 ]
    then
        git branch -r | grep -i $1
    else
        git branch -r
    fi
}
alias gbr='gitbranchremote'
alias gensvg='git graphviz  | dot -Tsvg -o $(date +%F_%H%M).svg'

alias prune='git remote prune $(git remote)'

alias gb='printf "\n" && echo $(date) - use glo/gdo aliases && printf "\n" && git branch -vv'

alias nuke='((git rm .gitattributes && git add -A) && git reset --hard) && git status'
alias gf='git fetch'

alias db='grep --color -H "Initial Catalog=[^;]*;" Hexagon3.5\ Optimized/ASP.NET/WebApplication/Web.config'
alias fixdb="echo --Before-- && db && sed 's/Initial Catalog=[^;]*;/Initial Catalog=4Projects_3G_T2T;/g' Hexagon3.5\ Optimized/ASP.NET/WebApplication/Web.config > web.config.tmp && mv web.config.tmp Hexagon3.5\ Optimized/ASP.NET/WebApplication/Web.config && echo --After-- && db"

alias bc="'c:/Program Files (x86)/Beyond Compare 3/bcompare.exe'"

#"cygpath '$@' | xargs -I jayp gitk --all 'jayp'"
myBlame() {
#    cygpath \'$1\' | xargs -I jayp gitk --all \'jayp\'
    cygpath '\"$@\"' | xargs -t --replace=jayp echo \'jayp\'
}
alias blame=myBlame

alias reload="date && . ~/.bashrc"

#http://askubuntu.com/questions/27314/script-to-display-all-terminal-colors#comment1045362_279014
alias colours='for x in 0 1 4 5 7 8; do for i in {30..37}; do for a in {40..47}; do echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "; done; echo; done; done; echo "";'

alias pass='grep connectionString ./Source/DocControlApi/DocControl.Api/Web.config'

# get commits between current branch and remote
alias glo='gll ..$(git remote)/$(git rev-parse --abbrev-ref HEAD) -n 1000'
alias gdo='gd ..$(git remote)/$(git rev-parse --abbrev-ref HEAD) &'

# find common ancestor commit of two branches https://stackoverflow.com/a/1549155/4686102
alias common='git merge-base'

#https://github.com/raylee/tldr
alias tldr='~/bin/tldr'

# connect to ubuntu 16.04 server on azure
alias ssh_az='ssh -i /j/.ssh/dtjayeshpatel_rsa  jay@13.95.192.250'
alias sftp_az='sftp -i /j/.ssh/dtjayeshpatel_rsa  jay@13.95.192.250'


# connect to ubuntu server at home
alias ssh_home='ssh -i /j/.ssh/dtjayeshpatel_rsa  jay@jvpatel.ddns.net -p 2123'
alias sftp_home='sftp -i /j/.ssh/dtjayeshpatel_rsa  -P 2123 jay@jvpatel.ddns.net'

#connect to ubuntu vm on dtjaypatel
alias ssh_dtjaypatel='ssh -i /j/.ssh/dtjayeshpatel_rsa  jay@172.30.240.222'
alias sftp_dtjaypatel='sftp -i /j/.ssh/dtjayeshpatel_rsa  jay@172.30.240.222'

# rename conemu tab name
alias name='/c/Program\ Files/ConEmu/ConEmu/RenameTab.cmd $1'

historysearch() {
    if [ $# -ge 1 ]
    then
        history | grep -i $1
    else
        history
    fi
}
alias h='historysearch'

#flush history immediately http://www.aloop.org/2012/01/19/flush-commands-to-bash-history-immediately/
export PROMPT_COMMAND='history -a'

alias nunithtmlreportgenerator="/c/git/NUnit-HTML-Report-Generator/NUnit\ HTML\ Report\ Generator/bin/Debug/NUnitHTMLReportGenerator.exe"

