#!/bin/bash

# Clone required external projects for dotfiles
# These projects are dependencies referenced in various configs

set -e

PROJECTS_DIR="$HOME/projects"
GITHUB_USER="StephenGunn"

mkdir -p "$PROJECTS_DIR"
cd "$PROJECTS_DIR"

clone_if_missing() {
    local repo="$1"
    if [ -d "$repo" ]; then
        echo "✓ $repo already exists, skipping"
    else
        echo "Cloning $repo..."
        git clone "git@github.com:$GITHUB_USER/$repo.git"
    fi
}

echo "Cloning required projects to $PROJECTS_DIR..."
echo

clone_if_missing "theme-switcher"
clone_if_missing "privacy-daemon"
clone_if_missing "nvim-svelte-snippets"

echo
echo "Done! All required projects are in $PROJECTS_DIR"
