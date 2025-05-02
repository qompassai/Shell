#!/bin/bash
# 60-tor.sh — Rootless Tor XDG + dynamic IP support for Hyprland

export TOR_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/tor"
export TOR_DATA_HOME="$TOR_CONFIG_HOME/data"

# Ensure Tor data directory exists with strict permissions
mkdir -p "$TOR_DATA_HOME"
chmod 700 "$TOR_DATA_HOME"

# Dynamically resolve IP addresses for LAN and IPv6
export TOR_IPV4=$(ip route get 1.1.1.1 2>/dev/null | awk '/src/ {print $NF; exit}')
export TOR_IPV6=$(ip -6 addr show scope global | awk '/inet6/ {print $2}' | cut -d/ -f1 | head -n1)

# Create dynamic torrc if template exists
TEMPLATE="$TOR_CONFIG_HOME/torrc.template"
FINAL="$TOR_CONFIG_HOME/torrc"

if [[ -f "$TEMPLATE" ]]; then
    envsubst < "$TEMPLATE" > "$FINAL"
fi

# Optional: expose env vars for scripts/clients using control port
export TOR_SOCKS_PORT="9050"
export TOR_CONTROL_PORT="9051"
