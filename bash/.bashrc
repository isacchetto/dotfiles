# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

echo ".bashrc execution starts.."

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=10000

# append to the history file, don't overwrite it
shopt -s histappend
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# matches filenames in a case-insensitive
shopt -s nocaseglob
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
# shopt -s globstar

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

# git function (used in the prompt below)
git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# TERMINAL PROMPT
# Format: user@host:~/path
PS1="\[\e[1;31m\]\u\[\e[m\]"                 # username
PS1+="\[\e[1;35m\]@\h\[\e[m\]"               # hostname
PS1+=":"
PS1+="\[\e[1;93m\]\w\[\e[m\]"                # full working dir
# PS1+="\[\e[0;92m\]\$(git_branch)\[\e[m\]"    # current branch (optional)
PS1+=" % "                                   # end prompt (keeps a space after %)
export PS1;

# enable color support
export CLICOLOR=1
export LSCOLORS=fxexgxgxcxegegxcxcxfxf
eval "$(dircolors)"

# Conda
# my_conda

# Auto-completion based on history, on up and down arrows
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Stderr in red
# exec 2> >(while read line; do echo -e "\e[01;31m$line\e[0m" >&2; done)
# command 2> >(sed $'s,.*,\e[31m&\e[m,'>&2)
# command 2> >(while read line; do echo -e "\e[01;31m$line\e[0m" >&2; done)
# command 2> >(xargs -0 printf "\e[31m%s\e[m" >&2)

# ALIASES
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

echo ".bashrc execution stops.."
