export XDG_CONFIG_HOME="$HOME/.config"
export PATH=/usr/lib/ccache/bin:/usr/lib/node_modules:$PATH
export CHROME_DEVEL_SANDBOX=/usr/local/sbin/chrome-devel-sandbox

[[ -f ~/.bashrc ]] && . ~/.bashrc

# start x
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

setxkbmap -option ctrl:nocaps

