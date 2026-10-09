# just (command runner): https://just.systems/

if exists just; then
  uninstall-just() {
    info "Uninstalling just..."
    command brew uninstall just || return
    reload
  }
else
  install-just() {
    info "Installing just..."
    command brew install --no-ask just || return
    reload
  }
fi
