# ZED (A modern text editor): https://zed.dev/

if exists zed; then
  # Use ZED as the default editor if EDITOR is not set
  export EDITOR="${EDITOR:-zed --wait}"

  zd() {
    local dir="${1:-$(pwd)}"
    zed $dir
  }
fi

if ! exists brew; then
  return
fi

if exists zed; then
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
