# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="agnoster"
CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="true"

plugins=(colored-man colorize command-not-found cp history history-substring-search
ant bower cabal cake coffee cpanm docker gas git github gitignore gnu-utils go golang
heroku jira knife knife_ssh lein mercurial mix mvn nanoc postgres perl redis-cli rebar
repo sbt scala svn svn-fast-info vagrant node npm nvm composer phing bundler
capistrano gem jruby pow rake rbenv ruby rvm thor zeus fabric pip python virtualenv
 debian systemd)

source $ZSH/oh-my-zsh.sh

alias arch='uname -m'

alias ll='ls -alh'

alias afind='ack -il'

alias diff='diff --color=auto'
alias grep='grep --color=auto'

alias ghc='stack exec -- ghc'
alias ghci='stack exec -- ghci'

set_title() {
  export DISABLE_AUTO_TITLE="true"
  print -Pn "\e]0;$*\a"
}

unset_title() {
  export DISABLE_AUTO_TITLE="false"
}

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

export SSH_KEY_PATH="$HOME/.ssh/john.koepi.rsa"

# autoload bashcompinit
# bashcompinit
# source /etc/bash_completion

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
export PATH=$EC2_HOME/bin:$PATH

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
if [ -f "$HOME/.local/bin/aws_zsh_completer.sh" ]; then source "$HOME/.local/bin/aws_zsh_completer.sh"; fi

# Microsoft Azure
# if [ -f "/usr/local/az/az.completion" ]; then source "/usr/local/az/az.completion"; fi

# FZF
if [ -f "$HOME/.fzf.zsh" ]; then source "$HOME/.fzf.zsh"; fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f "/opt/google-cloud-sdk/path.zsh.inc" ]; then source "/opt/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "/opt/google-cloud-sdk/completion.zsh.inc" ]; then source "/opt/google-cloud-sdk/completion.zsh.inc"; fi

# KubeCtl
if [ -f "/opt/google-cloud-sdk/bin/kubectl"  ]; then source <(/opt/google-cloud-sdk/bin/kubectl completion zsh); fi

# added by travis gem
# [ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh
