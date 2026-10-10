# flutter (multi-platform app framework): https://flutter.dev/

if exists flutter; then
  uninstall-flutter() {
    info "Uninstalling flutter..."
    command brew uninstall --cask flutter || return
    command rm -rf -- "${PUB_CACHE:-$HOME/.pub-cache}"
    reload
  }
else
  install-flutter() {
    info "Installing flutter..."
    command brew install --no-ask --cask flutter || return
    command flutter --disable-analytics
    command dart --disable-analytics
    reload
  }
fi
