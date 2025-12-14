autoload -Uz colors 2>/dev/null && colors

typeset -r _reset_color=${reset_color:-$'\e[0m'}

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
  (( $+commands[$1] ))
}

reload() {
  builtin source "$ZDOTFILES_DIR/zshrc.sh"
}

_cache_cmd_output() {
  local cache_file=${1:?_cache_cmd_output: missing cache_file}
  shift
  local cmd=${1:?_cache_cmd_output: missing command}
  shift

  local cmd_path=${commands[$cmd]:-}
  if [[ -z $cmd_path ]]; then
    warn "Cache skipped; missing command: $cmd"
    return 1
  fi

  # Fast path: cache exists and command is not newer.
  if [[ -s $cache_file && ! $cmd_path -nt $cache_file ]]; then
    return 0
  fi

  local cache_dir=${cache_file:h}
  [[ -d $cache_dir ]] || command mkdir -p -- "$cache_dir" || return 1

  local tmp_file
  tmp_file="$(command mktemp "${cache_file}.tmp.XXXXXXXX" 2>/dev/null)" || return 1

  if ! command "$cmd" "$@" >| "$tmp_file"; then
    warn "Failed generating cache: $cache_file ($cmd $*)"
    command rm -f -- "$tmp_file" 2>/dev/null
    return 1
  fi

  if [[ ! -s $tmp_file ]]; then
    warn "Generated empty cache: $cache_file ($cmd $*)"
    command rm -f -- "$tmp_file" 2>/dev/null
    return 1
  fi

  command mv -f -- "$tmp_file" "$cache_file" || {
    command rm -f -- "$tmp_file" 2>/dev/null
    return 1
  }
}

_cached_init_file() {
  local cmd=${1:?_cached_init_file: missing command}
  print -r -- "${ZDOTFILES_CACHE_DIR:?_cached_init_file: missing ZDOTFILES_CACHE_DIR}/$cmd/init.zsh"
}

source-cached-init() {
  local cmd=${1:?source-cached-init: missing command}
  shift

  local cache_file
  cache_file="$(_cached_init_file "$cmd")"

  if _cache_cmd_output "$cache_file" "$cmd" "$@"; then
    builtin source "$cache_file"
    return 0
  fi

  if [[ -f $cache_file ]]; then
    builtin source "$cache_file"
    return 0
  fi

  # This is the one place we intentionally allow eval, and only as a fallback when
  # the cached init file couldn't be generated/read. Many CLI tools (e.g. starship,
  # direnv, fnm) emit shell init code that must be evaluated in the current shell
  # to set env vars/functions/hooks. We only eval the stdout of an executable we
  # invoke directly via `command`, not arbitrary user-provided strings.
  builtin eval "$(command "$cmd" "$@")"
}

clear-cached-init() {
  local cmd=${1:?clear-cached-init: missing command}
  command rm -f -- "$(_cached_init_file "$cmd")" 2>/dev/null
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

typeset -r _zshrc_file="$HOME/.zshrc"

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
