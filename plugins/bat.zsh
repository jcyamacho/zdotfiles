# BAT (A cat(1) clone with wings): https://github.com/sharkdp/bat
if (( ! $+commands[brew] )); then
  return
fi

if (( $+commands[bat] )); then
  uninstall-bat() {
    info "Uninstalling bat..."
    brew uninstall bat
    reload
  }
else
  install-bat() {
    info "Installing bat..."
    brew install bat
    reload
  }
fi
