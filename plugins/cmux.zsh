# cmux (native macOS terminal for AI agents): https://www.cmux.dev/
if exists cmux; then
  uninstall-cmux() {
    info "Uninstalling cmux..."
    command brew uninstall --cask cmux || return
    reload
  }
else
  install-cmux() {
    info "Installing cmux..."
    command brew install --no-ask --cask cmux || return
    reload
  }
fi
