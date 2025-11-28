#!/usr/bin/env sh
# /qompassai/shell/scripts/quickstart.sh
# Qompass AI Shell Quickstart Script
# Copyright (C) 2025 Qompass AI
########################################
set -eu
print() { printf '[shellcv]: %s\n' "$1"; }
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
LOCAL_PREFIX="${LOCAL_PREFIX:-$HOME/.local}"
BIN_PATH="$LOCAL_PREFIX/bin"
mkdir -p "$BIN_PATH"
BANNER() {
        printf '╭────────────────────────────────────────────╮\n'
        printf '│    Qompass AI · Shell Quick‑Start          │\n'
        printf '╰────────────────────────────────────────────╯\n'
        printf '    © 2025 Qompass AI. All rights reserved   \n\n'
}
SHELL_MENU="
1|bash
2|zsh
3|fish
a|All
q|Quit
"
show_menu() {
        echo "Which shell(s) would you like to install/update?"
        echo "$SHELL_MENU" | while IFS="|" read num name; do
                [ -z "$num" ] && continue
                [ "$num" = "q" ] && {
                        echo " q) Quit"
                        break
                }
                [ "$num" = "a" ] && {
                        echo " a) All of the above"
                        continue
                }
                echo " $num) $name"
        done
        printf "Choose [1]: "
}
install_shell() {
        name="$1"
        case "$name" in
        bash)
                print "Installing bash (user-local, if possible)..."
                if command -v bash >/dev/null 2>&1; then
                        print "bash already installed: $(command -v bash)"
                else
                        if command -v pacman >/dev/null 2>&1; then
                                print "Installing with pacman (if needed)"
                                sudo pacman -S --needed bash
                        elif command -v apt-get >/dev/null 2>&1; then
                                print "Installing with apt-get (if needed)"
                                sudo apt-get install -y bash
                        else
                                print "Building bash from source in ~/.local..."
                                curl -LO https://ftp.gnu.org/gnu/bash/bash-5.2.21.tar.gz
                                tar -xzf bash-5.2.21.tar.gz && cd bash-5.2.21
                                ./configure --prefix="$LOCAL_PREFIX"
                                make -j"$(nproc)"
                                make install
                                cd .. && rm -rf bash-5.2.21*
                        fi
                fi
                echo "To persistently use bash configs:"
                echo "  Edit ~/.bashrc or $XDG_CONFIG_HOME/bash/bashrc"
                ;;
        zsh)
                print "Installing zsh (user-local, if possible)..."
                if command -v zsh >/dev/null 2>&1; then
                        print "zsh already installed: $(command -v zsh)"
                else
                        if command -v pacman >/dev/null 2>&1; then
                                print "Installing with pacman"
                                sudo pacman -S --needed zsh
                        elif command -v apt-get >/dev/null 2>&1; then
                                print "Installing with apt-get"
                                sudo apt-get install -y zsh
                        else
                                print "Building zsh from source in ~/.local..."
                                curl -LO https://downloads.sourceforge.net/project/zsh/zsh/5.9/zsh-5.9.tar.xz
                                tar -xf zsh-5.9.tar.xz && cd zsh-5.9
                                ./configure --prefix="$LOCAL_PREFIX"
                                make -j"$(nproc)"
                                make install
                                cd .. && rm -rf zsh-5.9*
                        fi
                fi
                echo "To persistently use zsh configs:"
                echo "  Edit ~/.zshrc or $XDG_CONFIG_HOME/zsh/.zshrc"
                ;;
        fish)
                print "Installing fish (user-local, if possible)..."
                if command -v fish >/dev/null 2>&1; then
                        print "fish already installed: $(command -v fish)"
                else
                        if command -v pacman >/dev/null 2>&1; then
                                print "Installing with pacman"
                                sudo pacman -S --needed fish
                        elif command -v apt-get >/dev/null 2>&1; then
                                print "Installing with apt-get"
                                sudo apt-get install -y fish
                        else
                                print "Building fish from source in ~/.local..."
                                curl -LO https://github.com/fish-shell/fish-shell/releases/download/3.7.1/fish-3.7.1.tar.xz
                                tar -xf fish-3.7.1.tar.xz && cd fish-3.7.1
                                cmake -DCMAKE_INSTALL_PREFIX="$LOCAL_PREFIX" .
                                make -j"$(nproc)"
                                make install
                                cd .. && rm -rf fish-3.7.1*
                        fi
                fi
                echo "To persistently use fish configs:"
                echo "  Edit ~/.config/fish/config.fish"
                ;;
        *)
                print "Unknown shell: $name"
                ;;
        esac
}
while :; do
        BANNER
        show_menu
        read -r CHOICE
        [ -z "$CHOICE" ] && CHOICE=1
        case "$CHOICE" in
        1)
                install_shell "bash"
                ;;
        2)
                install_shell "zsh"
                ;;
        3)
                install_shell "fish"
                ;;
        a | A)
                install_shell "bash"
                install_shell "zsh"
                install_shell "fish"
                ;;
        q | Q)
                print "Goodbye!"
                exit 0
                ;;
        *)
                print "Invalid option."
                ;;
        esac
        echo
        printf "Press enter to return to menu..."
        read -r dummy
        clear
done
