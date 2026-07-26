# STARTUP_PROFILING
[[ -n ${ZDOTFILES_PROFILE_STARTUP:-} ]] && zmodload zsh/zprof
# STARTUP_PROFILING end

# DISABLE_OMZ_UPDATE_CHECK
zstyle ':omz:update' mode disabled

ZDOTFILES_DIR="${ZDOTFILES_DIR:-$HOME/.zdotfiles}"

# CACHE
ZDOTFILES_CACHE_DIR="${ZDOTFILES_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/zdotfiles}"
[[ -d "$ZDOTFILES_CACHE_DIR" ]] || command mkdir -p -- "$ZDOTFILES_CACHE_DIR"

typeset -g _zdotfiles_completions_dir="$ZDOTFILES_CACHE_DIR/completions"
[[ -d "$_zdotfiles_completions_dir" ]] || command mkdir -p -- "$_zdotfiles_completions_dir"
# CACHE end

typeset -gU path
typeset -gU fpath
fpath=("$_zdotfiles_completions_dir" "${fpath[@]}")

# CUSTOM_TOOLS_DIR
CUSTOM_TOOLS_DIR="${CUSTOM_TOOLS_DIR:-$HOME/.local/bin}"
[[ -d "$CUSTOM_TOOLS_DIR" ]] || command mkdir -p -- "$CUSTOM_TOOLS_DIR"
path=("$CUSTOM_TOOLS_DIR" "${path[@]}")
# CUSTOM_TOOLS_DIR end

# UTILS
builtin source "$ZDOTFILES_DIR/_utils.zsh"
# UTILS end

# UPDATES
typeset -gUa updates

_update_zdotfiles() {
  info "Updating zdotfiles..."
  command git -C "$ZDOTFILES_DIR" pull --ff-only
}

update-zdotfiles() {
  _update_zdotfiles
  reload
}

updates+=(_update_zdotfiles)

update-all() {
  local update
  for update in "${updates[@]}"; do
    "$update"
    builtin print
  done

  reload
}
# UPDATES end

# ANTIDOTE
ANTIDOTE_DIR="${ANTIDOTE_DIR:-$HOME/.antidote}"
ANTIDOTE_HOME="${ANTIDOTE_HOME:-$HOME/.cache/antidote}"
[[ -d "$ANTIDOTE_DIR" ]] || command git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"

# Lazy-load antidote from its functions directory.
fpath=("$ANTIDOTE_DIR/functions" "${fpath[@]}")
autoload -Uz antidote

# Set the root name of the plugins files (.txt and .zsh) antidote will use.
typeset zsh_plugins="${ZDOTFILES_DIR}/.zsh_plugins"

# Generate a new static file whenever .zsh_plugins.txt is updated.
if [[ ! "${zsh_plugins}.zsh" -nt "${zsh_plugins}.txt" ]]; then
  info "Generating static plugins file..."
  ZDOTFILES_DIR="$ZDOTFILES_DIR" antidote bundle \
    < "${zsh_plugins}.txt" >| "${zsh_plugins}.zsh"
fi

# Compile the static plugins file for faster sourcing.
if [[ -f "${zsh_plugins}.zsh" ]]; then
  if [[ ! -f "${zsh_plugins}.zsh.zwc" || "${zsh_plugins}.zsh" -nt "${zsh_plugins}.zsh.zwc" ]]; then
    builtin zcompile "${zsh_plugins}.zsh" 2>/dev/null || :
  fi
fi

# Source your static plugins file.
builtin source "${zsh_plugins}.zsh"
unset zsh_plugins

_antidote_update() {
  info "Updating antidote..."
  antidote update
}

update-antidote() {
  _antidote_update
  reload
}

updates+=(_antidote_update)
# ANTIDOTE end

# STARTUP_PROFILING_RESULTS
if [[ -n ${ZDOTFILES_PROFILE_STARTUP:-} ]]; then
  zprof
fi
# STARTUP_PROFILING_RESULTS end

# RECOMMENDED_TOOLS
# Keep this list in sync with the Recommended section in README.md.
install-recommended() {
  local -a installers=()
  exists fzf || installers+=(install-fzf)
  exists zoxide || installers+=(install-zoxide)
  exists atuin || installers+=(install-atuin)
  exists carapace || installers+=(install-carapace)

  if (( $#installers == 0 )); then
    info "All recommended tools are already installed"
    return 0
  fi

  local result=0
  local installer
  for installer in "${installers[@]}"; do
    if (( ! $+functions[$installer] )); then
      error "Installer unavailable: $installer"
      result=1
      continue
    fi

    "$installer" || result=1
  done
  return $result
}
# RECOMMENDED_TOOLS end
