# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac
# Check root
if [ `id -nu` == "root" ]; then 
    IS_ROOT="true"
fi

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


# Prefer US English and use UTF-8
export LC_ALL="en_US.UTF-8"
export LANG="en_US"

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "*"
}

function env_set {
  if [ -z "$ENV" ]; then
    echo ""
    else
    echo "($ENV)"
  fi
}

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}

RED="\[\e[0;31m\]"
GRAY="\[\e[0;37m\]"
YELLOW="\[\e[0;33m\]"
BLUE="\[\e[0;34m\]"
GREEN="\[\e[0;32m\]"
WHITE="\[\e[1;37m\]"
LIGHT_GREEN="\[\e[1;32m\]"
TXTRST='\[\e[0m\]'

export CLICOLOR=1
# export LSCOLORS=ExFxCxDxBxegedabagacad
# git is extremely slow on shared folder, disable for now
#export PS1="[$GREEN\t \u@\h:$YELLOW\w$TXTRST]$RED\$(parse_git_branch)$TXTRST\$(env_set) $ \[\e[m\]"
if [ ! -z "$IS_ROOT" ]; then
    export PS1="[$RED\t \u@\h:$YELLOW\w$TXTRST]\$(env_set) # \[\e[m\]"
else
    export PS1="[$GREEN\t \u@\h:$YELLOW\w$TXTRST]\$(env_set) $ \[\e[m\]"        
fi

export EDITOR=/usr/bin/vim

# timestamps for bash history. www.debian-administration.org/users/rossen/weblog/1
# saved for later analysis

export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups
# export HISTIGNORE="ls:ls *:cd:cd -:pwd;exit:date:* --help"
HISTTIMEFORMAT='%F %T '
export HISTTIMEFORMAT

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export PHP_IDE_CONFIG="serverName=CLI"