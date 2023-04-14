# Tmux autostart/exit. Preserve at very top.
# If tmux is executable && Graphical session is running && We aren't already inside a tmux session
# Start a new session and close terminal at exit. tmux -u force UTF-8
if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ]; then
    tmux -u >/dev/null 2>&1 && exit
fi

# Language number formats for all shell process. May LANG=en_US.UTF-8
export LC_ALL=es_AR.UTF-8     # Used by fzf
export LC_NUMERIC=en_US.UTF-8 # Used by qalc

# Skip verification of insecure directories. Linkear configuraciones entre usuario y root.
ZSH_DISABLE_COMPFIX=true

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(command-not-found zsh-interactive-cd zsh-syntax-highlighting
         zsh-autosuggestions git vi-mode fzf sudo timer compleat extract)

eval "$(starship init zsh)"
source $ZSH/oh-my-zsh.sh

# Autorefresh packages names after package install
zstyle ':completion:*' rehash true

# Incorpora al PATH los binarios locales ~/.local/bin.
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

# The plugin will auto execute this zvm_after_init function.
# This is for vi-mode plugin compatibility
zvm_after_init() {
  source /usr/share/doc/fzf/examples/key-bindings.zsh
  source /usr/share/doc/fzf/examples/completion.zsh
}

# Colors
export LS_COLORS="rs=0:no=00:mi=00:mh=00:ln=01;36:or=01;31:di=01;34:ow=04;01;34:st=34:tw=04;34:pi=01;33:so=01;33:do=01;33:bd=01;33:cd=01;33:su=01;35:sg=01;35:ca=01;35:ex=01;32:"

# Escape mode faster (vi-mode plugin)
export KEYTIMEOUT=20
export EDITOR=nvim

# Run disown function
# DIR=$(dirname "${BASH_SOURCE[0]}") # Relative
function run_disown() {
    "$@" & disown
}
function run_disown_silence(){
    run_disown "$@" 1>/dev/null 2>/dev/null
}

# $1 Local; $2 Remote
function diffmerge() {
    nvim -d "$1" "$1".new "$2" \
        -c 'nnoremap dgh :diffget 1<CR>' -c 'nnoremap dgl :diffget 3<CR>' -c 'nnoremap dp :diffput 2<CR>' \
        -c 'nnoremap ZZ :wqall<CR>' -c 'nnoremap ZQ :quitall<CR>' -c 'wincmd w' -c 'read ++edit #'
}

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

alias zshconf="nvim ~/.zshrc"
alias tmuxconf="nvim ~/.config/tmux/tmux.conf"
alias nvimconf="cd ~/.config/nvim/lua/"

# run_disown_silence java -jar $DIR/ModbusMechanic.jar
alias plantuml="run_disown java -jar /opt/PlantUML/plantuml.jar -gui $(pwd)"
alias plantuml_convert="java -jar /opt/PlantUML/plantuml.jar -tsvg $(pwd)/" # plantuml_convert file.md

alias cat='bat'
alias ls='lsd --group-dirs=first'
alias l='ls -l'
alias lh='ls -a'
alias la='ls -la'
alias ll='ls -lah'

alias vim=nvim
alias dvim='docker start nvim && docker exec -it nvim nvim'
alias dvim-create='docker run --name nvim -it alpine'
alias dvim-clean='docker exec -it nvim rm root/.cache/nvim/ root/.local/share/nvim/ -r; sleep 0.5; dvim'
alias dvim-sync="dvim -c 'autocmd User PackerComplete quitall' -c 'PackerSync'"
alias dvim-comp="dvim --headless -c 'PackerCompile' -c 'quitall'"
alias dvim-test='dvim-comp; docker exec -it nvim nvim -c "cd /root/.config/nvim/lua/test/"'

alias glg='git lg'
alias glgm='git lgm'
alias glgf='git lgf'
alias gdv='git difftool'
alias lg='lazygit'
