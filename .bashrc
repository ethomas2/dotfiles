#  ================================= SOURCE  =================================
[ -f ~/.dotfiles/git-completion.bash ] && source ~/.dotfiles/git-completion.bash
[ -f ~/.marksrc ]                      && source ~/.marksrc
[ -f ~/.fzf.bash ]                     && source ~/.fzf.bash
[ -f ~/.dotfiles/secrets ]             && source ~/.dotfiles/secrets


#  ================================= EXPORTS =================================
export HISTCONTROL=ignoredups:ignorespace
export TERM=xterm-256color
export PYENV_ROOT="$HOME/.pyenv"
export PGDATA="/usr/local/var/postgres"
export GOPATH=/home/evan/go
export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""


#  ============================== PATH CHANGES ==============================
PATH="$PYENV_ROOT/bin:${PATH}"
PATH="${PATH}:/home/evan/scripts" # mostly for ack
PATH="${PATH}:/home/evan/bin" # mostly for ack
PATH="${PATH}:/home/evan/go/bin"
PATH="${PATH}:/home/evan/.local/bin" # for haskell stuff
PATH="${PATH}:/usr/local/sbin"
PATH="${PATH}:~/.config/yarn/global/node_modules/.bin/" # for yarn binaries, ie prettier
PATH="${PATH}:$PYENV_ROOT/bin"
export PATH


#  ================================= ALIASES =================================
alias lifx='/home/evan/.dotfiles/scripts/lifx-cmd/venv/bin/python /home/evan/.dotfiles/scripts/lifx-cmd/bin/lifx'
alias lifx-discover='/home/evan/.dotfiles/scripts/lifx-cmd/venv/bin/python /home/evan/.dotfiles/scripts/lifx-cmd/bin/lifx-discover'
alias ls='ls --color=auto'
alias nose='nosetests -v -x -s'
alias dc='docker-compose'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias g='git'
__git_complete g _git # https://stackoverflow.com/questions/9869227/git-autocomplete-in-bash-aliases
alias gi='git'
__git_complete g _git # https://stackoverflow.com/questions/9869227/git-autocomplete-in-bash-aliases
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

# consider
# export HISTSIZE=100000                   # big big history
# export HISTFILESIZE=100000               # big big history


#  ================================= OTHER =================================
if [ -z "$TMUX" ]; then
  tmux
fi

# See http://linux-sxs.org/housekeeping/lscolors.html and https://github.com/seebi/dircolors-solarized
eval `dircolors ~/.dotfiles/dircolors-solarized/dircolors.256dark`
