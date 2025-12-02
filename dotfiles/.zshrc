##
#  ZSH Configuration of Ivy Witter
#
#  A slim custom config
##

##
#  CONSTANTS
##
source $HOME/.zsh/constants.zsh

##
#  PROMPT
##
source $HOME/.zsh/prompt.zsh

##
#  ALIASES
##
source $HOME/.zsh/aliases.zsh

##
#  PATHS
##
source $HOME/.zsh/paths.zsh

##
#  FUNCTIONS
##
source $HOME/.zsh/functions.zsh

##
#  AUTOCOMPLETION
##
source ~/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
if [ -f '/usr/local/bin/aws_completer' ]; then
    complete -C '/usr/local/bin/aws_completer' aws
fi

##
#  Ruby
##
function rbenv() {
  eval "$(command rbenv init -)"
}

##
#  Syntax highlighting
##
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=51'
ZSH_HIGHLIGHT_STYLES[function]='fg=51'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=39'
ZSH_HIGHLIGHT_STYLES[alias]='fg=75'
ZSH_HIGHLIGHT_STYLES[path]='fg=149'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=170'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=244'
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

##
#  FNM
##
eval "$(fnm env --use-on-cd)"

##
# Pyenv
##
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
function pyenv() {
  eval "$(command pyenv init - zsh)"
  pyenv "$@"
}

# The next line enables shell command completion for gcloud.
if [ -f '/Users/ivy/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/ivy/google-cloud-sdk/completion.zsh.inc'; fi

##
#  CUSTOM SCRIPTS
##
if [ -f "$HOME/.zsh/custom.zsh" ]; then
    source "$HOME/.zsh/custom.zsh"
fi

# Added by Windsurf
export PATH="/Users/ivy/.codeium/windsurf/bin:$PATH"

if [ -f "$HOME/.local/bin/env" ]; then
    . "$HOME/.local/bin/env"
fi
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/ivy/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
