# ALIASES

# Anaconda3
# alias my_conda='source /shares/CIBIO-Storage/CM/scratch/users/isacco.cenacchi/tools/miniconda3/.conda'
# alias lab_conda='source /shares/CIBIO-Storage/CM/scratch/tools/20231211_2023.09_anaconda3/.conda'

alias grep='grep --color=auto'

# ls aliases
alias ls='ls --color=auto -ph'
    # -p = '/' on directory
    # -G = Enable colorized output (on macOS)
    # -h = use unit suffixes: Byte, Kilobyte, Megabyte.. with -l
alias ll='ls -laF'

# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# rsync filtering (merge multiple filter roles from a single file) + @1 to preserve modification times less aggressively
[[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/rsync/rsync-filter" ]] && \
alias rsync='rsync -@1 --filter=". ${XDG_CONFIG_HOME:-$HOME/.config}/rsync/rsync-filter"'