#!/usr/bin/env sh
# /qompassai/Shell/.profile.d/52-js.sh
# Copyright (C) 2025 Qompass AI, All rights reserved
####################################################

export BUN_INSTALL="$HOME/.bun"
export DENO_DIR="$HOME/.cache/deno"
export DENO_INSTALL_ROOT="$HOME/.deno"
export NODE_ENV="development"
export NODE_OPTIONS="--max-old-space-size=8192"
export NPM_CONFIG_CACHE="$HOME/.cache/npm"
export NPM_CONFIG_PREFIX="$HOME/.local"
export NVM_DIR="$HOME/.config/nvm"
export PNPM_HOME="$HOME/.local/share/pnpm"
export YARN_CACHE_FOLDER="$HOME/.cache/yarn"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$DENO_INSTALL_ROOT/bin:$PATH"
export PATH="$PNPM_HOME:$PATH"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"



jsproject() {
    local project_name="${1:-new-project}"
    mkdir -p "$project_name"
    cd "$project_name" || return 1

    npm init -y

    mkdir -p src tests docs
    echo "console.log('Hello, World!');" > src/index.js
    echo "# $project_name\n\nA new JavaScript project." > README.md
    echo "node_modules/\n*.log\n.env" > .gitignore
    echo "Created JavaScript project: $project_name"
}

jsversions() {
    echo "=== JavaScript Ecosystem Versions ==="
    command -v node >/dev/null && echo "Node.js: $(node --version)"
    command -v npm >/dev/null && echo "npm: $(npm --version)"
    command -v yarn >/dev/null && echo "Yarn: $(yarn --version)"
    command -v pnpm >/dev/null && echo "pnpm: $(pnpm --version)"
    command -v bun >/dev/null && echo "Bun: $(bun --version)"
    command -v deno >/dev/null && echo "Deno: $(deno --version | head -1)"
    echo ""
    [ -s "$NVM_DIR/nvm.sh" ] && echo "Available Node versions:" && nvm list
}

jsclean() {
    echo "Cleaning JavaScript package manager caches..."
    command -v npm >/dev/null && npm cache clean --force
    command -v yarn >/dev/null && yarn cache clean
    command -v pnpm >/dev/null && pnpm store prune
    command -v bun >/dev/null && bun pm cache rm
    echo "Cache cleanup completed."
}

jsaudit() {
    echo "=== JavaScript Security Audit ==="
    if [ -f "package-lock.json" ]; then
        echo "Running npm audit..."
        npm audit
    elif [ -f "yarn.lock" ]; then
        echo "Running yarn audit..."
        yarn audit
    elif [ -f "pnpm-lock.yaml" ]; then
        echo "Running pnpm audit..."
        pnpm audit
    elif [ -f "bun.lockb" ]; then
        echo "Running bun audit..."
        bun audit
    else
        echo "No lock file found. Run from a JavaScript project directory."
    fi
}
export -f jsproject jsversions jsclean jsaudit
