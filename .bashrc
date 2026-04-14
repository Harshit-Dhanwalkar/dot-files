# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

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

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# export BAT_THEME= "OneHalfDark" #gruvbox-dark" #"Dracula"

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto --group-directories-first'
  alias ll='ls -alF'
  alias la='ls -A'
  alias l='ls -CF'
  alias lh='ls -alhF'
  alias mv='mv -i'
  # alias rm='rm -Iv'
  # alias lsblk='lsblk | batcat -l conf -p' # use `bat` for non debian
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  alias cpv='rsync -avh --info=progress2'
  alias du='du -h'
  alias grep="grep --color=auto"
  alias tree='tree -CAFa -I "CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components" --dirsfirst'
  alias curlh="curl -sILX GET"
  alias curld="curl -A \"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36\""
  alias curlm="curl -A \"Mozilla/5.0 (iPhone; CPU iPhone OS 6_1_3 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) CriOS/28.0.1500.12 Mobile/10B329 Safari/8536.25\""

fi

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

# enable programmable completion features (you don't need to enable this, if it's already enabled in /etc/bash.bashrc and /etc/profile sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

## Path variables
export PATH="$HOME/.local/bin:$PATH"
# export PATH="/usr/bin/env bash"

# Kitty path
# export PATH="$HOME/.local/kitty.app/bin:$PATH"
export PATH="$HOME/.local/kitty.app/bin:$HOME/.local/bin:$PATH"

# HomeBrew
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
export PATH="/home/linuxbrew/.linuxbrew/sbin:$PATH"
# export XDG_DATA_DIRS="/home/linuxbrew/.linuxbrew/share:$XDG_DATA_DIRS"
# export LD_LIBRARY_PATH="/home/linuxbrew/.linuxbrew/lib:$LD_LIBRARY_PATH"
# export HOMEBREW_CURL_PATH="/home/linuxbrew/.linuxbrew/bin/curl" # Uninstalled `curl` via homebrew and installed via nala # For curl installed via brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Yazi
function yy() { 
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" 
  yazi "$@" --cwd-file="$tmp" 
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then 
    builtin cd -- "$cwd" 
  fi 
  rm -f -- "$tmp" 
}

# Notification
function notify-send() {
  local user=$(whoami)
  local bus_address=$DBUS_SESSION_BUS_ADDRESS
  sudo -u $user DBUS_SESSION_BUS_ADDRESS=$bus_address DISPLAY=$DISPLAY /usr/bin/notify-send "$@" 2>/dev/null
}

## desktop notification with the last command you ran and whether it succeeded or failed
function alert() {
    local exit_code=$?
    local last_command=$(HISTTIMEFORMAT='' history 2 | head -n1 | sed 's/^[ ]*[0-9]*[ ]*//')
    local icon="terminal"
    local status="succeeded"
    if [ $exit_code -ne 0 ]; then
        icon="error"
        status="failed"
    fi
    notify-send --urgency=low -i "$icon" "$last_command" "Status: $status"
}

# FZF setup
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
## if FZF is installed by Homebrew and source the required files
if [[ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.bash" ]]; then
  source "$(brew --prefix)/opt/fzf/shell/key-bindings.bash"
  source "$(brew --prefix)/opt/fzf/shell/completion.bash"
fi
# alias inv='function _inv() { local file=$(fzf --preview "batcat --color=always {}"); [[ -n $file ]] && nvim "$file"; }; _inv'
# alias nv='function _inv() { local file=$(fzf --preview "batcat --style=header,grid --color=always {}"); [[ -n $file ]] && nvim "$file"; }; _inv' #batcat: No line numbers but keep header
# alias nv='function _inv() { local file=$(fzf --preview "batcat --style=header,grid --color=always {}"); [[ -n $file ]] && nvim "$file"; }; _inv' # batcat: Only syntax highlighting
# alias nv='function _inv() { local file=$(fzf --preview-window=right:70%:nowrap --preview "cat --style=header,grid --color=always  --line-range=:500 {}"); [[ -n $file ]] && nvim "$file"; };
 # _inv' # batcat: no line numbers but with header, grid and nowrap-lines
##### install bat
# export FZF_DEFAULT_OPTS="--style minimal --color 16 --layout=reverse --height 30% --preview='bat -p --colors=always {}'"
export FZF_DEFAULT_OPTS="--style minimal --color 16 --layout=reverse --height 30%"
##### install bat
# export FZF_CTRL_T_OPTS="
#   --walker-skip .git,node_modules,target
#   --preview 'batcat -n --color=always {}'
#   --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --color header:italic
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
## CRTL-R then on desired cmd press CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort'
  --color header:italic
  --header 'Press ctrl-y to copy command into clipboard'"
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort'
  --color header:italic
  --header 'Press ctrl-y to copy command into clipboard'"
## Print tree structure in the preview window, 
#####install tree
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"
export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_COMPLETION_PATH_OPTS='--walker file,dir,follow,hidden'
export FZF_COMPLETION_DIR_OPTS='--walker dir,follow'
_fzf_comprun() {
  local command=$1
  shift
  case "$command" in
  cc) fzf --preview 'tree -C {} | head -200' "$@" ;;
  export | unset) fzf --preview "eval 'echo \$'{}" "$@" ;;
  ssh) fzf --preview 'dig {}' "$@" ;;
  *) fzf --preview 'batcat -n --color=always {}' "$@" ;;
  esac
}
## Use fd (https://github.com/sharkdp/fd) for listing path candidates.
### - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_dir() {
  local path="${1:-.}" # $1 is base path
  fdfind --type d --hidden --follow --exclude ".git" . "$path"
}

# Zoxide
eval "$(zoxide init bash)"

# GCC colors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# QT apps
export QT_QPA_PLATFORM=wayland
# export QT_QPA_PLATFORM=xcb

# Fix Electron apps
export ELECTRON_OZONE_PLATFORM_HINT=auto

# Gem executables PATH for Ruby
export PATH="$HOME/.local/share/gem/ruby/3.0.0/bin:$PATH"
