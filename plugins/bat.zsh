# bat (cat clone with wings): https://github.com/sharkdp/bat

if exists bat; then
  uninstall-bat() {
    info "Uninstalling bat..."
    command brew uninstall bat || return
    reload
  }
else
  install-bat() {
    info "Installing bat..."
    command brew install --no-ask bat || return
    reload
  }
fi
