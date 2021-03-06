# https://zwischenzugs.com/2019/04/03/eight-obscure-bash-options-you-might-want-to-know-about/
shopt -s histverify
#https://zwischenzugs.com/2019/05/11/seven-surprising-bash-variables/
HISTTIMEFORMAT='%Y-%m-%dT%H:%M:%SZ '
HISTDIR="${HOME}/.history"
if [ ! -d ${HISTDIR} ]; then mkdir ${HISTDIR}; fi
#https://twitter.com/michaelhoffman/status/639178145673932800
HISTFILE="${HISTDIR}/$(date -u +%Y-%m-%d)_${HOSTNAME_SHORT}_$$"
touch ${HISTFILE}

# https://stackoverflow.com/a/46359132 https://geoff.greer.fm/lscolors/
export LSCOLORS="exfxcxdxgxegedabagacad"

get_hash() {
    git rev-parse --short HEAD 2>/dev/null
}

get_email() {
    E=$(git config user.email)
    if [ $E != "jayesh.patel@sage.com" ]; then
        echo $E
    fi
}

git_root() {
    local repo=$(git rev-parse --show-toplevel 2> /dev/null)

    if [[ ! -e "$repo" ]]; then
        echo $(pwd)
    else
        echo $(basename `git rev-parse --show-toplevel`)
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

any_local_changes() {
    local repo=$(git rev-parse --show-toplevel 2> /dev/null)

    if [[ ! -e "$repo" ]]; then
        echo ""
    else
        if [[ `git status --porcelain` ]]; then
            echo  " ** DIRTY **"
        else
            echo ""
        fi
    fi
}

# ansi colors codes =>    http://bluesock.org/~willg/dev/ansi.html

PS1='\[\033]0;`git_root`\007\]' # set window title
#PS1='\[\033]0;$MSYSTEM:${PWD//[^[:ascii:]]/?}\007\]' # set window title
PS1="$PS1"'\n'                 # new line
#PS1="$PS1"'\[\033[32m\]'       # change to green
#PS1="$PS1"'\u@\h '             # user@host<space>
#PS1="$PS1"'\[\033[35m\]'       # change to purple
#PS1="$PS1"'$MSYSTEM '          # show MSYSTEM
PS1="$PS1"'\[\033[33m\]'       # change to brownish yellow
PS1="$PS1"'\w'                 # current working directory
#if test -z "$WINELOADERNOEXEC"
#then
#	GIT_EXEC_PATH="$(git --exec-path 2>/dev/null)"
#	COMPLETION_PATH="${GIT_EXEC_PATH%/libexec/git-core}"
#	COMPLETION_PATH="${COMPLETION_PATH%/lib/git-core}"
#	COMPLETION_PATH="$COMPLETION_PATH/share/git/completion"
	COMPLETION_PATH="/usr/local/git/contrib/completion"
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
        PS1="$PS1"'`any_local_changes`'
        PS1="$PS1"'\[\033[32m\]'   # change to green
        PS1="$PS1"'] '
        PS1="$PS1"'`get_email` ' # email
	fi
#fi
PS1="$PS1"'\[\033[0m\]'        # reset color
PS1="$PS1"'\n'                 # new line
PS1="$PS1"'\[\033[33m\]'       # change to brownish yellow
PS1="$PS1"'\t$ '                 # prompt: HH:MM:SS followed by $
PS1="$PS1"'\[\033[0m\]'        # reset color

# http://bneijt.nl/blog/post/add-a-timestamp-to-your-bash-prompt/

#http://robertmuth.blogspot.co.uk/2012/08/better-bash-scripting-in-15-minutes.html

alias ll='ls -laFhG'
alias ls='ls -aFG'
alias ..='cd ..'
alias cd..='cd ..'
alias gs='git status'
alias clean_all='dotnet clean; git clean -fdX'
alias clean_and_build_all='dotnet clean; git clean -fdX;dotnet build'

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
#alias dragon='/c/Program\ Files\ \(x86\)/Git/bin/dragon.exe /c/git/Engineering &'
alias cls='clear'
alias size_tty='stty size'

tty_dimensions() {
  stty size | awk '{printf("%s x %s", $2, $1)}'
}

#alias stageAllButConfig='git add --all && git reset -- "Hexagon3.5 Optimized/ASP.NET/WebApplication/Web.config" && gs'

alias gd='git difftool --dir-diff'
alias gds='git difftool --staged --dir-diff'

# for tldr
export PATH=$PATH:~/bin/
complete -W "$(tldr 2>/dev/null --list)" tldr

#alias np="/C/Program\ Files/Notepad++/notepad++.exe "

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
#alias gensvg='git graphviz  | dot -Tsvg -o $(date +%F_%H%M).svg'

alias prune='git remote prune $(git remote)'

alias gb='printf "\n" && echo $(date) - use glo/gdo aliases && printf "\n" && git branch -vv'

#alias nuke='((git rm .gitattributes && git add -A) && git reset --hard) && git status'
alias gf='git fetch'

#alias db='grep --color -H "Initial Catalog=[^;]*;" Hexagon3.5\ Optimized/ASP.NET/WebApplication/Web.config'
#alias fixdb="echo --Before-- && db && sed 's/Initial Catalog=[^;]*;/Initial Catalog=4Projects_3G_T2T;/g' Hexagon3.5\ Optimized/ASP.NET/WebApplication/Web.config > web.config.tmp && mv web.config.tmp Hexagon3.5\ Optimized/ASP.NET/WebApplication/Web.config && echo --After-- && db"

#alias bc="'C:/Program Files/Beyond Compare 4/bcompare.exe'"

#"cygpath '$@' | xargs -I jayp gitk --all 'jayp'"
#myBlame() {
#    cygpath \'$1\' | xargs -I jayp gitk --all \'jayp\'
#    cygpath '\"$@\"' | xargs -t --replace=jayp echo \'jayp\'
#}
#alias blame=myBlame

#alias reload="date && . ~/.bashrc"
alias reload="date && . ~/.bash_profile"

#http://askubuntu.com/questions/27314/script-to-display-all-terminal-colors#comment1045362_279014
alias colours='for x in 0 1 4 5 7 8; do for i in {30..37}; do for a in {40..47}; do echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "; done; echo; done; done; echo "";'

# get commits between current branch and remote
alias glo='gll ..$(git remote)/$(git rev-parse --abbrev-ref HEAD) -n 1000'
alias gdo='git diff ..$(git remote)/$(git rev-parse --abbrev-ref HEAD) &'

# find common ancestor commit of two branches https://stackoverflow.com/a/1549155/4686102
alias common='git merge-base'

#https://github.com/raylee/tldr
alias tldr='~/bin/tldr'

# https://news.ycombinator.com/item?id=18903234
function cheat() {
      curl cht.sh/$1
}

# connect to ubuntu 18.04 server on azure
alias ssh_az='ssh -i ~/.ssh/az jay@13.95.192.250'
alias sftp_az='sftp -i ~/.ssh/az jay@13.95.192.250'


# connect to ubuntu server at home
alias ssh_home='ssh -i ~/.ssh/dtjayeshpatel_rsa  jay@jvpatel.ddns.net -p 2123'
alias sftp_home='sftp -i ~/.ssh/dtjayeshpatel_rsa  -P 2123 jay@jvpatel.ddns.net'

# rename conemu tab name
#alias name='/c/Program\ Files/ConEmu/ConEmu/RenameTab.cmd $1'

historysearch() {
    if [ $# -ge 1 ]
    then
        history | grep -i $1
    else
        history
    fi
}
alias h='historysearch'

historicalsearch() {
    if [ $# -ge 1 ]
    then
#        grep -i $1 ${HISTDIR}/*
        grep -i $1 ${HISTDIR}/* | cut -d':' -f2 | awk '!seen[$0]++'
    else
        echo "need a param"
    fi
}
alias hs='historicalsearch'

#flush history immediately http://www.aloop.org/2012/01/19/flush-commands-to-bash-history-immediately/
export PROMPT_COMMAND='history -a'

#alias nunithtmlreportgenerator="/c/git/NUnit-HTML-Report-Generator/NUnit\ HTML\ Report\ Generator/bin/Debug/NUnitHTMLReportGenerator.exe"

#alias ubuntu_version='lsb_release -a'

# # displays any screen sessions
#screen -ls

#alias screenls='screen -ls'
#alias attach='screen -R '
alias serverkey='ssh-keygen -E md5 -lf /etc/ssh/ssh_host_rsa_key.pub'
# alias sudo_update_all='sudo apt update && sudo apt upgrade -y'

#echo 'use screenls & attach, Ctrl-A Ctrl-D to detach'

#alias user_secrets="dotnet user-secrets -v list"
alias grep="grep --colour=auto "
#alias logs="cd '/c/Logs/4PErrorLog/localhost/WebApp/4Projects Ltd/4Projects 3G'"

#alias tree="echo 'Use treed or treef'"
#alias treed="cmd //c tree //a "
#alias treef="cmd //c tree //a //f "

#alias code="/c/Users/jayesh.patel/AppData/Local/Programs/Microsoft\ VS\ Code/Code.exe"
#alias mfa="echo S6LIEG6TIDZUV452 && wsl oathtool -b -w 2 --totp S6LIEG6TIDZUV452"
#alias redis-cli="wsl redis-cli -h 52.16.88.6 -p 6379 --verbose"

#alias mspec="/c/git/kyk_web/packages/Machine.Specifications.0.5.9/tools/mspec-clr4.exe"
#alias mspec2="/c/git/kyk_web/packages/Machine.Specifications.Runner.Console.1.0.0/tools/mspec-clr4.exe"

#alias mspec_run_tests="tail -n 1 ~/.bashrc"

#alias hosts="np /C/Windows/System32/Drivers/etc/hosts"

#alias d="docker"
alias dps="docker ps"
alias dcps="docker-compose ps"
#alias da="docker attach"


alias devimg="echo docker run -it --rm --name dev -v $PWD:/usr/src/app -v ~/.ssh/id_rsa:/root/.ssh/id_rsa:ro -v ~/bundle-cache:/usr/local/bundle -v ~/.bashrc:/root/.bashrc:ro devimg"

docker_kill_all() { echo docker kill --signal KILL \$\(docker ps -aq\); docker kill --signal KILL $(docker ps -aq); }
docker_stop_all() { echo docker stop --time 10 \$\(docker ps -q\); docker stop --time 10 $(docker ps -q); }
docker_remove_all_containers() { echo docker rm \$\(docker ps -a -q\); docker rm $(docker ps -a -q); }
docker_remove_all_images() { echo docker rmi \$\(docker images -q\); docker rmi $(docker images -q); }
docker_prune_all_volumes() { echo docker volume rm \$\(docker volume ls -q  \| grep -v portainer_data\); docker volume rm $(docker volume ls -q  | grep -v portainer_data); }
#docker_nuke_all() { docker_stop_all; docker_remove_all_containers; docker_remove_all_images; docker_prune_all_volumes; }
docker_nuke_all() { docker_stop_all; docker_remove_all_containers; docker_prune_all_volumes; }
alias dna="docker_nuke_all"

#alias docker_prune_volumes="echo docker system prune -f --volumes"
alias portainer="docker run -d  -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer"
alias plantuml_start="docker run -d -p 8888:8080 plantuml/plantuml-server"
alias up_and_watch="docker-compose up -d && watch -n 2 docker-compose ps"
alias seq="docker run -d --restart unless-stopped --name seq -e ACCEPT_EULA=Y -p 9001:80 datalust/seq:latest"
alias chrome="/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome"
alias ss="stty sane"

# port_in_use() {
#     if [ $# -ge 1 ]
#     then
#         lsof -nP -iTCP:\$\1 | grep LISTEN;
#     else
#         lsof -nP -iTCP | grep LISTEN;
#     fi
# }

command_exists() {
    command -v "$1" &> /dev/null;
}


#if [ -d ~/dev/ ]; then cd ~/dev/; fi

# leave following as last line
# mspec/mspec2 -t --html ./kykloud.Tests_$(date -u +%Y-%m-%d_%H%M).html --xml ./kykloud.Tests_$(date -u +%Y-%m-%d_%H%M).xml /c/git/kyk_web/kykloud.Tests/bin/Debug/kykloud.Tests.dll -i "tests"

LESSPIPE=`which src-hilite-lesspipe.sh`
export LESSOPEN="| ${LESSPIPE} %s"
export LESS=' -R -X -F '

# https://www.topbug.net/blog/2016/09/27/make-gnu-less-more-powerful/
# Set colors for less. Borrowed from https://wiki.archlinux.org/index.php/Color_output_in_console#less .
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline


source /Users/jayesh.patel/Library/Preferences/org.dystroy.broot/launcher/bash/br
