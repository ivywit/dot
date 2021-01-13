##
#  ZSH Configuration of Ivy Witter
#  
#  Transitioning from oh-my-zsh to a slim custom config
##

[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return
export TERM=xterm-256color

##
#  TMUX
##
if which tmux 2>&1 >/dev/null; then
    if [ $TERM != "screen" ] && [ -z $TMUX ]; then
        tmux attach -t ds || tmux
    fi
fi

##
#  PROMPT
##
source $HOME/.zsh/prompt

##
#  EDITOR
##
export EDITOR='emacs'

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

##
#  HISTORY
##
HISTSIZE=50000
SAVEHIST=10000
HISTFILE=~/.zsh_history

autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '\e[A' history-beginning-search-backward-end
bindkey '\e[B' history-beginning-search-forward-end

##
#  ALIASES
##
source $HOME/.zsh/aliases

##
#  PATHS
##
export MANPATH="/usr/local/man:$MANPATH" # manual path
export SBINPATH="/usr/local/sbin" # sbin tools
export PATH="$SBINPATH:$PATH"
export CPATH="$CPATH:/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/usr/include"
##
#  Color functions
##
typeset -AHg FX FG BG

FX=(
    reset     "%{[00m%}"
    bold      "%{[01m%}" no-bold      "%{[22m%}"
    italic    "%{[03m%}" no-italic    "%{[23m%}"
    underline "%{[04m%}" no-underline "%{[24m%}"
    blink     "%{[05m%}" no-blink     "%{[25m%}"
    reverse   "%{[07m%}" no-reverse   "%{[27m%}"
)

for color in {000..255}; do
    FG[$color]="%F{$color}"
    BG[$color]="%B{$color}"
done

ZSH_SPECTRUM_TEXT=${ZSH_SPECTRUM_TEXT:-Arma virumque cano Troiae qui primus ab oris}

# Show all 256 colors with color number
function spectrum_ls() {
    for code in {000..255}; do
        print -P -- " %{$FG[$code]%}$code: $ZSH_SPECTRUM_TEXT%{$reset_color%}"
    done
}

# Show all 256 colors where the background is set to specific color
function spectrum_bls() {
    for code in {000..255}; do
      print -P -- "%{$BG[$code]%}$code: $ZSH_SPECTRUM_TEXT%{$reset_color%}"
    done
}

##
#  Ruby
##
export RBENV_ROOT="${HOME}/.rbenv"

if [ -d "${RBENV_ROOT}" ]; then
  export PATH="${RBENV_ROOT}/bin:${PATH}"
  eval "$(rbenv init -)"
fi

##
#  Google Cloud
### The next line enables shell command completion for gcloud.
if [ -f '/Users/ivy/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/ivy/google-cloud-sdk/completion.zsh.inc'; fi

unset lazy
autoload -Uz compinit && compinit -i

##
#  Syntax highlighting
##
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=045' #'fg=141'
ZSH_HIGHLIGHT_STYLES[function]='fg=214'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=174'
ZSH_HIGHLIGHT_STYLES[alias]='fg=219'
ZSH_HIGHLIGHT_STYLES[path]='fg=250,bold'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=190'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=245'

##
#  FASD
##
eval "$(fasd --init auto)"

##
#  Default Path
##
#export PATH="$RVM_DIR/bin:$PATH"

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fnm
eval "$(fnm env --multi)"

export CLOUDSDK_PYTHON=python3.8
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/ivy/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/ivy/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/ivy/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/ivy/google-cloud-sdk/completion.zsh.inc'; fi

##
#  DOCSEND
##

export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
export PATH="/Users/ivy/docsend/elaine/bin:$PATH"
