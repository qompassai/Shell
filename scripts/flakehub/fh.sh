#!/usr/bin/env bash
# FlakeHub workflow content for self-hosted runner
# add_flakehub_workflows.sh
# # ------------------------------------------
# Copyright (C) 2025 Qompass AI, All rights reserved
set -e

SEARCH_DIRS=(
    "/home/$USER/.GH/Qompass"
)

create_flakehub_workflow() {
    local repo_path="$1"
    local workflows_dir="$repo_path/.github/workflows"
    local workflow_file="$workflows_dir/fh.yml"

    echo "Creating FlakeHub workflow for: $repo_path"

    mkdir -p "$workflows_dir"

    cat > "$workflow_file" << 'EOF'
name: "Publish to FlakeHub"
on:
  push:
    branches: [main, master]
    tags: ["v*"]
  pull_request:
    branches: [main, master]

jobs:
  flakehub-publish:
    runs-on: self-hosted
    permissions:
      id-token: write
      contents: read
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Install Nix
        uses: DeterminateSystems/nix-installer-action@main

      - name: Setup Nix Magic Cache
        uses: DeterminateSystems/magic-nix-cache-action@main

      - name: Check if flake.nix exists
        id: check_flake
        run: |
          if [ -f "flake.nix" ]; then
            echo "has_flake=true" >> $GITHUB_OUTPUT
          else
            echo "has_flake=false" >> $GITHUB_OUTPUT
          fi

      - name: Publish to FlakeHub
        if: steps.check_flake.outputs.has_flake == 'true'
        uses: DeterminateSystems/flakehub-push@main
        with:
          visibility: public
          rolling: true

      - name: Skip - No flake.nix found
        if: steps.check_flake.outputs.has_flake == 'false'
        run: echo "No flake.nix found, skipping FlakeHub publish"
EOF

    echo "✓ Created workflow: $workflow_file"
}

find_git_repos() {
    local base_path="$1"

    if [ ! -d "$base_path" ]; then
        echo "Directory $base_path does not exist, skipping..."
        return
    fi

    echo "Searching for git repositories in: $base_path"

    # Use find to locate all .git directories
    while IFS= read -r -d '' git_dir; do
        repo_path=$(dirname "$git_dir")
        echo "Found git repository: $repo_path"

        # Check if it's actually a git repository (not just a .git file)
        if [ -d "$git_dir" ] || [ -f "$git_dir" ]; then
            create_flakehub_workflow "$repo_path"
        fi
    done < <(find "$base_path" -name ".git" -print0 2>/dev/null)
}

check_existing_workflows() {
    local repo_path="$1"
    local workflow_file="$repo_path/.github/workflows/fh.yml"

    if [ -f "$workflow_file" ]; then
        echo "⚠️  FlakeHub workflow already exists at: $workflow_file"
        read -p "Overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return 1
        fi
    fi
    return 0
}

process_nested_repos() {
    local base_path="$1"

    echo "Processing nested repositories in: $base_path"

    find "$base_path" -type d -name ".git" 2>/dev/null | while read -r git_dir; do
        repo_path=$(dirname "$git_dir")

        # Skip if this is a submodule or nested inside another .git
        parent_git=$(dirname "$repo_path")
        while [ "$parent_git" != "/" ] && [ "$parent_git" != "$base_path" ]; do
            if [ -d "$parent_git/.git" ]; then
                echo "Skipping nested repo: $repo_path (inside $parent_git)"
                continue 2
            fi
            parent_git=$(dirname "$parent_git")
        done

        echo "Processing repository: $repo_path"
        create_flakehub_workflow "$repo_path"
    done
}

main() {
    echo "🚀 Adding FlakeHub workflows to all git repositories..."
    echo "Using self-hosted runner configuration"
    echo ""

    for search_dir in "${SEARCH_DIRS[@]}"; do
        if [ -d "$search_dir" ]; then
            echo "🔍 Searching in: $search_dir"
            process_nested_repos "$search_dir"
            echo ""
        else
            echo "⚠️  Directory not found: $search_dir"
        fi
    done

    echo "✅ Finished adding FlakeHub workflows!"
    echo ""
    echo "Next steps:"
    echo "1. Review the generated workflows in each repository"
    echo "2. Commit and push the changes to trigger the workflows"
    echo "3. Ensure your repositories have flake.nix files to publish to FlakeHub"
    echo "4. Make sure your self-hosted runner has the necessary permissions"
}

main_with_checks() {
    echo "🔒 Safety checks enabled - will prompt before overwriting existing workflows"

    for search_dir in "${SEARCH_DIRS[@]}"; do
        if [ -d "$search_dir" ]; then
            echo "🔍 Searching in: $search_dir"

            find "$search_dir" -type d -name ".git" 2>/dev/null | while read -r git_dir; do
                repo_path=$(dirname "$git_dir")

                if check_existing_workflows "$repo_path"; then
                    create_flakehub_workflow "$repo_path"
                else
                    echo "Skipping: $repo_path"
                fi
            done
        fi
    done
}

if [ "$1" = "--safe" ]; then
    main_with_checks
else
    main
fi

