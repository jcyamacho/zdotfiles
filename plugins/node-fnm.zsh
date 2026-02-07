# fnm (Fast Node Manager): https://github.com/Schniz/fnm

exists brew || return

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

_fnm_env() {
  # fnm env output is session-specific (FNM_MULTISHELL_PATH), so do not cache it.
  builtin source <(command fnm env --shell zsh)
}

if exists fnm; then
  _fnm_env

  alias uninstall-node="uninstall-fnm"
  uninstall-fnm() {
    command brew uninstall fnm
    command rm -rf -- "$HOME/.local/state/fnm_multishells"
    clear-cached-init fnm
    reload
  }

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
    if _update_node; then
      clear-cached-init fnm
    fi
  }

  updates+=(update-node)
else
  alias install-node="install-fnm"
  install-fnm() {
    info "Installing fnm..."
    command brew install fnm
    _fnm_env
    _update_node
    reload
  }
fi
