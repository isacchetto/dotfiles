echo ".zprofile execution starts.."

# da finire
export LANG="it_IT.UTF-8"
export LC_COLLATE="en_GB.UTF-8"
export LC_CTYPE="en_GB.UTF-8"
export LC_MESSAGES="en_GB.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_GB.UTF-8"
export LC_TIME="en_GB.UTF-8"
export LC_ALL="it_IT.UTF-8"

# XDG Base Directory Specification
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_STATE_HOME=$HOME/.local/state
export XDG_RUNTIME_DIR=""
export XDG_DATA_DIRS=/usr/local/share:/usr/share
export XDG_CONFIG_DIRS=/etc/xdg

# PATH
# typeset -TUx PATH path
# typeset -aU path
# append
# path+=('/home/david/pear/bin')
# or prepend
# path=('/home/david/pear/bin' $path)

# PATH
# typeset -U path PATH
# path=($XDG_RUNTIME_DIR $path)

PATH="$HOME/.bin:/usr/local/sbin:$PATH"

eval $(brew shellenv)
eval "$(conda "shell.$(basename "${SHELL}")" hook)"

# Load environment variables if existent and have read permission.
[ -r ${HOME}/.env ] && . ${HOME}/.env

export PATH

echo ".zprofile execution stops.."