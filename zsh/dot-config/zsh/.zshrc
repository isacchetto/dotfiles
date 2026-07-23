echo ".zshrc execution starts.."

# Prompt:
export PS1='%B%F{1}%n:%f%F{3}%~%f%b %# ' #MonokaiPro
export PROMPT='%B%F{red}%n%f%b%B%F{magenta}@%m%f%b:%B%F{yellow}%~%f%b %% '
# Prompt principale
if [[ -n ${SSH_CONNECTION-} ]]; then
    PROMPT='%F{red}%n@%m%f:%F{yellow}%~%f'
else
    PROMPT='%F{yellow}%~%f'
fi
# Vai a capo e mostra il prompt
PROMPT+=$'\n'
PROMPT+='%B%F{green}❯%f%b '

# Prompt di continuazione
export PROMPT2='%B%F{green}❯%f%b '

    # %(?.%F{green}√.%F{red}?%?)%f
#export PS1='%B%F{51}%n:%f%F{35}%~%f%b %# ' #Dracula
    # %B%F{51}%n%f%b
    # %F{35}%~%f

#export PS2='> '

# Load LS_COLORS (for Linux or GNU ls) and/or LSCOLORS (for macOS/BSD)
case "$OSTYPE" in
    linux*)
        (( $+commands[dircolors] )) && eval "$(dircolors -b)"
        ;;
    darwin*)
        # If GNU coreutils (gls, gdircolors, etc.) are installed
        # (( $+commands[gdircolors] )) && eval "$(gdircolors -b)"
        # Enable colored output from ls, etc. on FreeBSD-based systems
        export CLICOLOR=1
        export LS_COLORS='di=35:ln=34:so=36:pi=36:ex=32:bd=34;46:cd=34;46:su=42:sg=42:tw=45:ow=45' #MonokaiPro
        export LSCOLORS='fxexgxgxcxegegxcxcxfxf' #MonokaiPro  (fx ex gx gx cx eg eg ac ac af af)
            #            exfxcxdxbxegedabagacad (default)      1  2  3  4  5  6  7  8  9  10 11
            #
            # Color Legend:                                         Pos legend (ab: a is the foregroundcolor and b is the background color):
            # a     black                                           1.   directory
            # b     red                                             2.   symbolic link
            # c     green                                           3.   socketq
            # d     brown                                           4.   pipe
            # e     blue                                            5.   executable
            # f     magenta                                         6.   block special
            # g     cyan                                            7.   character special
            # h     light grey                                      8.   executable with setuid bit set
            # A     bold black, usually shows up as dark grey       9.   executable with setgid bit set
            # B     bold red                                        10.   directory writable to others, with sticky bit
            # C     bold green                                      11.   directory writable to others, without sticky
            # D     bold brown, usually shows up as yellow
            # E     bold blue
            # F     bold magenta
            # G     bold cyan
            # H     bold light grey; looks like bright white
            # x     default foreground or background
        ;;
esac

# Autoload Zsh Function
autoload -U colors && colors  # makes color constants available


# Stderr in Red and with a beep (\a):
# exec 2>>( while read X; do print "\a\e[91m${X}\e[0m" > /dev/tty; done & )
exec 2>>( while read X; do print "\e[91m${X}\e[0m" > /dev/tty; done & )

# Custom Variables:
# export EDITOR=micro
# export VISUAL=micro

# Set Zsh History:
HISTSIZE=100000                     #How many lines of history to keep in memory
SAVEHIST=1000000                    #Number of history entries to save to disk
HISTFILE=${ZDOTDIR}/.zsh_history    #Where to save history to disk

setopt INC_APPEND_HISTORY           #Immediately append to the history file, not just when a term is killed
setopt SHARE_HISTORY                #Share history across terminals
setopt HIST_IGNORE_ALL_DUPS         #Not save duplicate in history
# setopt APPEND_HISTORY               #Append history to the history file (no overwriting)
# setopt HIST_FIND_NO_DUPS            #not work :(



# Basic auto/tab complete:

# Directory della cache
mkdir -p -m 700 "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
# Inizializza il completamento e salva il dump nella cache
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache/zcompdump"
# Menu interattivo
zmodload zsh/complist
zstyle ':completion:*' menu select=2
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
# Mostra anche i file nascosti
_comp_options+=(globdots)
# Prima matching esatto, poi case-insensitive
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
# Gruppi e descrizioni
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%B%F{2}%d%f%b'
zstyle ':completion:*' verbose yes
# Colori coerenti con ls
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# Percorso usato solo dal wizard compinstall
zstyle ':compinstall' filename "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshrc"

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

autoload -Uz add-zsh-hook

# Awesome cd movements from zsh option
DIRSTACKFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dirs"
if [[ -f "$DIRSTACKFILE" ]] && (( ${#dirstack} == 0 )); then
	dirstack=("${(@f)"$(< "$DIRSTACKFILE")"}")
	#[[ -d "${dirstack[1]}" ]] && cd -- "${dirstack[1]}"
fi
chpwd_dirstack() {
	print -l -- "$PWD" "${(u)dirstack[@]}" > "$DIRSTACKFILE"
}
add-zsh-hook -Uz chpwd chpwd_dirstack

DIRSTACKSIZE='20'
setopt AUTO_CD # automatically change directory when dir name is typed
setopt AUTO_PUSHD # Make cd push the old directory onto the directory stack
setopt PUSHD_SILENT # Do not print the directory stack after pushd or popd
setopt CD_SILENT # don't print the directory after cd
setopt PUSHD_TO_HOME # pushd with no arguments pushes $HOME onto the directory stack
setopt CD_ABLE_VARS # if is not a directory try to expand with ~
setopt PUSHD_IGNORE_DUPS # Don’t push multiple copies of the same directory onto the directory stack
setopt PUSHD_MINUS # reverts the +/- operators when used with a number to specify a directory in the stack

# Load aliases and shortcuts if existent and have read permission.
[ -r ${ZDOTDIR}/aliasrc ] && . ${ZDOTDIR}/aliasrc

# Load ; should be last.
#source "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh" 2>/dev/null
#source "~/git/zsh-autocomplete/zsh-autocomplete.plugin.zsh" 2>/dev/null
#ZSH_AUTOSUGGEST_STRATEGY=(completion history)
#source "/usr/local/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
#source "/usr/local/opt/spaceship/spaceship.zsh"

# Neofetch
# neofetch




git_prompt_info() {
  current_branch=$(git current-branch 2> /dev/null)
  if [[ -n $current_branch ]]; then
    echo " %{$fg_bold[green]%}$current_branch%{$reset_color%}"
  fi
}

# setopt promptsubst

# Allow exported PS1 variable to override default prompt.
# if ! env | grep -q '^PS1='; then
#   PS1='${SSH_CONNECTION+"%{$fg_bold[green]%}%n@%m:"}%{$fg_bold[blue]%}%c%{$reset_color%}$(git_prompt_info) %# '
# fi


# Enable extended globbing
# setopt extendedglob

# Allow [ or ] whereever you want
# unsetopt nomatch

# setopt no_flow_control  # disable ctrl+s, ctrl+q




echo ".zshrc execution stops.."
