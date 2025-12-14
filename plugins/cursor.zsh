# Cursor (IDE): https://www.cursor.com/

if exists cursor; then
  cr() {
    local dir="${1:-$PWD}"
    command cursor "$dir"
  }
fi

if ! exists brew; then
  return
fi

if exists cursor; then
  uninstall-cursor() {
    info "Uninstalling cursor..."
    command brew uninstall --cask cursor
    reload
  }
else
  install-cursor() {
    info "Installing cursor..."
    command brew install --cask cursor
    reload
  }
fi
