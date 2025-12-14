# BAT (A cat(1) clone with wings): https://github.com/sharkdp/bat
if ! exists brew; then
  return
fi

if exists bat; then
  uninstall-bat() {
    info "Uninstalling bat..."
    command brew uninstall bat
    reload
  }
else
  install-bat() {
    info "Installing bat..."
    command brew install bat
    reload
  }
fi
