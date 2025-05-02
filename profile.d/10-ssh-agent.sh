if [ -z "${SSH_AUTH_SOCK-}" ] || ! [ -S "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)"
fi
export GPG_TTY=$(tty)
