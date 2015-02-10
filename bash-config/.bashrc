#http://robertmuth.blogspot.co.uk/2012/08/better-bash-scripting-in-15-minutes.html

alias ll='ls -laFL'

alias gs='git status'
alias gc='git checkout'

# from http://stackoverflow.com/a/16710084
# ascii colours http://en.wikipedia.org/wiki/ANSI_escape_code#Colors
function gb() {
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
alias gll='git --no-pager  log --oneline  --pretty=format:"%C(bold cyan)%h%Creset -%C(bold yellow)%d%Creset %s %C(bold green)(%cr) %C(bold magenta)<%an>%Creset" -n 20'

# http://durdn.com/blog/2012/11/22/must-have-git-aliases-advanced-examples/
#alias gll='git --no-pager log --pretty=format:"%C(bold cyan)%h%C(bold yellow)%d - %Creset%s %C(bold green)(%cr)%Creset %C(bold magenta)<%cn>" --decorate --numstat -n 3'


alias dragon='/c/tools/gitscc/dragon.exe /c/git/4bim &'

alias cls='clear'

alias stageAllButConfig='git add --all && git reset -- *Web.config && gs'

alias gd='git difftool'
alias gds='git difftool --staged'
export PATH=$PATH:~/.local/bin/
alias goto=". goto"
