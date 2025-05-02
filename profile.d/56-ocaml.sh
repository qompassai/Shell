# ~/.profile.d/50-ocaml.sh

if [[ -r "$HOME/.opam/opam-init/init.sh" ]]; then
    . "$HOME/.opam/opam-init/init.sh" > /dev/null 2> /dev/null || true
fi

export OPAMROOT="$HOME/.opam"
export PATH="$HOME/.opam/default/bin:$PATH"
export DUNE_CACHE=enabled
export OCAMLRUNPARAM="b"
export OCAMLFORMAT_PROFILE=conventional

test -r '/home/phaedrus/.opam/opam-init/init.sh' && . '/home/phaedrus/.opam/opam-init/init.sh' >/dev/null 2>/dev/null || true


## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[ -f /home/phaedrus/.config/.dart-cli-completion/bash-config.bash ] && . /home/phaedrus/.config/.dart-cli-completion/bash-config.bash || true
## [/Completion]
