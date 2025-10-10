# ZED (A modern text editor): https://zed.dev/
if (( ! $+commands[brew] )); then
  return
fi

if (( $+commands[zed] )); then
  zd() {
    local dir="${1:-$(pwd)}"
    zed $dir
  }

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
