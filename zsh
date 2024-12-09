##
#  ZSH Configuration of Ivy Witter
#  
#  A slim custom config
##

##
#  TMUX
##
if which tmux 2>&1 >/dev/null; then
    if [ $TERM != "screen" ] && [ -z $TMUX ]; then
        tmux attach -t chaos || tmux
    fi
fi

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
# The next line enables shell command completion for gcloud.
if [ -f '$HOME/google-cloud-sdk/completion.zsh.inc' ]; then
    '$HOME/google-cloud-sdk/completion.zsh.inc'
fi
if [ -f '/usr/local/bin/aws_completer' ]; then
    complete -C '/usr/local/bin/aws_completer' aws
fi

##
#  COMPINIT
##
# autoload -Uz compinit
# # only check once per day
# if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump) ]; then
#     compinit
# else
#     compinit -C
# fi

##
#  HISTORY
##
# autoload -U history-search-end
# zle -N history-beginning-search-backward-end history-search-end
# zle -N history-beginning-search-forward-end history-search-end
# bindkey '\e[A' history-beginning-search-backward-end
# bindkey '\e[B' history-beginning-search-forward-end

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
ZSH_HIGHLIGHT_STYLES[command]='fg=141'
ZSH_HIGHLIGHT_STYLES[function]='fg=178'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=178'
ZSH_HIGHLIGHT_STYLES[alias]='fg=141'
ZSH_HIGHLIGHT_STYLES[path]='fg=149'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=149'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=242'
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

##
#  FASD
##
# eval "$(fasd --init auto)"

##
#  FNM
##
eval "$(fnm env --use-on-cd)"

# The next line enables shell command completion for gcloud.
if [ -f '/Users/ivy/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/ivy/google-cloud-sdk/completion.zsh.inc'; fi

##
#  CUSTOM SCRIPTS
##
if [ -f "$HOME/.zsh/custom.zsh" ]; then
    source "$HOME/.zsh/custom.zsh"
fi
