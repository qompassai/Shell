# ~/.profile.d/12-aliases.sh

[[ $- == *i* ]] || return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias pytest='pytest -c ~/.config/pytest/pytest.ini'
alias spn='sudo pacman -Syyu --noconfirm'
alias psn='paru -Syyu --noconfirm'
alias cmx='chmod +x'
alias scrp='sudo chown -R $USER:$USER'

#dovecot
alias dvp='doveadm -c ~/.config/dovecot/dovecot.conf pw -s SHA512-CRYPT'
alias doveadm="doveadm -c $DOVECOT_CONF"
#Neovim
alias nv=nvim
alias sn='sudo -E nvim'
alias sv='sudo -E vim'

#Lua
alias lua='/usr/bin/lua5.1'
#Go
alias go_linux_amd64='go_cross_simple linux amd64'
alias go_linux_arm64='go_cross_simple linux arm64'
alias go_linux_arm="go_cross_simple linux arm"
alias go_windows_amd64="go_cross_simple windows amd64"
alias go_windows_arm64="go_cross_simple windows arm64"
alias go_darwin_amd64="go_cross_simple darwin amd64"
alias go_darwin_arm64="go_cross_simple darwin arm64"
alias go_freebsd_amd64="go_cross_simple freebsd amd64"
alias go_linux_amd64_cgo="go_cross_zig linux amd64"
alias go_linux_arm64_cgo="go_cross_zig linux arm64"
alias go_windows_amd64_cgo="go_cross_zig windows amd64"
alias go_darwin_amd64_cgo="go_cross_zig darwin amd64"
alias go_darwin_arm64_cgo="go_cross_zig darwin arm64"
alias use_zig="use_compiler zig"
alias use_clang="use_compiler clang"
alias use_gcc="use_compiler gcc"
alias go_cross_help="print_go_cross_help"

#QPG
#alias qpg="/opt/QAI/qpg/bin/qpg"
#alias qpg-connect-connect="/opt/QAI/qpg/bin/qpg-agent"
#alias qpgconf="/opt/QAI/qpg/bin/qpgconf"
#alias qdirmngr="/opt/QAI/qpg/libexec/dirmngr"
#alias qpg-connect-agent="opt/QAI/qpg/bin/qpg-connect-agent"

#Tor
alias tor='tor -f ~/.config/sextant/torrc'

#Zig
alias rzig=/opt/zig/bin/zig
