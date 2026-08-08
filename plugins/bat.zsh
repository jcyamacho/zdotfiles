# bat (cat clone with wings): https://github.com/sharkdp/bat

if exists bat; then
  if exists brew; then
    uninstall-bat() {
      info "Uninstalling bat..."
      command brew uninstall bat || return
      reload
    }
  fi
elif exists brew; then
  install-bat() {
    info "Installing bat..."
    command brew install --no-ask bat || return
    reload
  }
fi
