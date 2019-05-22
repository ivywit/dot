##
#  ZSH Configuration of Ivy Witter
#  
#  Transitioning from oh-my-zsh to a slim custom config
##

[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return
export TERM=xterm-256color

##
#  PROMPT
##
source $HOME/.zsh_prompt

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

nvmLazy() {
    nvmpath=$1
    nvmsources=(${(s: :)2})
    nvmpossibleCommands=(${(s: :)3})
    for command in $nvmpossibleCommands; do        
        $command() {
            local thisCommand="$0"
            echo 'loading...'
            if [[ -d $nvmpath ]]; then
                unfunction ${nvmpossibleCommands}
                for sourcePath in $nvmsources; do
                    source ${sourcePath}
                done
                ${thisCommand} "$@"
            else
                echo "$thisCommand is not installed" >&2
                return 1
            fi
        }
    done
}

rvmLazy() {
    rvmpath=$1
    rvmcompletion=$2
    rvmpossibleCommands=(${(s: :)3})
    for command in $rvmpossibleCommands; do        
        $command() {
            local thisCommand="$0"
            echo 'loading...'
            if [[ -d $rvmpath ]]; then
                unfunction ${rvmpossibleCommands}
                fpath=($rvmcompletion $fpath)
                autoload -Uz compinit && compinit -i
                ${thisCommand} "$@"
            else
                echo "$thisCommand is not installed" >&2
                return 1
            fi
        }
    done
}

googleLazy() {
    googlepath=$1
    googlesources=(${(s: :)2})
    googlepossibleCommands=(${(s: :)3})
    for command in $googlepossibleCommands; do        
        $command() {
            local thisCommand="$0"
            echo 'loading...'
            if [[ -d $googlepath ]]; then
                unfunction ${googlepossibleCommands}
                for sourcePath in $googlesources; do
                    source ${sourcePath}
                done
                ${thisCommand} "$@"
            else
                echo "$thisCommand is not installed" >&2
                return 1
            fi
        }
    done
}

##
#  ALIASES
##
source $HOME/.aliases

##
#  PATHS
##
export MANPATH="/usr/local/man:$MANPATH" # manual path
export SBINPATH="/usr/local/sbin" # sbin tools
export PATH="$SBINPATH:$PATH"

##
#  Node Version Manager
##
NVM_DIR="$HOME/.nvm" # NVM
NVM_SOURCES="$NVM_DIR/bash_completion $NVM_DIR/nvm.sh"
NVM_CMDS="nvm node npm"
nvmLazy $NVM_DIR $NVM_SOURCES $NVM_CMDS

##
#  Ruby Version Manager
##
RVM_DIR=$HOME/.rvm # RVM
export PATH="$RVM_DIR/bin:$PATH"
RVM_CMDS="rvm ruby irb rails"
RVM_COMPLETION="$RVM_DIR/scripts/zsh/Completion/_rvm"
rvmLazy $RVM_DIR $RVM_COMPLETION $RVM_CMDS

##
#  Google Cloud
##
GOOGLE_DIR="/opt/google-cloud-sdk"
GOOGLE_SOURCES="$GOOGLE_DIR/path.zsh.inc $GOOGLE_DIR/completion.zsh.inc"
GOOGLE_CMDS="gcloud kubectl"
googleLazy $GOOGLE_DIR $GOOGLE_SOURCES $GOOGLE_CMDS

unset lazy
autoload -Uz compinit && compinit -i

##
#  Syntax highlighting
##
# export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters
# typeset -A ZSH_HIGHLIGHT_STYLES
# ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
# ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
# source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
