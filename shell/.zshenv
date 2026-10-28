has_command() {
  command -v "$1" >/dev/null 2>&1
}

has_nonempty_file() {
  [[ -f "$1" && -s "$1" ]]
}

has_directory() {
  [[ -d "$1" ]]
}

is_executable() {
  [[ -x "$1" ]]
}

# Include binaries locations to PATH
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

if has_command docker; then
  export BUILDKIT_PROGRESS=tty
fi

if has_command nvim; then
    export EDITOR="nvim"
    export MANPAGER='nvim +Man!'
fi

if [[ -n "$WSL_DISTRO_NAME" ]] && has_command wslview; then
    export BROWSER=wslview
elif has_command brave; then
    export BROWSER="brave"
fi

if has_command javac; then
    export JAVA_HOME="$(readlink -f "$(command -v javac)" | sed "s:/bin/javac::")"
fi

# NVM
if has_nonempty_file "$HOME/.nvm/nvm.sh"; then
  export NVM_DIR="$HOME/.nvm"
fi

# fnm
FNM_PATH="${HOME}/.local/share/fnm"
if is_executable "$FNM_PATH/fnm"; then
  export PATH="$FNM_PATH:$PATH"
  eval "$("$FNM_PATH/fnm" env --use-on-cd --shell zsh)"
fi

# Bun
if is_executable "$HOME/.bun/bin/bun"; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
  has_nonempty_file "$HOME/.oh-my-zsh/completions/_bun" && source "$HOME/.oh-my-zsh/completions/_bun"
fi

# Go
if is_executable /usr/local/go/bin/go; then
  export PATH="$PATH:/usr/local/go/bin"
fi
if has_directory "$HOME/go/bin"; then
  export PATH="$PATH:$HOME/go/bin"
fi

# Cmake when manually install
# export PATH=$PATH:/opt/cmake/cmake-3.30.3-linux-x86_64/bin/

# Rust
if has_nonempty_file "$HOME/.cargo/env"; then
  . "$HOME/.cargo/env"
fi

# opencode
if is_executable "$HOME/.opencode/bin/opencode"; then
  export PATH="$PATH:$HOME/.opencode/bin"
fi
if has_command plannotator; then
  export PLANNOTATOR_PORT="19432-19463"
  export PLANNOTATOR_REMOTE=1
  export PLANNOTATOR_URL_HOST=auto
fi
