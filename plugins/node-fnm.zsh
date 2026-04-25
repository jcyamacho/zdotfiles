# fnm (Fast Node Manager): https://github.com/Schniz/fnm

(( $+_fnm_multishell_root )) || typeset -gr _fnm_multishell_root="${XDG_STATE_HOME:-$HOME/.local/state}/fnm_multishells"

_update_node() {
  info "Activating latest LTS node..."
  fnm install --lts
  fnm use --install-if-missing lts-latest

  local current_version="$(fnm current)"
  fnm default "$current_version"
  info "Current Node.js version: $current_version"

  info "Updating npm..."
  command npm install -g npm@latest > /dev/null
}

_fnm_prune_multishell_paths() {
  local entry
  local -a cleaned_path=()

  # `fnm env` prepends a session-specific multishell bin dir. On `reload`, stale
  # entries can accumulate in PATH unless we drop older fnm multishell bins first.
  for entry in "${path[@]}"; do
    [[ "$entry" == "$_fnm_multishell_root"/*/bin ]] && continue
    cleaned_path+=("$entry")
  done

  path=("${cleaned_path[@]}")
}

_fnm_env() {
  # This shell relies on `fnm env` both for fnm's own variables and for the
  # active global Node.js version on PATH.
  _fnm_prune_multishell_paths
  # fnm env output is session-specific (FNM_MULTISHELL_PATH), so do not cache it.
  builtin source <(command fnm env --shell zsh)
}

if exists fnm; then
  _fnm_env

  if exists brew; then
    alias uninstall-node="uninstall-fnm"
    uninstall-fnm() {
      command brew uninstall fnm
      command rm -rf -- "$HOME/.local/state/fnm_multishells"
      reload
    }
  fi

  uninstall-unused-node-versions() {
    local current_version="$(fnm current)"
    info "Cleaning up unused Node.js versions (keeping $current_version)..."

    fnm list | command grep -v "$current_version" | command grep -Eo 'v[0-9]+\.[0-9]+\.[0-9]+' | while IFS= read -r version; do
      info "Removing $version..."
      fnm uninstall "$version"
    done
  }

  update-node() {
    info "Updating Node.js..."
    _fnm_env
    _update_node
  }

  updates+=(update-node)
elif exists brew; then
  alias install-node="install-fnm"
  install-fnm() {
    info "Installing fnm..."
    command brew install fnm
    _fnm_env
    _update_node
    reload
  }
fi
