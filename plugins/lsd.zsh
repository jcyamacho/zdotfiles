# lsd (ls alternative): https://github.com/lsd-rs/lsd

_has_lsd() {
  (( $+commands[lsd] ))
}

if _has_lsd; then
  ll() {
    lsd -l --git "$@"
  }
fi

if ! _has_brew; then
  return
fi

if _has_lsd; then
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
