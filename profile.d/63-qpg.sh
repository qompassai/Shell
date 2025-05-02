# /usr/bin/env/sh
# shellcheck
#Liboqs
export C_INCLUDE_PATH="/opt/QAI/liboqs/include:$C_INCLUDE_PATH"
export LIBRARY_PATH="/opt/QAI/liboqs/lib:$LIBRARY_PATH"
export LD_LIBRARY_PATH="/opt/QAI/liboqs/lib:$LD_LIBRARY_PATH"
export LIBOQS_INCLUDE_DIR="/opt/QAI/liboqs/include/oqs"
export LIBOQS_LIB_DIR="/opt/QAI/liboqs/lib"
export PKG_CONFIG_PATH="/opt/QAI/liboqs/lib/pkgconfig:$PKG_CONFIG_PATH"
#GPG
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export SSLKEYLOGFILE=/tmp/sslkeylog.log
#Pass
export PASSWORD_STORE_DIR="$HOME/.password-store"
#SSL
export CPRNG_SEED_SOURCE="jitterentropy"
export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
export JENT_DISABLE_STIR=1
export JENT_DISABLE_UNBIAS=1
export JENT_DISABLE_MEMORY_ACCESS=1
export JENT_OSR=128
export FIPS_MODULE_PATH="/opt/QAI/qompassl/lib64/ossl-modules/fips.so"
export FIPS_CONFIG_PATH="/opt/QAI/qompassl/ssl/fipsmodule.cnf"
export SSL_CERT_DIR=/etc/ssl/certs
export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
export OPENSSL_ENGINES=/usr/lib/engines-3:/opt/QAI/qompassl/lib64/engines-3
export OPENSSL_ia32cap
export CTLOG_FILE=/etc/ssl/ct_log_list.cnf
export OPENSSL_CONF=/etc/ssl/openssl.cnf
export OPENSSL_MODULES=/usr/lib/oss-modules/:/opt/QAI/qompassl/lib64/ossl-modules
export OSSL_MODULES=/opt/QAI/qompassl/lib64/ossl-modules
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1
export SSL_CERT_FILE=/etc/ssl/certs/cacert.pem
#Tor
export TORSOCKS_CONF_FILE=~/.config/sextant/torsocks.conf
#Tmp
export TMPDIR="$HOME/.tmp"
#TPM
export TPM2TOOLS_TCTI="swtpm:device=unixio,path=$XDG_RUNTIME_DIR/swtpm/swtpm-sock"
export TPM2_PKCS11_STORE="$XDG_DATA_HOME/tpm2-pkcs11"
export TSS2_FAPICONF="$HOME/.config/tpm2-tss/fapi-config.json"
export TPM2_PKCS11_STORE="$XDG_DATA_HOME/tpm2-pkcs11"
[[ ${PWD/$HOME\/.pw-ssh.sh\/} != ${PWD} ]] && exec ssh "$(basename "${PWD}")"
export GPG_TTY=$(tty)
alias qompassl=/opt/QAI/qompassl/bin/qompassl
if [ -z "$SSH_AUTH_SOCK" ];
then
    eval $(ssh-agent -s) ssh-add
fi
#eval $(keychain --eval --quiet --timeout 60 id_ed25519)
export PATH="$PATH:/opt/QAI/qompassl/bin/qompassl"
export LD_LIBRARY_PATH=/opt/QAI/qompassl/lib64:$LD_LIBRARY_PATH
#UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
