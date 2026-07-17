# PS4='+ $(gdate "+%s.%N")\011 '
# exec 3>&2 2>/tmp/bashstart.$$.log

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
export PSQL_TZ=$(date +%Z)
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
PATH="${PATH}:~/.dblab/"
PATH="/opt/homebrew/opt/libpq/bin:$PATH"
PATH="$PATH:/Users/evanthomas/github.com/arunsupe/semantic-grep"


# TODO: remove the following. There are "proper" brew instructions. This line
# adds the brew binary and the binaries brew installs to your PATH. You're
# supposed to do something like /opt/homebrew/bin/brew shellenv > ~/.profile. I
# couldn't figure out what so i just did this
eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH

#  ================================= ALIASES =================================
# alias grep='ggrep --color'
alias lifx='/home/evan/.dotfiles/scripts/lifx-cmd/venv/bin/python /home/evan/.dotfiles/scripts/lifx-cmd/bin/lifx'
alias lifx-discover='/home/evan/.dotfiles/scripts/lifx-cmd/venv/bin/python /home/evan/.dotfiles/scripts/lifx-cmd/bin/lifx-discover'
alias nose='nosetests -v -x -s'
alias godevel='/Users/ethomas/go/src/github.com/golang/go/bin/go'
alias godvl='/Users/ethomas/go/src/github.com/golang/go/bin/go'
alias gdvl='/Users/ethomas/go/src/github.com/golang/go/bin/go'
alias dc='docker compose'
alias yoco='claude --dangerously-skip-permissions'
alias yodex='codex --yolo'
# alias pbcopy='xclip -selection clipboard'
# alias pbpaste='xclip -selection clipboard -o'
alias g='git'
__git_complete g _git # https://stackoverflow.com/questions/9869227/git-autocomplete-in-bash-aliases
alias gi='git'
__git_complete g _git # https://stackoverflow.com/questions/9869227/git-autocomplete-in-bash-aliases

# Make custom git subcommands complete like their underlying git command.
_git_plog() { _git_log; }

alias kb='kubectl'
alias svenv='source venv/bin/activate'
alias v='nvim'
alias nv='nvim'
alias py36='~/.pyenv/versions/3.6.1/bin/python'
alias svenv='source venv/bin/activate'
alias tf='tfwrapper'
alias gs='git s'
alias cat='bat'


alias npm="sfw npm"
alias yarn="sfw yarn"
# alias pnpm="sfw pnpm"
alias pip="sfw pip"
alias uv="sfw uv"
alias cargo="sfw cargo"
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

cdj() {
  local dir
  dir="$(jump "$@")" || return
  [[ -n "$dir" ]] || return
  cd -- "$dir"
}

#  ========================== HISTORY CONTROL  ==========================
# See https://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# Explicitly set HISTFILE (don't rely on bash's internal default, which can
# fail to initialize in some tmux/bash-3.2 environments)
export HISTFILE="$HOME/.bash_history"

# After each command, append to the history file and read in new entries from
# other sessions. Use "history -n" (read only new lines) instead of
# "history -c; history -r" (clear+reread all) — the latter resets bash 3.2's
# internal "new lines this session" counter, causing "history -a" to write
# nothing on subsequent commands.
export PROMPT_COMMAND="history -a; history -n"


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
#
# eval `ssh-agent`

SSH_AGENT_SOCK="$HOME/.ssh/agent.sock"
export SSH_AUTH_SOCK="$SSH_AGENT_SOCK"

if [ ! -S "$SSH_AGENT_SOCK" ]; then
    rm -f "$SSH_AGENT_SOCK"
    ssh-agent -a "$SSH_AGENT_SOCK" >/dev/null
fi

# ssh-add   ~/.ssh/id_ed25519
# ssh-add   ~/.ssh/id_rsa.koanix

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/ethomas/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/Users/ethomas/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
# if [ -f '/Users/ethomas/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/ethomas/Downloads/google-cloud-sdk/completion.bash.inc'; fi
# . "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# setting use default takes forever
# [ -s "$NVM_DIR/nvm.sh" ] && nvm use default > /dev/null 2>&1  # Use default Node.js version

# Shell-GPT integration BASH v0.2
_sgpt_bash() {
if [[ -n "$READLINE_LINE" ]]; then
    READLINE_LINE=$(sgpt --shell <<< "$READLINE_LINE" --no-interaction)
    READLINE_POINT=${#READLINE_LINE}
fi
}


# bind -x '"\C-i": _sgpt_bash'
# Shell-GPT integration BASH v0.2
bind -x '"\C-g": __llm_cmdcomp'
__llm_cmdcomp() {
    # Store the current command line
    local old_cmd="${READLINE_LINE}"
    local cursor_pos="${READLINE_POINT}"
    local result

    # Move to a new line
    echo

    # Get the LLM completion
    if result="$(llm cmdcomp "${old_cmd}")"; then
        # Replace the command line with the result
        READLINE_LINE="${result}"
        READLINE_POINT="${#result}"
        # Move down a line to prevent bash from overwriting output
        echo
    else
        # Restore original command on error
        READLINE_LINE="${old_cmd}"
        READLINE_POINT="${cursor_pos}"
        echo "Command completion failed" >&2
    fi
}


cdr() {
  if [ -n "$REPO_ROOT" ]; then
    cd "$REPO_ROOT"
  else
    echo -e "\033[31mNo REPO_ROOT found in env variables\033[0m" >&2
  fi
}

# _edit_noexec() {
#     local tmp
#     tmp=$(mktemp)

#     # Write current Readline buffer to file
#     printf "%s" "$READLINE_LINE" > "$tmp"

#     # Open editor
#     "${VISUAL:-${EDITOR:-vi}}" "$tmp"

#     # Replace current buffer with edited content
#     READLINE_LINE=$(<"$tmp")
#     READLINE_POINT=${#READLINE_LINE}

#     rm -f "$tmp"
# }

# bind -x '"\C-x\C-e": _edit_noexec'

export UV_PYTHON=3.13




###############################################################################
#################################### Simple ###################################
###############################################################################
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
eval "$(rbenv init -)"
eval "$(fnm env --use-on-cd --shell bash)"
#
# Rails shortcuts
alias rc="bundle exec rails console"  # Quick access to Rails console

# Development workflow
alias cg="pnpm run compile"  # Run pnpm compile
alias rb="rubocop -A"       # Auto-fix Ruby code style issues
alias cop="bundle exec rubocop -A"  # Run Rubocop with bundled version


################################### Secrets ###################################
export SG_OPENAI_API_KEY="$EVAN_PERSONAL_OPENAI_API_KEY"

# ntn (Notion CLI) reliability: the CLI fetches the Notion OpenAPI spec on every
# call from developers.notion.com (flaky Readme.io CDN), which can silently hang
# ntn for minutes. Point it at a LOCAL spec server (~/scripts/background/ntn-spec-server.d
# serves ~/.ntn-spec on port 8799) so spec resolution never hits the network.
export NOTION_API_DOCS_BASE_URL="http://localhost:8799"
