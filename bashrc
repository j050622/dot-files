# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

PS1='\[\033[01;32m\]\u\[\033[01;34m\]@\[\033[01;31m\]\h\[\033[00;34m\]{\[\033[01;34m\]\w\[\033[00;34m\]}\[\033[01;32m\]\$ \[\033[00m\]'
# If not running interactively, don't do anything
#[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

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

#if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi
unset color_prompt force_color_prompt

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# some more ls aliases
alias ll='ls -hl --color=auto'
alias ls='ls --color=auto'
alias la='ls -ahl --color=auto'
alias l='ls -hCF'
alias rm='rm -i'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ps="ps aux"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# global
#export EDITOR="vim"
#set -o vi
#alias ls='ls --color=auto'
#alias ll='ls -hl --color=auto'
#alias rm='rm -i'
#[[ -s ~/.autojump/etc/profile.d/autojump.bash ]] \
#    && . ~/.autojump/etc/profile.d/autojump.bash
