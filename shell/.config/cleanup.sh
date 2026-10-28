#!/usr/bin/env bash

cleanup_npm() {
    command -v npm >/dev/null || { printf 'not installed\n'; return; }
    if [[ ${1:-} == dry ]]; then
        local path
        path=$(npm config get cache 2>/dev/null) || { printf 'unknown'; return; }
        cleanup_size "$path/_cacache"
    else
        npm cache clean --force
    fi
}

cleanup_uv() {
    command -v uv >/dev/null || { printf 'not installed\n'; return; }
    if [[ ${1:-} == dry ]]; then
        local path
        path=$(uv cache dir 2>/dev/null) || { printf 'unknown'; return; }
        cleanup_size "$path"
    else
        uv cache prune
    fi
}

cleanup_pnpm() {
    command -v pnpm >/dev/null || { printf 'not installed\n'; return; }
    if [[ ${1:-} == dry ]]; then
        local path
        path=$(pnpm store path --silent 2>/dev/null) || { printf 'unknown'; return; }
        cleanup_size "$path"
    else
        pnpm store prune
    fi
}

cleanup_bun() {
    command -v bun >/dev/null || { printf 'not installed\n'; return; }
    if [[ ${1:-} == dry ]]; then
        local path
        path=$(bun pm --global cache 2>/dev/null) || { printf 'unknown'; return; }
        cleanup_size "$path"
    else
        bun pm --global cache rm
    fi
}

cleanup_flatpak() {
    command -v flatpak >/dev/null || { printf 'not installed\n'; return; }
    if [[ ${1:-} == dry ]]; then
        printf 'unknown'
    else
        flatpak uninstall --system --unused
    fi
}

cleanup_pacman() {
    command -v paccache >/dev/null || { printf 'not installed\n'; return; }
    if [[ ${1:-} == dry ]]; then
        cleanup_size /var/cache/pacman/pkg
    else
        sudo paccache -rk2
    fi
}

cleanup_apt() {
    command -v apt >/dev/null || { printf 'not installed\n'; return; }
    if [[ ${1:-} == dry ]]; then
        cleanup_size /var/cache/apt/archives
    else
        sudo apt autoclean
    fi
}

cleanup_journal() {
    command -v journalctl >/dev/null || { printf 'not installed\n'; return; }
    if [[ ${1:-} == dry ]]; then
        cleanup_size /var/log/journal 524288000
    else
        sudo journalctl --quiet --rotate --vacuum-size=500M
    fi
}

cleanup_all() {
    if [[ ${1:-} == dry ]]; then
        printf 'varies'
        return
    fi
    local action
    local -a failed=()
    for action in npm uv pnpm bun flatpak pacman apt journal; do
        printf '\n== %s ==\n' "$action"
        "cleanup_$action" || failed+=("$action")
    done
    if (( ${#failed[@]} )); then
        printf 'Failed tasks: %s\n' "${failed[*]}" >&2
        return 1
    fi
}

cleanup_size() {
    local path=$1 reserve=${2:-0} size bytes
    if [[ -z $path ]]; then
        printf 'unknown'
        return
    fi
    if [[ ! -d $path ]]; then
        printf '0 B'
        return
    fi
    size=$(du -sk -- "$path" 2>/dev/null) || {
        printf 'unknown'
        return
    }
    bytes=$(( ${size%%[[:space:]]*} * 1024 ))
    bytes=$(( bytes > reserve ? bytes - reserve : 0 ))
    printf '<= %s' "$(numfmt --to=iec-i --suffix=B "$bytes")"
}

cleanup_toolchains() {
    printf '\nToolchain inventory — review only; nothing is removed.\n'
    printf 'Multiple versions may be required by different projects or packages.\n'
    cleanup_system_toolchains

    if command -v rustup >/dev/null; then
        printf '\n== Rust toolchains ==\n'
        rustup toolchain list
    fi
    if command -v fnm >/dev/null; then
        printf '\n== Node versions (fnm) ==\n'
        fnm list
    fi

    local path
    printf '\n== User toolchain disk usage ==\n'
    for path in "$HOME"/.rustup/toolchains/* \
        "$HOME"/.local/share/fnm/node-versions/* \
        "$HOME"/.platformio/packages/toolchain-*; do
        [[ -d $path ]] && du -sh -- "$path"
    done
    return 0
}

cleanup_system_toolchains() {
    command -v pacman >/dev/null || return 0
    local package version
    printf '\n== System toolchains ==\n'
    printf '%-32s %-26s %s\n' PACKAGE VERSION 'SIZE / REQUIRED BY / OPTIONAL FOR'
    while read -r package version; do
        case "$package" in
            arm-none-eabi-*|riscv64-elf-*|avr-*|gcc|gcc-fortran|clang|clang[0-9]*|llvm|llvm[0-9]*|lld|lld[0-9]*|jdk*|jre*|rust|rustup|go|zig|dotnet-sdk)
                printf '\n%-32s %s\n' "$package" "$version"
                LC_ALL=C pacman -Qi "$package" | awk '
                    /^(Installed Size|Required By|Optional For)[[:space:]]*:/ { print "  " $0 }
                '
                ;;
        esac
    done < <(pacman -Q)
}

cleanup_table() {
    local action number=1
    printf '\n%-4s %-12s %s\n' '#' 'CLEANUP' 'EST. SAVING'
    printf '%-4s %-12s %s\n' '---' '------------' '----------------'
    for action in npm uv pnpm bun flatpak pacman apt journal; do
        printf '%-4s %-12s %s\n' "$number" "$action" "$("cleanup_$action" dry)"
        (( number += 1 ))
    done
    printf '%-4s %-12s %s\n' 9 all "$(cleanup_all dry)" 0 quit '-'
    printf '%-4s %-12s %s\n' t toolchains 'read-only inventory'
    printf '\nUpper bounds only: pruning, shared files and active logs may save less.\n'
}

cleanup_menu() {
    local choice action before after status=0
    local -a actions=(npm uv pnpm bun flatpak pacman apt journal all)
    printf 'Cache cleanup only. Browser data and installed tools are not touched.\n'

    cleanup_table
    while true; do
        read -r -p 'Clean cache (number, q to quit): ' choice || return 0
        case "$choice" in
            0|q) return 0 ;;
            t) cleanup_toolchains; return $? ;;
            [1-9]) action=${actions[choice - 1]}; break ;;
            *) printf 'Choose a number from the table.\n'; continue ;;
        esac
    done

    before=$(df -h /)
    "cleanup_$action" || status=$?
    after=$(df -h /)
    printf '\nBefore:\n%s\n\nAfter:\n%s\n' "$before" "$after"
    if (( status )) && [[ $action != all ]]; then
        printf 'Cleanup failed: %s\n' "$action" >&2
    fi
    return "$status"
}

if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
    cleanup_menu
fi
