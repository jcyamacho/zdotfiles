# flutter (multi-platform app framework): https://flutter.dev/

if exists flutter; then
  _update_flutter() {
    info "Updating Flutter..."
    command flutter upgrade
  }

  update-flutter() {
    _update_flutter
    reload
  }

  updates+=(_update_flutter)
fi

exists brew || return

if exists flutter; then
  uninstall-flutter() {
    info "Uninstalling flutter..."
    command brew uninstall --cask flutter
    reload
  }
else
  install-flutter() {
    info "Installing flutter..."
    command brew install --cask flutter
    command flutter --disable-analytics
    command dart --disable-analytics
    reload
  }
fi
