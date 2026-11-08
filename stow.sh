#!/bin/bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
PACKAGE="home"

usage() {
    echo "Usage: $0 apply | adopt <absolute path>"
    exit 1
}

die() {
    echo "[ ERROR ] $1" >&2
    exit 1
}

ensure_stow() {
    command -v stow >/dev/null && return
    if command -v pacman >/dev/null; then
        sudo pacman -S --needed stow
    elif command -v apt-get >/dev/null; then
        sudo apt-get update -y
        sudo apt-get install -y --no-install-recommends stow
    else
        die "No supported package manager to install stow"
    fi
}

# --adopt pulls existing files from $HOME into the repo so stow can link them,
# then git restore puts back the repo version. Local changes are stashed first
# so the restore does not discard them.
cmd_apply() {
    ensure_stow
    cd "$DOTFILES"

    local stashed=false
    if ! git diff --quiet || ! git diff --cached --quiet; then
        git stash push -q -m "stow.sh apply"
        stashed=true
    fi

    stow --adopt -v -t "$HOME" "$PACKAGE"
    git restore .
    stow --restow -t "$HOME" "$PACKAGE"

    if $stashed && ! git stash pop -q; then
        die "Could not restore local changes. Resolve conflicts and run 'git stash pop'"
    fi
    echo "[ OK ] Applied"
}

cmd_adopt() {
    local path="${1%/}"
    local rel="${path#"$HOME"/}"
    local dest="$DOTFILES/$PACKAGE/$rel"

    [[ $path == "$HOME"/* ]] || die "$path is not inside $HOME"
    [[ -e $path ]] || die "$path does not exist"
    [[ -L $path ]] && die "$path is a symlink, already managed?"
    [[ -e $dest ]] && die "$dest already exists"

    mkdir -p "$(dirname "$dest")"
    mv "$path" "$dest"
    echo "[ OK ] Moved $path to $dest"
    cmd_apply
}

case "${1:-}" in
    apply) cmd_apply ;;
    adopt) [[ $# -eq 2 ]] || usage; cmd_adopt "$2" ;;
    *) usage ;;
esac
