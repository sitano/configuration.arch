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

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'

# Basic directory operations
alias ...='cd ../..'
alias -- -='cd -'

# Super user
alias _='sudo'
alias please='sudo'

#alias g='grep -in'

# Show history
if [ "$HIST_STAMPS" = "mm/dd/yyyy" ]
then
    alias history='fc -fl 1'
elif [ "$HIST_STAMPS" = "dd.mm.yyyy" ]
then
    alias history='fc -El 1'
elif [ "$HIST_STAMPS" = "yyyy-mm-dd" ]
then
    alias history='fc -il 1'
else
    alias history='fc -l 1'
fi

alias arch='uname -m'

# List direcory contents
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -alh'
alias la='ls -lAh'
alias sl=ls # often screw this up

alias afind='ack -il'

alias ghc='stack exec -- ghc'
alias ghci='stack exec -- ghci'

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
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Less Scheme
export LESS=-R
export LESS_TERMCAP_mb=$'\033[01;31m'
export LESS_TERMCAP_md=$'\033[01;38;5;74m'
export LESS_TERMCAP_me=$'\033[0m'
export LESS_TERMCAP_se=$'\033[0m'
export LESS_TERMCAP_so=$'\033[38;5;246m'
export LESS_TERMCAP_ue=$'\033[0m'
export LESS_TERMCAP_us=$'\033[04;38;5;146m'

# export PERL_LOCAL_LIB_ROOT="/home/sitano/perl5"
# export PERL_MB_OPT="--install_base /home/sitano/perl5"
# export PERL_MM_OPT="INSTALL_BASE=/home/sitano/perl5"
# export PERL5LIB="/home/sitano/perl5/lib/perl5/x86_64-linux-gnu-thread-multi:/home/sitano/perl5/lib/perl5"
# export PATH="/home/sitano/perl5/bin:$PATH"
export PATH="/usr/bin/vendor_perl:$PATH"

export ALTERNATE_EDITOR=vim EDITOR=vim VISUAL=vim
export TERMINAL=gnome-terminal

# export PATH="/opt/vagrant/bin:$PATH"
# export PATH="/opt/packer:$PATH"

# Haskell / Stack
export PATH="$HOME/.local/bin:$PATH"

# User specific environment and startup programs
export GOROOT=/usr/lib/go
export GOPATH=$HOME/Projects/gocode
export GOOS=linux
export GOARCH=amd64

export PATH=$GOROOT/bin:$GOPATH/bin:$PATH

# Hadoop
# export PATH=$HOME/.cask/bin:$PATH

# Node.JS
# export PATH=$PATH:$HOME/Projects/node-v7.9.0-linux-x64/bin

# Rust
export PATH="$HOME/.cargo/bin:$PATH";
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

# EC2 Configuration
export EC2_HOME=~/.ec2
export EC2_URL=https://ec2.eu-west-1.amazonaws.com
export EC2_CERT=$EC2_HOME/cert.pem
export EC2_PRIVATE_KEY=$EC2_HOME/pk.pem
export PATH=$PATH:$EC2_HOME/bin

# Java
export JAVA_HOME=/usr/lib/jvm/default

# Scala
# export SCALA_HOME=~/scala
# export PATH=$HOME/scala/bin:$PATH

# Debian Packages
export DEBFULLNAME="Ivan Prisyazhniy"
export DEBEMAIL="john.koepi@gmail.com"
export GPG="john.koepi@gmail.com"

# WeChall
export WECHALLUSER="sitano"
export WECHALLTOKEN=""

# AWS completion
if [ -f "$HOME/.local/bin/aws_bash_completer.sh" ]; then source "$HOME/.local/bin/aws_bash_completer.sh"; fi

# Microsoft Azure
# if [ -f "/usr/local/az/az.completion" ]; then source "/usr/local/az/az.completion"; fi

# FZF
if [ -f "$HOME/.fzf.bash" ]; then source "$HOME/.fzf.bash"; fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f "/opt/google-cloud-sdk/path.bash.inc" ]; then source "/opt/google-cloud-sdk/path.bash.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "/opt/google-cloud-sdk/completion.bash.inc" ]; then source "/opt/google-cloud-sdk/completion.bash.inc"; fi

# KubeCtl
if [ -f "/opt/google-cloud-sdk/bin/kubectl"  ]; then source <(/opt/google-cloud-sdk/bin/kubectl completion bash); fi

# added by travis gem
# [ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh
