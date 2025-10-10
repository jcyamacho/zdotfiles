# ZED (A modern text editor): https://zed.dev/

_has_zed() {
  (( $+commands[zed] ))
}

if _has_zed; then
  zd() {
    local dir="${1:-$(pwd)}"
    zed $dir
  }
fi

if ! _has_brew; then
  return
fi

if _has_zed; then
  uninstall-zed() {
    info "Uninstalling zed..."
    brew uninstall zed
    reload
  }
else
  install-zed() {
    info "Installing zed..."
    brew install --cask zed
    reload
  }
fi
