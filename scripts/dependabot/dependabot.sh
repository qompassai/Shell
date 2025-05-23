#!/usr/bin/env bash
# /qompassai/Shell/scripts/dependabot.sh
# -----------------------------------------
# Copyright (C) 2025 Qompass AI, All rights reserved

set -euo pipefail

print_usage() {
  echo "Usage: $0 --repo <owner/repo> [--token <token>] [--token-source pass|gh|sops|agenix]"
  echo ""
  echo "Examples:"
  echo "  $0 --repo qompassai/current --token-source pass"
  echo "  $0 --repo phaedrusflow/private-repo --token \$MY_PAT"
}

REPO=""
TOKEN=""
TOKEN_SOURCE=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --repo)
      REPO="$2"
      shift 2
      ;;
    --token)
      TOKEN="$2"
      shift 2
      ;;
    --token-source)
      TOKEN_SOURCE="$2"
      shift 2
      ;;
    -h|--help)
      print_usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      print_usage
      exit 1
      ;;
  esac
done

if [[ -z "$REPO" ]]; then
  echo "Error: --repo is required"
  print_usage
  exit 1
fi

if [[ -n "$TOKEN" ]]; then
  GITHUB_TOKEN="$TOKEN"
elif [[ "$TOKEN_SOURCE" == "pass" ]]; then
  GITHUB_TOKEN="$(pass show api/github)"
elif [[ "$TOKEN_SOURCE" == "gh" ]]; then
  GITHUB_TOKEN="$(gh auth token 2>/dev/null || true)"
  if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "❌ Error: GitHub CLI is not logged in. Run: gh auth login"
    exit 1
  fi
elif [[ "$TOKEN_SOURCE" == "sops" ]]; then
  GITHUB_TOKEN="$(sops -d ~/.secrets/github-token.yaml | yq '.github.token')"
elif [[ "$TOKEN_SOURCE" == "agenix" ]]; then
  GITHUB_TOKEN="$(cat /run/secrets/github-token)"  # agenix systemd secret
else
  echo "❌ Error: No token or token-source specified"
  print_usage
  exit 1
fi

docker run --rm -it \
  -v "$(pwd)/dependabot-config:/home/dependabot/dependabot-script/config" \
  -e REPO="$REPO" \
  -e GITHUB_ACCESS_TOKEN="$GITHUB_TOKEN" \
  dependabot/dependabot-core \
  bundle exec ruby ./generic-update-script.rb config/github.yml
