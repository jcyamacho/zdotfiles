# just (command runner): https://just.systems/

_just_install() {
  _run_remote_installer "https://just.systems/install.sh" "bash" -- --to "$CUSTOM_TOOLS_DIR"
}

if exists just; then
  cache-completion just --completions zsh

  uninstall-just() {
    info "Uninstalling just..."
    command rm -f -- "$CUSTOM_TOOLS_DIR/just"
    reload
  }

  _update_just() {
    info "Updating just..."
    _just_install
  }

  update-just() {
    _update_just
    reload
  }

  updates+=(_update_just)
else
  install-just() {
    info "Installing just..."
    _just_install
    reload
  }
fi
