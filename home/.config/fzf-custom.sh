# Use fd instead of fzf
# Credit: https://www.josean.com/posts/7-amazing-cli-tools
# https://github.com/junegunn/fzf#respecting-gitignore
if command -v fd &> /dev/null; then
    # Follow symbolic links and don't want it to exclude hidden files,
    export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
    export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix --exclude .git"

    # https://github.com/junegunn/fzf#customizing-completion-source-for-paths-and-directories
    # - The first argument to the function ($1) is the base path to start traversal
    _fzf_compgen_path() {
        fd --hidden --follow --exclude ".git" . "$1"
    }
    # Use fd to generate the list for directory completion
    _fzf_compgen_dir() {
        fd --type d --hidden --follow --exclude ".git" . "$1"
    }
fi

if [[ -d "${HOME}/.fzf-git.sh/" ]]; then
    source ${HOME}/.fzf-git.sh/fzf-git.sh
fi

# https://github.com/junegunn/fzf#customizing-fzf-options-for-completion
preview_path='ls --color=always --group-directories-first -F1 {} | head -200'
preview_file='bat -n --color=always --line-range :500 {}'
preview_path_or_file="if [ -d {} ]; then ${preview_path}; else ${preview_file}; fi"
export FZF_CTRL_T_OPTS="--preview '${preview_path_or_file}'"
export FZF_ALT_C_OPTS="--preview '${preview_path}'"

_fzf_comprun() {
  local command=$1
  shift
  case "${command}" in
    cd)           fzf --preview "${preview_path}"         "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"        "$@" ;;
    ssh)          fzf --preview 'dig {}'                  "$@" ;;
    *)            fzf --preview "${preview_path_or_file}" "$@" ;;
  esac
}
