# ALIASES

# Anaconda3
alias my_conda='source /shares/CIBIO-Storage/CM/scratch/users/isacco.cenacchi/tools/miniconda3/.conda'
alias lab_conda='source /shares/CIBIO-Storage/CM/scratch/tools/20231211_2023.09_anaconda3/.conda'

# some more ls aliases
alias ls='ls --color=auto'
alias ll='ls -laF'

# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
