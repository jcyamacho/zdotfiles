# FLUTTER (open source framework for building multi-platform applications): https://flutter.dev/

if exists flutter; then
  update-flutter() {
    info "Updating Flutter..."
    flutter upgrade
  }

 updates+=(update-flutter)
fi

if ! exists brew; then
  return
fi

if exists flutter; then
  uninstall-flutter() {
    brew uninstall flutter
  }
else
  install-flutter() {
    brew install --cask flutter
    flutter --disable-analytics
    dart --disable-analytics
  }
fi
