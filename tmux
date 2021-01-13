if-shell 'test -e "$HOME/.tmux-boot.conf"' 'source-file "$HOME/.tmux-boot.conf"'

set -g mouse on

# set 256 color
set -g default-terminal "screen-256color"

#
# status bar
#
set -g status-style fg="#FFFFFF",bg="#1A1A1A"

set -g status-left " #[fg=colour63][ #[fg=colour178]#S #[fg=colour63]] "

set -g status-right "#[fg=colour63] %Y/%m/%d %H:%M  #[fg=colour149] #(~/.tmux/battery.sh) "

set -g window-status-format "#[fg=#454545]  #W #F "

set -g window-status-current-format "#[fg=colour63]( #[fg=colour141]#W #F#[fg=colour63])"