# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export PATH=$PATH:/opt/apache-maven-3.0.3/bin/

COLOR_RED=$(tput setaf 1)
COLOR_GREEN=$(tput setaf 2)
COLOR_YELLOW=$(tput setaf 3)
COLOR_BLUE=$(tput setaf 4)
COLOR_PURPLE=$(tput setaf 5)
COLOR_TEAL=$(tput setaf 6)
COLOR_WHITE=$(tput setaf 7)
COLOR_BOLD=$(tput bold)
COLOR_UNDERLINE=$(tput smul)
COLOR_RESET=$(tput sgr0)

function color_dir() {
    local DIR=${PWD/#$HOME/~}
    local pwd_length=20
    
    if [[ $(echo -n $DIR | wc -c | tr -d " ") -gt ${pwd_length} ]]; then
        echo -n "..."
        DIR=$(echo -n ${DIR} | sed -e "s/.*\(.\{$pwd_length\}\)/\1/")
    fi

    local begin="\\\[${COLOR_BOLD}${COLOR_BLUE}${b}\\\]"
    local end="\\\[${COLOR_RESET}${COLOR_TEAL}\\\]"
    echo -n "\[${COLOR_TEAL}\]"
    echo -n $(echo $DIR | sed -e "s|/|${begin}/${end}|g")
    echo -n "\[${COLOR_RESET}\]"
}

function timer_start() {
    CMD_TIME=${CMD_TIME:-${SECONDS}}
}

function timer_stop() {
    LAST_CMD_TIME=$(($SECONDS - $CMD_TIME))
    unset CMD_TIME
}

trap 'timer_start' DEBUG

function fancy_prompt() {
    local RETVAL=$?
    timer_stop
    if [[ ${RETVAL} -ne 0 ]]; then
        echo -e "<${COLOR_RED}failed${COLOR_RESET}:${COLOR_YELLOW}${RETVAL}${COLOR_RESET}>"
    fi
    if [[ ${LAST_CMD_TIME} -gt 4 ]]; then
        echo -e "<${COLOR_PURPLE}time${COLOR_RESET}:${COLOR_YELLOW}${LAST_CMD_TIME}s${COLOR_RESET}>"
    fi
    export PS1="\[${COLOR_UNDERLINE}\]\h\[${COLOR_RESET}\]:$(color_dir)$ "
    history -a
}

PROMPT_COMMAND="fancy_prompt"
man $(ls /usr/bin | shuf -n 1)| sed -n "/^NAME/ { n;p;q }"
