alias g='git status'
alias gco='git checkout'
alias gf='git fetch'
alias gb='git branch'
alias gd='git diff'
alias gcp='git cherry-pick'

complete -o default -o nospace -F _git_status g
complete -o default -o nospace -F _git_checkout gco
complete -o default -o nospace -F _git_fetch gf
complete -o default -o nospace -F _git_branch gb
complete -o default -o nospace -F _git_diff gd
complete -o default -o nospace -F _git_cherry_pick gcp

alias ant='ant -logger org.apache.tools.ant.listener.AnsiColorLogger'
export ANT_OPTS=-Dant.logger.defaults=/home/jwarner/.ant_settings

alias ll='ls -l'

alias e='emacs -nw'
alias short='export PS1="\w$ "'

function dup () {
  local path=$1
  local new=$2

  cp "${path}" $(dirname ${path})/${new}
}
