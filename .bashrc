# PS4='+ $(gdate "+%s.%N")\011 '
# exec 3>&2 2>/tmp/bashstart.$$.log
# set -x

#  ================================= SOURCE  =================================
[ -f ~/.dotfiles/git-completion.bash ] && source ~/.dotfiles/git-completion.bash
[ -f ~/.marksrc ]                      && source ~/.marksrc
[ -f ~/.fzf.bash ]                     && source ~/.fzf.bash
[ -f ~/.dotfiles/secrets ]             && source ~/.dotfiles/secrets
[ -f ~/.temporc ]                      && source ~/.temporc
[ -f ~/.hrprc ]                        && source ~/.hrprc

# brew bash completion stuff (bat, ag, pandoc). Idk if this even does anything
[ -d /usr/local/etc/bash_completion. ] && source /usr/local/etc/bash_completion.d/*

# brew bash completion stuff (bat, ag, pandoc). Idk if this even does anything
[ -d /usr/local/etc/bash_completion. ] && source /usr/local/etc/bash_completion.d/*
[ -d ~/.gvm/scripts/gvm ] && source ~/.gvm/scripts/gvm

[ $(uname -s) = "Darwin" ] && source ~/.dotfiles/.bashrc.mac
[ $(uname -s) = "Linux" ] && source ~/.dotfiles/.bashrc.linux

#  ================================= EXPORTS =================================
export HISTCONTROL=ignoredups:ignorespace
export TERM=xterm-256color
export PYENV_ROOT="$HOME/.pyenv"
export PGDATA="/usr/local/var/postgres"
export GOPATH=$HOME/go
export MANPAGER="/bin/sh -c \"col -b | nvim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
export EDITOR='nvim'
# export AWS_DEFAULT_REGION=us-west-2  # used by aws tools. Specifically sam (maybe others)


#  ============================== PATH CHANGES ==============================
PATH="${PATH}:~/.config/yarn/global/node_modules/.bin/" # for yarn binaries, ie prettier
PATH="${PATH}:$HOME/bin" # mostly for ack. Also direnv
PATH="${PATH}:$HOME/bin/kafka_2.13-3.4.0/bin"
PATH="${PATH}:$HOME/go/bin"
PATH="${PATH}:$HOME/Library/Haskell/bin" # haskell stuff installed by cabal
PATH="${PATH}:$HOME/Library/Python/2.7/bin" # pip/virtualenv location
PATH="${PATH}:$HOME/.local/bin" # for haskell stuff and pyls
PATH="${PATH}:$HOME/scripts"
PATH="${PATH}:$HOME/scripts/git-scripts"
PATH="${PATH}:$PYENV_ROOT/bin"
PATH="${PATH}:/usr/local/sbin"
PATH="$PYENV_ROOT/bin:${PATH}"
PATH="${PATH}:/usr/local/bin"  # for npm
PATH="/opt/homebrew/opt/libpq/bin:$PATH"



# TODO: remove the following. There are "proper" brew instructions. This line
# adds the brew binary and the binaries brew installs to your PATH. You're
# supposed to do something like /opt/homebrew/bin/brew shellenv > ~/.profile. I
# couldn't figure out what so i just did this
eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH

#  ================================= ALIASES =================================
alias grep='ggrep --color'
alias lifx='/home/evan/.dotfiles/scripts/lifx-cmd/venv/bin/python /home/evan/.dotfiles/scripts/lifx-cmd/bin/lifx'
alias lifx-discover='/home/evan/.dotfiles/scripts/lifx-cmd/venv/bin/python /home/evan/.dotfiles/scripts/lifx-cmd/bin/lifx-discover'
alias nose='nosetests -v -x -s'
alias godevel='/Users/ethomas/go/src/github.com/golang/go/bin/go'
alias godvl='/Users/ethomas/go/src/github.com/golang/go/bin/go'
alias gdvl='/Users/ethomas/go/src/github.com/golang/go/bin/go'
alias dc='docker-compose'
# alias pbcopy='xclip -selection clipboard'
# alias pbpaste='xclip -selection clipboard -o'
alias g='git'
__git_complete g _git # https://stackoverflow.com/questions/9869227/git-autocomplete-in-bash-aliases
alias gi='git'
__git_complete g _git # https://stackoverflow.com/questions/9869227/git-autocomplete-in-bash-aliases

alias kb='kubectl'
alias svenv='source venv/bin/activate'
alias v='nvim'
alias nv='nvim'
alias py36='~/.pyenv/versions/3.6.1/bin/python'
alias svenv='source venv/bin/activate'
alias tf='tfwrapper'
alias gs='git s'


#  ================================= FZF =================================
export FZF_DEFAULT_COMMAND="fd"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"


export FZF_DEFAULT_OPTS='
  -m -i
  --bind ctrl-d:page-down,ctrl-u:page-up
  --preview-window right:35%
  --preview "[[ $(file --mime {}) =~ binary ]] &&
                 echo {} is a binary file ||
                 (bat --style "numbers,changes" --color=always {} ||
                  head -500 {}) 2> /dev/null"
'

_important_dirs() {
  [ -d ~/github.com ] && find ~/github.com -maxdepth 2 -mindepth 2 -type d
  [ -d ~/.marks ] && find ~/.marks -type l -ls | awk '{print $NF}'
}
_fzf_important_dirs() {
  _important_dirs | fzf
}
# deep black magic adopted from fzf's C-t
# see https://github.com/junegunn/fzf/blob/315e568de006e80138f79c77d5508c7e4853e6b2/shell/key-bindings.bash#L77
# bind '"\C-j": " \C-u \C-a\C-k`_fzf_important_dirs`\e\C-e\C-y\C-a\C-y\ey\C-h\C-e\er \C-h"'

_all_dirs_and_files() {
  echo /etc/hosts &&
  find $HOME/.ssh &&
  find $HOME/github.com -type d -maxdepth 2
}
_fzf_all_dirs_and_files() {
  _all_dirs | fzf
}
# bind '"\C-j": " \C-u \C-a\C-k`_fzf_important_dirs`\e\C-e\C-y\C-a\C-y\ey\C-h\C-e\er \C-h"'
# bind '"\C-j": " \C-u \C-a\C-k`_fzf_important_dirs`\e\C-e\C-y\C-a\C-y\ey\C-h\C-e\er \C-h"'

#  ========================== HISTORY CONTROL  ==========================
# See https://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# After each command, append to the history file and reread it
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"


# My current .bash_history is 508 lines and 15644 bytes for an average of 30
# bytes per line. Thus 10000 HISTSIZE is 307 KB
export HISTSIZE=10000                   # big big history
export HISTFILESIZE=10000               # big big history


#  ================================= OTHER =================================
if [ -z "$TMUX" ] && [ -t 1 ]; then
  tmux
fi


# I have no idea what is setting PGPASSWORD, but something somewhere is setting
# it
unset PGPASSWORD

eval "$(direnv hook bash)"



# https://askubuntu.com/a/670600
reset=$(tput sgr0)
bold=$(tput bold)
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
magenta=$(tput setaf 5)
white=$(tput setaf 7)
blue=$(tput setaf 4)
cyan=$(tput setaf 6)
user_color=$magenta
# PS1="\[$reset\]\[$cyan\][ \[$bold\]\[$user_color\]\u@\h\
# \[$reset\]\[$blue\]\W\[$cyan\]\D{%H:%M:%S}\[$cyan\] ] \[$reset\]\[$reset\]\\$\[$reset\] "
PS1="\[$reset\]\[$cyan\][ \[$bold\]\[$user_color\]\W\[$reset\]\[$blue\]\D{%H:%M:%S}\[$cyan\] ] \[$reset\]\[$reset\]\\$\[$reset\] "

# eval "$(pipenv --completion)"


[[ -s "/home/evan/.gvm/scripts/gvm" ]] && source "/home/evan/.gvm/scripts/gvm"

# LINES=$(cat /home/evan/file | wc -l)
# echo $LINES >> /home/evan/file


export HOMEBREW_NO_AUTO_UPDATE=1

# set +x
# exec 2>&3 3>&-
eval `ssh-agent`
ssh-add   ~/.ssh/id_ed25519

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/ethomas/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/Users/ethomas/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/ethomas/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/ethomas/Downloads/google-cloud-sdk/completion.bash.inc'; fi
. "$HOME/.cargo/env"
