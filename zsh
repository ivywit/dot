##
#  ZSH Configuration of Ivy Witter
#  
#  Transitioning from oh-my-zsh to a slim custom config
##

[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return
export TERM=xterm-256color

#if command -v tmux>/dev/null; then
#   [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && exec tmux
#fi
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
#  PROMPT
##
source $HOME/.zsh_prompt

##
#  EDITOR
##
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='emacs'
else
    export EDITOR='emacs'
fi

fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i

##
#  ALIASES
##
source $HOME/.aliases

system=$(uname)
case "$system" in
    "Darwin" )
        alias finderhide='defaults write com.apple.finder AppleShowAllFiles FALSE; killall Finder'
        alias findershow='defaults write com.apple.finder AppleShowAllFiles TRUE; killall Finder'

        #export JAVA_HOME=`/usr/libexec/java_home`
        ;;
    "Linux" )
        #export JAVA_HOME="/usr/lib/jvm/java-8-oracle"
        ;;
esac

alias sequelize="./node_modules/.bin/sequelize"
alias irssi='TERM=screen-256color irssi'
alias pir='TERM=screen-256color proxychains4 irssi'

##
#  PATHS
##
export MANPATH="/usr/local/man:$MANPATH" # manual path
export GOPATH="/usr/local/opt/go/libexec"
export SCALAPATH="/usr/local/opt/scala@2.11/bin" # scala
export SBINPATH="/usr/local/sbin" # sbin tools
export RVMPATH="$HOME/.rvm/bin" # RVM
export VSCODEPATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="$SCALAPATH:$SBINPATH:$RVMPATH:$VSCODEPATH:$PATH"
export NVM_DIR="$HOME/.nvm" # NVM

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/opt/google-cloud-sdk/path.zsh.inc' ]; then source '/opt/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/opt/google-cloud-sdk/completion.zsh.inc' ]; then source '/opt/google-cloud-sdk/completion.zsh.inc'; fi

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/iv/.nvm/versions/node/v8.12.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/iv/.nvm/versions/node/v8.12.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/iv/.nvm/versions/node/v8.12.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/iv/.nvm/versions/node/v8.12.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /Users/iv/.nvm/versions/node/v8.12.0/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh ]] && . /Users/iv/.nvm/versions/node/v8.12.0/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh
