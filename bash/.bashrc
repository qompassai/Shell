# /qompassai/Shell/bash/.bashrc
# -----------------------------
# Copyright (C) 2025 Qompass AI, All rights reserved
[[ $- != *i* ]] && return
[ -f "$HOME/.bash_profile" ] && . "$HOME/.bash_profile"
PS1='[\u@\h \W]\$ '
