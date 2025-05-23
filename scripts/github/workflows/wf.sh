#!/usr/bin/env bash
# /qompassai/Shell/scripts/workflows/wf.sh
# -------------------------------------------
# Copyright (C) 2025 Qompass AI, All rights reserved

set -euo pipefail

ORG="qompassai"
WORKFLOW_NAME="main.yml"
WORKFLOW_PATH=".github/workflows/$WORKFLOW_NAME"
GH_PAT="$(pass show gh/pat)"
export GH_TOKEN="$GH_PAT"

DRY_RUN=false
BRANCH_MODE="main"

while [[ $# -gt 0 ]]; do
  case $1 in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --branch)
      BRANCH_MODE="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

WORKFLOW_CONTENT=$(cat <<'EOF'
name: CI
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: [self-hosted, arch, Linux, X64]
    steps:
      - uses: actions/checkout@v4
      - name: Print system info
        run: |
          uname -a
          lscpu
EOF
)

REPO_ROOT="${REPO_ROOT:-$HOME/.GH/Qompass}"
REPOS=$(find "$REPO_ROOT" -type d -name ".git" -exec dirname {} \;)

echo "🔍 Scanning nested Git repos in $REPO_ROOT..."

echo "$REPOS" | while IFS= read -r REPO_DIR; do
  if [[ ! -d "$REPO_DIR/.git" ]]; then continue; fi

  pushd "$REPO_DIR" >/dev/null

  REPO_NAME=$(basename "$(git config --get remote.origin.url | cut -d':' -f2 | cut -d'.' -f1 || echo "$REPO_DIR")")
  DEFAULT_BRANCH=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | cut -d'/' -f2 || echo "main")

  echo "📦 Processing: $REPO_NAME [$DEFAULT_BRANCH]"

  if [[ -f ".github/workflows/$WORKFLOW_NAME" || -f ".github/workflows/main.yaml" ]]; then
    echo "✅ $REPO_NAME already has $WORKFLOW_NAME, skipping."
    popd >/dev/null
    continue
  fi

  mkdir -p ".github/workflows"
  echo "$WORKFLOW_CONTENT" > ".github/workflows/$WORKFLOW_NAME"
  git config user.name "Qompass Current"
  git config user.email "current@qompass.ai"
  git add ".github/workflows/$WORKFLOW_NAME"
  git commit -m "Add self-hosted CI workflow"

  if [[ "$DRY_RUN" == true ]]; then
    echo "🧪 [DRY RUN] Would push to $REPO_NAME:$BRANCH_MODE"
  else
    if [[ "$BRANCH_MODE" != "$DEFAULT_BRANCH" ]]; then
      git checkout -b "$BRANCH_MODE"
    fi
    git push origin HEAD:"$BRANCH_MODE"
    echo "🚀 Pushed workflow to $REPO_NAME"
  fi

  popd >/dev/null
done

