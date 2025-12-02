system=$(uname)
case "$system" in
    "Darwin" )
        alias finderhide='defaults write com.apple.finder AppleShowAllFiles FALSE; killall Finder'
        alias findershow='defaults write com.apple.finder AppleShowAllFiles TRUE; killall Finder'
        alias cltreinstall='sudo rm -rf /Library/Developer/CommandLineTools; xcode-select --install'
        ;;
    "Linux" )
        ;;
esac
