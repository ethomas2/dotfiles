#  ================================= SOURCE  =================================
[ -f ~/.dotfiles/git-completion.bash ] && source ~/.dotfiles/git-completion.bash
[ -f ~/.marksrc ]                      && source ~/.marksrc
[ -f ~/.fzf.bash ]                     && source ~/.fzf.bash
[ -f ~/.dotfiles/secrets ]             && source ~/.dotfiles/secrets

# brew bash completion stuff (bat, ag, pandoc). Idk if this even does anything
[ -d /usr/local/etc/bash_completion. ] && source /usr/local/etc/bash_completion.d/*


#  ================================= EXPORTS =================================
export HISTCONTROL=ignoredups:ignorespace
export TERM=xterm-256color
export PYENV_ROOT="$HOME/.pyenv"
export PGDATA="/usr/local/var/postgres"
export GOPATH=$HOME/go
export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
export AWS_DEFAULT_REGION=us-west-2  # used by aws tools. Specifically sam (maybe others)
export FCEDIT=vi



#  ============================== PATH CHANGES ==============================
PATH="$PYENV_ROOT/bin:${PATH}"
PATH="${PATH}:$HOME/scripts"
PATH="${PATH}:$HOME/bin" # mostly for ack
PATH="${PATH}:$HOME/go/bin"
PATH="${PATH}:$HOME/.local/bin" # for haskell stuff
PATH="${PATH}:$HOME/Library/Haskell/bin" # haskell stuff installed by cabal
PATH="${PATH}:/usr/local/sbin"
PATH="${PATH}:$HOME/Library/Python/2.7/bin" # pip/virtualenv location
PATH="${PATH}:$HOME/.cargo/bin"
PATH="${PATH}:~/.config/yarn/global/node_modules/.bin/" # for yarn binaries, ie prettier
PATH="${PATH}:$PYENV_ROOT/bin"
export PATH


#  ================================= ALIASES =================================
alias lifx='/home/evan/.dotfiles/scripts/lifx-cmd/venv/bin/python /home/evan/.dotfiles/scripts/lifx-cmd/bin/lifx'
alias lifx-discover='/home/evan/.dotfiles/scripts/lifx-cmd/venv/bin/python /home/evan/.dotfiles/scripts/lifx-cmd/bin/lifx-discover'
alias ls='ls --color=auto'
alias nose='nosetests -v -x -s'
alias godevel='/Users/ethomas/go/src/github.com/golang/go/bin/go'
alias godvl='/Users/ethomas/go/src/github.com/golang/go/bin/go'
alias gdvl='/Users/ethomas/go/src/github.com/golang/go/bin/go'
alias dc='docker-compose'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias g='git'
__git_complete g _git # https://stackoverflow.com/questions/9869227/git-autocomplete-in-bash-aliases
alias gi='git'
__git_complete g _git # https://stackoverflow.com/questions/9869227/git-autocomplete-in-bash-aliases
alias svenv='source venv/bin/activate'
alias v='vim'
alias py36='~/.pyenv/versions/3.6.1/bin/python'
alias cat='bat'


#  ================================= FZF =================================
export FZF_DEFAULT_OPTS='
  -m -i
  --bind ctrl-d:page-down,ctrl-u:page-up
  --preview "[[ $(file --mime {}) =~ binary ]] &&
                 echo {} is a binary file ||
                 (bat --style "numbers,changes" --color=always {} ||
                  head -500 {}) 2> /dev/null"
  --preview-window right:35%
'


#  ========================== HISTORY CONTROL  ==========================
# See https://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# After each command, append to the history file and reread it
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# My current .bash_history is 508 lines and 15644 bytes for an average of 30
# bytes per line. Thus 10000 HISTSIZE is 30.7 KB
export HISTSIZE=10000                   # big big history
export HISTFILESIZE=10000               # big big history


#  ================================= OTHER =================================
if [ -z "$TMUX" ]; then
  tmux
fi

# See http://linux-sxs.org/housekeeping/lscolors.html and https://github.com/seebi/dircolors-solarized
eval `dircolors ~/.dotfiles/dircolors-solarized/dircolors.256dark`
