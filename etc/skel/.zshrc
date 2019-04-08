source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
powerline-daemon -q
ZSH_THEME="agnoster" # (this is one of the fancy ones)
source /usr/lib/python3.7/site-packages/powerline/bindings/zsh/powerline.zsh
function datecode(){ date +%H.%M.%S_%m.%d.%Y ; return 0 ; }
