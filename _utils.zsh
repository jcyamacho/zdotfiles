autoload -Uz colors 2>/dev/null && colors

typeset -g _reset_color=${reset_color:-$'\e[0m'}

info() {
  builtin print -r -- "${fg_bold[cyan]}$*$_reset_color"
}

warn() {
  builtin print -r -- "${fg_bold[yellow]}$*$_reset_color"
}

error() {
  builtin print -r -- "${fg_bold[red]}$*$_reset_color"
}

_confirm_discard_input() {
  local discard
  while builtin read -t 0 -k 1 discard 2>/dev/null; do
    :
  done
}

_confirm_read_line() {
  local char
  REPLY=""

  while true; do
    builtin read -k 1 char 2>/dev/null || return 1
    [[ "$char" == $'\n' ]] && return 0
    REPLY+="$char"
  done
}

confirm() {
  local prompt="${1:?confirm: missing prompt}"
  local default_answer="${2:-yes}"
  local suffix

  case "$default_answer" in
    yes) suffix="[Y/n]" ;;
    no) suffix="[y/N]" ;;
    *)
      error "confirm: invalid default '$default_answer'"
      return 1
      ;;
  esac

  local answer
  while true; do
    # Drop type-ahead buffered before this prompt so answers can't spill across confirms.
    _confirm_discard_input

    builtin print -n -r -- "${fg_bold[yellow]}$prompt $suffix$_reset_color "
    _confirm_read_line || {
      builtin print ""
      error "confirm: no terminal available"
      return 1
    }

    answer="${REPLY:l}"
    case "$answer" in
      y|yes) return 0 ;;
      n|no) return 1 ;;
      "")
        [[ "$default_answer" == "yes" ]]
        return
        ;;
    esac

    warn "Please answer yes or no."
  done
}

mkcd() {
  local target=${1:?mkcd: missing directory name}
  command mkdir -p -- "$target"
  builtin cd "$target"
}

# whence -p searches $path directly; a $commands miss rehashes every $path
# directory after each path change, which made startup noticeably slower.
exists() {
  whence -p -- "${1:?exists: missing command}" > /dev/null
}

run-quiet() {
  local executable="${1:?run-quiet: missing command}"
  shift

  local output_file result=0
  output_file="$(command mktemp)" || return

  # Keep shell-function environment changes in the calling shell.
  {
    "$executable" "$@" > "$output_file" 2>&1 || result=$?
    if (( result != 0 )); then
      command cat -- "$output_file" >&2
    fi
  } always {
    command rm -f -- "$output_file"
  }

  return "$result"
}

reload() {
  builtin source "$ZDOTFILES_DIR/zshrc.sh"
}

reload-full() {
  builtin source "$_zshrc_file"
}

zsh-plugins-regenerate() {
  local zsh_plugins="${ZDOTFILES_DIR}/.zsh_plugins"
  local static_file="${zsh_plugins}.zsh"

  command rm -f -- "$static_file" "${static_file}.zwc" || return
  reload
}

zdotfiles-cache-clean() {
  warn "This will delete all zdotfiles caches (init, completions, etc.)"
  confirm "Continue?" no || { info "Aborted"; return 0; }

  command rm -rf -- "$ZDOTFILES_CACHE_DIR" || return
  info "Cache cleared"
  reload
}

# Writes the output of `cmd args...` to cache when the cache is missing or older
# than the tool binary or the plugin file that requested it, so editing a
# plugin's arguments takes effect on the next load.
_cache_command_output() {
  local cache="$1" caller="$2" cmd="$3"
  shift 3

  # Resolved by hand for the same reason exists avoids $commands.
  local dir cmd_path
  for dir in $path; do
    [[ -f "$dir/$cmd" && -x "$dir/$cmd" ]] && { cmd_path="$dir/$cmd"; break }
  done

  [[ -s "$cache" && ! "$cmd_path" -nt "$cache" && ! "$caller" -nt "$cache" ]] && return 0

  local tmp
  tmp="$(command mktemp "${cache}.XXXXXX")" || return
  {
    command "$cmd" "$@" >| "$tmp" || return
    [[ -s "$tmp" ]] || return 1
    command mv -f -- "$tmp" "$cache"
  } always {
    command rm -f -- "$tmp"
  }
}

# Caches the output of `cmd args...` (e.g., `starship init zsh`) and sources it.
source-cached-init() {
  local cmd=${1:?source-cached-init: missing command}
  local cache="${ZDOTFILES_CACHE_DIR}/${cmd}-init.zsh"

  _cache_command_output "$cache" "${funcfiletrace[1]%:*}" "$@" || return
  [[ "${cache}.zwc" -nt "$cache" ]] || builtin zcompile "$cache" 2>/dev/null
  builtin source "$cache"
}

# Caches the output of `cmd args...` as a #compdef completion file on fpath.
# Usage: cache-completion <cmd> [args...]
#   e.g., cache-completion zellij setup --generate-completion zsh
cache-completion() {
  local cmd=${1:?cache-completion: missing command}
  _cache_command_output "${_zdotfiles_completions_dir}/_${cmd}" "${funcfiletrace[1]%:*}" "$@"
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

  {
    command curl --proto '=https' --tlsv1.2 -fsSL "$url" -o "$tmp" || return
    _run_with_zshrc_locked env "${envs[@]}" "$shell" "$tmp" "$@"
  } always {
    command rm -f -- "$tmp"
  }
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

typeset -g _zshrc_file="$HOME/.zshrc"

_lock_zshrc() {
  command chmod -w "$_zshrc_file"
}

_unlock_zshrc() {
  command chmod +w "$_zshrc_file"
}

_run_with_zshrc_locked() {
  _lock_zshrc || return
  {
    command "$@"
  } always {
    _unlock_zshrc
  }
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

edit-open() {
  local -a editor_cmd
  if [[ -n $EDITOR ]]; then
    editor_cmd=("${(z)EDITOR}")
    editor_cmd=("${(@)editor_cmd:#--wait}")
  else
    editor_cmd=(vim)
  fi
  "${editor_cmd[@]}" "$@"
}

zsh-config() {
  # Unlock first in case a killed updater left the file read-only.
  _unlock_zshrc
  edit "$_zshrc_file" && reload-full
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
  local pid_output
  pid_output="$(command lsof -tiTCP:"$port" -sTCP:LISTEN 2>/dev/null)"
  if [[ -z $pid_output ]]; then
    warn "No process found on port $port"
    return 1
  fi

  local -aU pids
  pids=("${(@f)pid_output}")

  local pid
  for pid in "${pids[@]}"; do
    info "Killing process $pid on port $port"
    command kill "$pid" 2>/dev/null || warn "Process $pid was already gone"
  done

  local -a remaining
  remaining=("${pids[@]}")

  local i
  for i in {1..5}; do
    local -a still_running=()
    for pid in "${remaining[@]}"; do
      command kill -0 "$pid" 2>/dev/null && still_running+=("$pid")
    done
    (( $#still_running == 0 )) && return 0
    remaining=("${still_running[@]}")
    sleep 0.1
  done

  for pid in "${remaining[@]}"; do
    warn "Force-killing process $pid"
    command kill -9 "$pid" 2>/dev/null
  done
}
