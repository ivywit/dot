##
#  Color functions
##

ZSH_SPECTRUM_TEXT=${ZSH_SPECTRUM_TEXT:-Arma virumque cano Troiae qui primus ab oris}
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
