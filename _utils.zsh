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

exists() {
  local cmd=${1:?exists: missing command}

  local cmd_path=${commands[$cmd]-}
  [[ -n "$cmd_path" && -x "$cmd_path" ]]
}

reload() {
  builtin source "$ZDOTFILES_DIR/zshrc.sh"
}

zdotfiles-cache-clean() {
  warn "This will delete all zdotfiles caches (init, completions, etc.)"
  builtin print -n "Continue? [y/N] "
  local response
  builtin read -r response
  [[ $response == [yY] ]] || { info "Aborted"; return 0; }

  command rm -rf -- "$ZDOTFILES_CACHE_DIR"
  info "Cache cleared"
  reload
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
    local tmp
    tmp="$(command mktemp "${cache}.XXXXXX")"
    command "$cmd" "$@" >| "$tmp" || :
    if [[ -s "$tmp" ]]; then
      command mv -f -- "$tmp" "$cache"
      builtin zcompile "$cache" 2>/dev/null || :
    else
      command rm -f -- "$tmp"
      return 1
    fi
  fi

  builtin source "$cache"
}

# Caches the output of `cmd args...` as a #compdef completion file on fpath.
# Regenerates when the tool binary is newer than the cache.
# Usage: cache-completion <cmd> [args...]
#   e.g., cache-completion zellij setup --generate-completion zsh
cache-completion() {
  local cmd=${1:?cache-completion: missing command}
  shift
  local cache="${ZDOTFILES_COMPLETIONS_DIR}/_${cmd}"
  local cmd_path=${commands[$cmd]:-}

  # Regenerate if missing or tool binary is newer
  if [[ ! -s "$cache" || ( -n "$cmd_path" && "$cmd_path" -nt "$cache" ) ]]; then
    local tmp
    tmp="$(command mktemp "${cache}.XXXXXX")"
    command "$cmd" "$@" >| "$tmp" || :
    if [[ -s "$tmp" ]]; then
      command mv -f -- "$tmp" "$cache"
    else
      command rm -f -- "$tmp"
      return 1
    fi
  fi
}

_run_remote_installer() {
  local url="${1:?_run_remote_installer: missing url}"
  local shell="${2:-sh}"
  if (( $# >= 2 )); then
    shift 2
  else
    shift 1
  fi

  local -a envs=()
  while [[ ${1-} == "--env" ]]; do
    envs+=("$2")
    shift 2
  done

  if [[ ${1-} == "--" ]]; then
    shift 1
  fi

  local tmp
  tmp="$(command mktemp "${TMPDIR:-$ZDOTFILES_CACHE_DIR}/zdotfiles-installer.XXXXXX")" || return 1

  local exit_status=0
  _lock_zshrc
  trap '_unlock_zshrc; command rm -f -- "$tmp"' EXIT INT TERM

  if ! command curl --proto '=https' --tlsv1.2 -fsSL "$url" -o "$tmp"; then
    exit_status=1
  elif ! command env "${envs[@]}" "$shell" "$tmp" "$@"; then
    exit_status=$?
  fi

  _unlock_zshrc
  command rm -f -- "$tmp"
  trap - EXIT INT TERM
  return $exit_status
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

kill-port() {
  local port=${1:?kill-port: missing port number}
  local pid
  pid="$(command lsof -ti :"$port" 2>/dev/null)"
  if [[ -z $pid ]]; then
    warn "No process found on port $port"
    return 1
  fi
  info "Killing process $pid on port $port"
  command kill "$pid"
  local i
  for i in {1..5}; do
    command kill -0 "$pid" 2>/dev/null || return 0
    sleep 0.1
  done
  warn "Force-killing process $pid"
  command kill -9 "$pid"
}
