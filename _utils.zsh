autoload -Uz colors 2>/dev/null && colors

# Loads only zstat, so the stat command keeps resolving to /usr/bin/stat.
builtin zmodload -F zsh/stat b:zstat

info() {
  builtin print -r -- "${fg_bold[cyan]}$*$reset_color"
}

warn() {
  builtin print -r -- "${fg_bold[yellow]}$*$reset_color"
}

error() {
  builtin print -u2 -r -- "${fg_bold[red]}$*$reset_color"
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
  local suffix REPLY

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

    builtin print -n -r -- "${fg_bold[yellow]}$prompt $suffix$reset_color "
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
  command mkdir -p -- "$target" || return
  builtin cd -- "$target"
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

# A new shell drops the functions, aliases, and hooks of removed tools, which
# re-sourcing would keep. Exported variables survive.
reload() {
  # Scripts and `zsh -c` callers must keep running instead of becoming an
  # interactive shell, a subshell cannot restart its parent, and batch callers
  # reload once after their loop.
  if [[ ! -o interactive || -n ${ZSH_EXECUTION_STRING-} ]] || (( ZSH_SUBSHELL )) ||
    [[ -n ${_zdotfiles_reload_deferred-} ]]; then
    return 0
  fi

  # exec discards the job table, so the new shell could not resume these jobs.
  if (( ${#jobstates} )); then
    warn "Jobs are still running or stopped. Finish them, then run reload."
    return 1
  fi

  builtin exec zsh
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
# than the tool binary or any dependency file. Dependencies are the plugin file
# that requested it, so editing a plugin's arguments takes effect on the next
# load, plus any file the output is built from.
# Usage: _cache_command_output <cache> <dependency>... -- <cmd> [args...]
_cache_command_output() {
  local cache="$1"
  shift

  local -a deps=()
  while (( $# )) && [[ $1 != -- ]]; do
    deps+=("$1")
    shift
  done
  shift

  local cmd="$1"
  shift

  # Resolved by hand for the same reason exists avoids $commands.
  local dir cmd_path
  for dir in $path; do
    [[ -f "$dir/$cmd" && -x "$dir/$cmd" ]] && { cmd_path="$dir/$cmd"; break }
  done

  local -a newer=()
  local dep
  for dep in "${deps[@]}"; do
    [[ "$dep" -nt "$cache" ]] && newer+=("$dep")
  done

  # Installers keep archive mtimes (Homebrew bottles use the source date), so
  # an upgrade shows only in the binary's inode change time.
  local -a binary_time cache_time
  if [[ -n $cmd_path && -e $cache ]] &&
    builtin zstat -A binary_time +ctime -- "$cmd_path" &&
    builtin zstat -A cache_time +mtime -- "$cache" &&
    (( binary_time[1] > cache_time[1] )); then
    newer+=("$cmd_path")
  fi
  [[ -s "$cache" ]] && (( ! $#newer )) && return 0

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
# Usage: source-cached-output [--dep <file>]... <cmd> [args...]
#   --dep also regenerates the cache when <file> is newer, e.g. a config file
#   the init output is built from.
source-cached-output() {
  local -a deps=("${funcfiletrace[1]%:*}")
  while [[ ${1-} == --dep ]]; do
    deps+=("${2:?source-cached-output: missing --dep file}")
    shift 2
  done

  local cmd=${1:?source-cached-output: missing command}
  local cache="${ZDOTFILES_CACHE_DIR}/${cmd}.zsh"

  _cache_command_output "$cache" "${deps[@]}" -- "$@" || return
  [[ "${cache}.zwc" -nt "$cache" ]] || builtin zcompile "$cache" 2>/dev/null
  builtin source "$cache"
}

# Caches the output of `cmd args...` as a #compdef completion file on fpath.
# Usage: cache-completion <cmd> [args...]
#   e.g., cache-completion deno completions zsh
cache-completion() {
  local cmd=${1:?cache-completion: missing command}
  _cache_command_output "${_zdotfiles_completions_dir}/_${cmd}" "${funcfiletrace[1]%:*}" -- "$@"
}

_run_remote_installer() {
  local url="${1:?_run_remote_installer: missing url}"
  shift

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
    _run_with_zshrc_locked env "${envs[@]}" bash "$tmp" "$@"
  } always {
    command rm -f -- "$tmp"
  }
}

alias cls="clear"
alias rmf="rm -rf"
alias cd..="cd .."

typeset -g _zshrc_file="$HOME/.zshrc"

_run_with_zshrc_locked() {
  command chmod -w "$_zshrc_file" || return
  {
    command "$@"
  } always {
    command chmod +w "$_zshrc_file"
  }
}

# Drops the common --wait flag so GUI editors return at once. Other editors
# keep waiting, which is the safe fallback.
edit() {
  local -a editor_cmd=("${(@Q)${(z)${EDITOR:-vim}}}")
  "${(@)editor_cmd:#--wait}" "$@"
}

# $EDITOR must wait until the file is saved, because git and crontab rely on it.
edit-wait() {
  local -a editor_cmd=("${(@Q)${(z)${EDITOR:-vim}}}")
  "${editor_cmd[@]}" "$@"
}

zsh-config() {
  # Unlock first in case a killed updater left the file read-only.
  command chmod +w "$_zshrc_file"
  edit-wait "$_zshrc_file" && reload
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

  local i
  for i in {1..5}; do
    local -a still_running=()
    for pid in "${pids[@]}"; do
      command kill -0 "$pid" 2>/dev/null && still_running+=("$pid")
    done
    (( $#still_running == 0 )) && return 0
    pids=("${still_running[@]}")
    command sleep 0.1
  done

  for pid in "${pids[@]}"; do
    warn "Force-killing process $pid"
    command kill -9 "$pid" 2>/dev/null
  done
}
