autoload -Uz colors 2>/dev/null && colors

[[ -n ${_reset_color-} ]] || typeset -gr _reset_color=${reset_color:-$'\e[0m'}

info() {
  builtin print -r -- "${fg_bold[cyan]}$*$_reset_color"
}

warn() {
  builtin print -r -- "${fg_bold[yellow]}$*$_reset_color"
}

error() {
  builtin print -r -- "${fg_bold[red]}$*$_reset_color"
}

mkcd() {
  local target=${1:?mkcd: missing directory name}
  command mkdir -p -- "$target"
  builtin cd "$target"
}

typeset -gA _tool_exists_cache

exists() {
  # Cache the *exit status* of the lookup (0=exists, 1=missing).
  if [[ -z ${_tool_exists_cache[$1]-} ]]; then
    (( $+commands[$1] ))
    _tool_exists_cache[$1]=$?
  fi
  return $_tool_exists_cache[$1]
}

reload() {
  _tool_exists_cache=()
  builtin source "$ZDOTFILES_DIR/zshrc.sh"
}

# Caches the output of `cmd args...` (e.g., `starship init zsh`) and sources it.
# Regenerates when the tool binary is newer than the cache.
source-cached-init() {
  local cmd=${1:?source-cached-init: missing command}
  shift
  local cache="${ZDOTFILES_CACHE_DIR}/${cmd}-init.zsh"
  local cmd_path=${commands[$cmd]:-}

  # Regenerate if missing or tool binary is newer
  if [[ ! -s "$cache" || ( -n "$cmd_path" && "$cmd_path" -nt "$cache" ) ]]; then
    local tmp="$(command mktemp "${cache}.XXXXXX")"
    if command "$cmd" "$@" >| "$tmp"; then
      if [[ -s "$tmp" ]]; then
        command mv -f -- "$tmp" "$cache"
        builtin zcompile "$cache" 2>/dev/null || :
      else
        command rm -f -- "$tmp"
        return 1
      fi
    else
      if [[ -s "$tmp" ]]; then
        command mv -f -- "$tmp" "$cache"
        builtin zcompile "$cache" 2>/dev/null || :
      else
        command rm -f -- "$tmp"
        return 1
      fi
    fi
  fi

  builtin source "$cache"
}

clear-cached-init() {
  local cmd=${1:?clear-cached-init: missing command}
  local cache="${ZDOTFILES_CACHE_DIR}/${cmd}-init.zsh"
  command rm -f -- "$cache" "${cache}.zwc" 2>/dev/null
}

is-macos() {
  [[ $OSTYPE == darwin* ]]
}

alias cls="clear"
alias rmf="rm -rf"
alias cd..="cd .."

home() {
  builtin cd "$HOME"
}

[[ -n ${_zshrc_file-} ]] || typeset -gr _zshrc_file="$HOME/.zshrc"

_lock_zshrc() {
  command chmod -w "$_zshrc_file"
}

_unlock_zshrc() {
  command chmod +w "$_zshrc_file"
}

edit() {
  local -a editor_cmd
  if [[ -n $EDITOR ]]; then
    editor_cmd=("${(z)EDITOR}")
  else
    editor_cmd=(vim)
  fi
  "${editor_cmd[@]}" "$@"
}

zsh-config() {
  _unlock_zshrc
  edit "$_zshrc_file"
  reload
}

zsh-startup-profile() {
  ZDOTFILES_PROFILE_STARTUP=1 command time zsh -lic exit
}

zsh-startup-bench() {
  for _ in {1..10}; do
    command time zsh -lic exit
  done
}
