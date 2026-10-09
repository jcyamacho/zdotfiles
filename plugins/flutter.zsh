# flutter (multi-platform app framework): https://flutter.dev/

if exists flutter; then
  uninstall-flutter() {
    info "Uninstalling flutter..."
    command brew uninstall --cask flutter || return

    local pub_cache="${PUB_CACHE:-$HOME/.pub-cache}"
    if confirm "Delete Dart packages and global executables in $pub_cache?" no; then
      command rm -rf -- "$pub_cache"
    fi

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
