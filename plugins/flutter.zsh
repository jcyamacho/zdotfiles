# FLUTTER (open source framework for building multi-platform applications): https://flutter.dev/

if exists flutter; then
  update-flutter() {
    info "Updating Flutter..."
    command flutter upgrade
  }

  updates+=(update-flutter)
fi

if ! exists brew; then
  return
fi

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
