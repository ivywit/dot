#!/bin/zsh
# Phelps Witter IV Oh-My-Zsh theme

# History Control
setopt prompt_subst
setopt hist_ignore_all_dups
setopt hist_ignore_space

system=$(uname)

case "$system" in
    "Darwin")
        export LSCOLORS=fxHedxHxcxHxHxHxHxHxHx # OS X
        ;;
    "Linux")
        export LS_COLORS='di=34:ln=44:so=93:pi=37:ex=32:bd=37:cd=37:su=37:sg=37:tw=37:ow=37:' # linux
        ;;
esac

PURPLE=063 #141 #32
PINK=141 #106
ORANGE=178
GREEN=149
CURRENT_FG="NONE"

# SEGMENT
segment() {
    local fg
    [[ -n $2 ]] && fg="%F{$1}" || fg="%f"
    
    echo -n "%{$fg%}"
    [[ -n $2 ]] && echo -n $2
    
    CURRENT_FG=$1
}

# SEGMENT CAPS
prompt_end() {
    if [[ -n $CURRENT_FG ]]; then
        echo -n '%{%F{$CURRENT_FG}%}'
    else
        echo -n '%{%f%}'
    fi
    echo -n '%{%f%} '
    CURRENT_FG='NONE'
}

# USER PROMPT
prompt_user() {
    segment $PURPLE ' %n '
}

# HOST PROMPT
prompt_host() {
    segment $PINK ' %m '
}

# DIRECTORY
prompt_dir() {
    segment $GREEN ' %2~ '
}

# Checks if working tree is dirty
function parse_git_dirty() {
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}●%{$fg[white]%}%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_CLEAN=""

    local STATUS=''
    local -a FLAGS
    FLAGS=('--porcelain')
    FLAGS+='--ignore-submodules=dirty'
    FLAGS+='--untracked-files=no'
    STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
    if [[ -n $STATUS ]]; then
        echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
    else
        echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
    fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  local ref dirty mode repo_path
  repo_path=$(git rev-parse --git-dir 2>/dev/null)
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
      color=$GREEN
      dirty=$(parse_git_dirty)
      ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"

    if [[ -n $dirty ]]; then
        color=$ORANGE
    fi
    
    if [[ -e '${repo_path}/BISECT_LOG' ]]; then
      mode=' <B>'
    elif [[ -e '${repo_path}/MERGE_HEAD' ]]; then
      mode=' >M<'
    elif [[ -e '${repo_path}/rebase' || -e '${repo_path}/rebase-apply' || -e '${repo_path}/rebase-merge' || -e '${repo_path}/../.dotest' ]]; then
      mode=' >R>'
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:git:*' unstagedstr '●'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info
    segment $color " ( ${ref/refs\/heads\//%% }${vcs_info_msg_0_%% }${mode} )"
  fi
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
    local symbols
    symbols=()
    RETVAL=$?
    [[ $RETVAL -ne 0 ]] && symbols+='%{%F{red}%}x'
    [[ $UID -eq 0 ]] && symbols+='%{%F{yellow}%}+'
    [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+='%{%F{cyan}%}&'

    [[ -n '$symbols' ]] && segment default " $symbols "
}

# Typing Prompt
prompt_type() {
    CURRENT_FG='NONE'
    segment $ORANGE ' %D{%H:%M} '
}

# Left Prompt
build_left() {
    echo -n '%B'
    segment $PURPLE '['
    prompt_user
    segment $PINK '@'
    prompt_host
    segment $GREEN ':'
    prompt_dir
    segment $PURPLE ']'
    prompt_git
    prompt_status
    prompt_end
    echo -n '\n'
    segment $PURPLE '['
    prompt_type
    segment $PURPLE '>'
    prompt_end
    echo -n "%b"
}

export precmd() {
    PROMPT=$(build_left)
}
