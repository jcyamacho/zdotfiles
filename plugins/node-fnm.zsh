# fnm (Fast Node Manager): https://github.com/Schniz/fnm
_has_fnm() {
  (( $+commands[fnm] ))
}

_has_node() {
  (( $+commands[node] ))
}

_has_npm() {
  (( $+commands[npm] ))
}

if ! _has_brew; then
  return
fi

_update_node() {
  info "  - Activating latest LTS node..."
  fnm install --lts
  fnm use --install-if-missing lts-latest

  local current_version=$(fnm current)
  fnm default "$current_version"
  info "  - Current Node.js version: $current_version"

  info "  - Updating npm..."
  npm install -g npm@latest > /dev/null
}

if _has_fnm; then
  eval "$(fnm env --use-on-cd --shell zsh)"

  alias uninstall-node="uninstall-fnm"
  uninstall-fnm() {
    brew uninstall fnm
    rm -rf "$HOME/.local/state/fnm_multishells"
    reload
  }

  uninstall-unused-node-versions() {
    local current_version=$(fnm current)
    info "Cleaning up unused Node.js versions (keeping $current_version)..."

    fnm list | grep -v "$current_version" | grep -o "v[0-9]\+\.[0-9]\+\.[0-9]\+" | while read -r version; do
      info "Removing $version..."
      fnm uninstall "$version"
    done
  }

  update-node() {
    info "Updating Node.js..."
    _update_node
  }

  updates+=(update-node)
else
  alias install-node="install-fnm"
  install-fnm() {
    info "Installing fnm..."
    brew install fnm
    _update_node
    reload
  }
fi
