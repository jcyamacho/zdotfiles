# Cursor (IDE): https://www.cursor.com/

if exists cursor; then
  cr() {
    local dir="${1:-$(pwd)}"
    cursor "$dir"
  }
fi

if ! exists brew; then
  return
fi

if exists cursor; then
  uninstall-cursor() {
    info "Uninstalling cursor..."
    brew uninstall cursor
    reload
  }
else
  install-cursor() {
    info "Installing cursor..."
    brew install --cask cursor
    reload
  }
fi
