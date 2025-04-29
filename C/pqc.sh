#!/usr/bin/env bash
# ------------------------------------------------------------
# openssl-pqc-test.sh
# Smoke-tests every signature algorithm OpenSSL currently knows
# and produces a Markdown report on stdout.
# ------------------------------------------------------------

set -euo pipefail

### --- User-specific paths (edit if needed) ------------------
# Where your custom openssl.cnf lives:
OPENSSL_CONF=${OPENSSL_CONF:-/opt/qompassl/ssl/openssl.cnf}
# Directory that holds oqsprovider.so, fips.so, etc.:
OPENSSL_MODULES=${OPENSSL_MODULES:-/opt/qompassl/lib64/ossl-modules}
export OPENSSL_CONF OPENSSL_MODULES
### -----------------------------------------------------------

PROVIDERS=(-provider default )

WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT

REPORT="$WORKDIR/report.md"
printf "| Algorithm | Key-gen | Sign | Verify | Notes |\n" >  "$REPORT"
printf "|-----------|--------|------|--------|-------|\n"          >> "$REPORT"

# Pull every algorithm that can *sign* from the provider list
mapfile -t ALGS < <(
    openssl list -signature-algorithms "${PROVIDERS[@]}" \
        | awk -F '@' '{print $1}' \
        | sed 's/^ *//;s/ *$//' \
        | sort -u
)
for ALG in "${ALGS[@]}"; do
    KEY="$WORKDIR/${ALG// /_}.key"
    PUB="$WORKDIR/${ALG// /_}.pub"
    SIG="$WORKDIR/${ALG// /_}.sig"
    MSG="$WORKDIR/msg.txt"
    printf "testing %-30s ... " "$ALG"
    echo "Quantum-test" > "$MSG"
    keygen_status=sign_status=verify_status=FAIL
    notes=""
    # ---------- key-gen ----------
    if openssl genpkey -algorithm "$ALG" -out "$KEY" "${PROVIDERS[@]}" 2> /dev/null; then
        keygen_status="OK"
        # ---------- sign ----------
        if openssl pkeyutl -sign -inkey "$KEY" -in "$MSG" -out "$SIG" \
            "${PROVIDERS[@]}" 2> /dev/null; then
            sign_status="OK"
            # ---------- verify ----------
            openssl pkey -in "$KEY" -pubout -out "$PUB" "${PROVIDERS[@]}" 2> /dev/null
            if openssl pkeyutl -verify -pubin -inkey "$PUB" -in "$MSG" \
                -sigfile "$SIG" "${PROVIDERS[@]}" 2> /dev/null; then
                verify_status="OK"
            fi
        fi
    fi
    if [[ $keygen_status != OK ]]; then
        notes="❌ Key-gen failed → algorithm not enabled or provider missing"
    elif [[ $sign_status != OK ]]; then
        notes="❌ Sign failed → ${ALG} may be KEM-only (no signing)"
    elif [[ $verify_status != OK ]]; then
        notes="❌ Verify failed → probable provider mismatch"
    else
        notes="✅ All good"
    fi

    printf "| \`%s\` | %s | %s | %s | %s |\n" \
        "$ALG" "$keygen_status" "$sign_status" "$verify_status" "$notes" >> "$REPORT"

    echo "done"
done

cat "$REPORT"
