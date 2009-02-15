###########################################################        
# Options for zsh

export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
eval `dircolors -b`
# # append command to history file once executed
setopt INC_APPEND_HISTORY

#自动补全功能
setopt AUTO_LIST
setopt AUTO_MENU
#setopt MENU_COMPLETE

autoload -U compinit
compinit
setopt autopushd pushdminus pushdsilent pushdtohome
setopt AUTO_CD
setopt CDABLE_VARS
setopt IGNORE_EOF
setopt INTERACTIVE_COMMENTS
setopt NO_BANG_HIST
setopt NO_CLOBBER
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt SH_WORD_SPLIT
setopt NO_HUP
setopt NO_BEEP
setopt AUTO_PUSHD
setopt COMPLETE_IN_WORD
setopt CORRECT

#Disable core dumps
limit coredumpsize 0

# PS1 and PS2
export PS1="$(print '%{\e[1;34m%}%n%{\e[0m%}'):$(print '%{\e[0;34m%}%~%{\e[0m%}')$ "
export PS2="$(print '%{\e[0;34m%}>%{\e[0m%}')"

# Vars used later on by zsh
export EDITOR="vim"
export BROWSER="w3m"
export XTERM="aterm +sb -geometry 80x29 -fg black -bg lightgoldenrodyellow -fn -xos4-terminus-medium-*-normal-*-14-*-*-*-*-*-iso8859-15"

##################################################################
# Stuff to make my life easier

# Completion caching
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path .zcache
#zstyle ':completion:*:cd:*' ignore-parents parent pwd

#Completion Options
zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate

# Path Expansion
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'

#zstyle ':completion:*:*:*:default' menu yes select
zstyle ':completion:*' menu select=1
zstyle ':completion:*:*:default' force-list always

# GNU Colors 需要/etc/DIR_COLORS文件 否则自动补全时候选菜单中的选项不能彩色显示
[ -f /etc/DIR_COLORS ] && eval $(dircolors -b /etc/DIR_COLORS)
export ZLSCOLORS="${LS_COLORS}"
zmodload  zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'


#compdef pkill=kill
#compdef pkill=killall
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER'

# Group matches and Describe
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*'               group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'

# allow approximate
zstyle ':completion:*:approximate:*' max-errors 1 numeric

##################################################################
# Key bindings
# http://mundy.yazzy.org/unix/zsh.php
# http://www.zsh.org/mla/users/2000/msg00727.html

bindkey -e
bindkey "^[[5~" beginning-of-line
bindkey "^[[6~" end-of-line
bindkey '^[[3~' delete-char

#typeset -g -A key
#bindkey '^?' backward-delete-char
#bindkey '^[[1~' beginning-of-line
#bindkey '^[[5~' up-line-or-history
#bindkey '^[[3~' delete-char
#bindkey '^[[4~' end-of-line
#bindkey '^[[6~' down-line-or-history
#bindkey '^[[A' up-line-or-search
#bindkey '^[[D' backward-char
#bindkey '^[[B' down-line-or-search
#bindkey '^[[C' forward-char 

#######################################################################
#less语法高亮。需要安装 source-highlight
PAGER='less -X -M'
export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
export LESS=' -R '

#让 cat 命令也语法高亮
hlcat() { less $* | cat }
#不过这样一来，cat 重定向到文件时会产生许多控制字符。所以用其它名字
alias tom='hlcat'
#color manpage
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m' 
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

##################################################################
# My aliases

# Set up auto extension stuff
alias -s html=$BROWSER
alias -s org=$BROWSER
alias -s php=$BROWSER
alias -s com=$BROWSER
alias -s net=$BROWSER
alias -s png=feh
alias -s jpg=feh
alias -s gif=feh
alias -s sxw=soffice
alias -s doc=soffice
alias -s odt=soffice
alias -s ods=soffice
alias -s pdf=evince
alias -s gz=tar -xzvf
alias -s bz2=tar -xjvf
alias -s java=$EDITOR
alias -s txt=$EDITOR
alias -s PKGBUILD=$EDITOR

# Normal aliases
alias ls='ls --color=auto -F'
alias lsd='ls -ld *(-/DN)'
alias ll='ls -alh'
alias lsa='ls -ld .*'
alias f='find |grep'
alias grep='grep --color=auto'
alias c="clear"
alias dir='ls -1'
alias gvim='gvim -geom 82x35'
alias ..='cd ..'
alias ppp-on='sudo /usr/sbin/ppp-on'
alias ppp-off='sudo /usr/sbin/ppp-off'
alias mpg123='mpg123 -o oss'
alias mpg321='mpg123 -o oss'
alias hist="grep '$1' /home/qianli/.zsh_history"
alias mem="free -m"
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias e='emacs -nw'
alias ee='emacsclient -t'
alias pacman='pacman-color'

# command L equivalent to command |less
alias -g L='|less' 

# command S equivalent to command &> /dev/null &
alias -g S='&> /dev/null &'

#路径别名  进入相应的路径时只要 cd ~xxx
hash -d W="/home/qianli/WWW/http"
hash -d AV="/home/qianli/benliud/Downloaded"
hash -d T="/home/qianli/Documents/EBooks/Tech"
hash -d BS="/home/qianli/WWW/http/bs/wp-content/themes/bside-project"
hash -d PKG="/var/cache/pacman/pkg"
hash -d E="/etc/env.d"
hash -d C="/etc/conf.d"
hash -d I="/etc/rc.d"
hash -d X="/etc/X11"

# type a directory's name to cd to it.
compctl -/ cd

###########################################################################
#screen integration to set caption bar dynamically
function title {
if [[ $TERM == "screen" || $TERM == "screen.linux" ]]; then
    # Use these two for GNU Screen:
    print -nR $'\033k'$1$'\033'\\\

    print -nR $'\033]0;'$2$'\a'
elif [[ $TERM == "xterm" || $TERM == "urxvt" ]]; then
    # Use this one instead for XTerms:
    print -nR $'\033]0;'$*$'\a'
    #trap 'echo -ne "\e]0;$USER@$HOSTNAME: $BASH_COMMAND\007"' DEBUG
fi
}

#set screen title if not connected remotely
function precmd {
    title "`print -Pn "%~" | sed "s:\([~/][^/]*\)/.*/:\1...:"`" "$TERM $PWD"
    echo -ne '\033[?17;0;127c'
}

function preexec {
    emulate -L zsh
    local -a cmd; cmd=(${(z)1})
    if [[ $cmd[1]:t == "ssh" ]]; then
        title "@"$cmd[2] "$TERM $cmd"
    elif [[ $cmd[1]:t == "sudo" ]]; then
        title "#"$cmd[2]:t "$TERM $cmd[3,-1]"
    elif [[ $cmd[1]:t == "for" ]]; then
        title "()"$cmd[7] "$TERM $cmd"
    elif [[ $cmd[1]:t == "svn" ]]; then
        title "$cmd[1,2]" "$TERM $cmd"
    else
        title $cmd[1]:t "$TERM $cmd[2,-1]"
    fi
}
############################################################################
