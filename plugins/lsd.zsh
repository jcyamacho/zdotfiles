# lsd (ls alternative): https://github.com/lsd-rs/lsd

if exists lsd; then
  ll() {
    lsd -l --git "$@"
  }
fi

if ! exists brew; then
  return
fi

if exists lsd; then
  uninstall-lsd() {
    info "Uninstalling lsd..."
    brew uninstall lsd
  }
else
  install-lsd() {
    info "Installing lsd..."
    brew install lsd
  }
fi
