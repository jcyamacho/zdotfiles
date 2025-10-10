# Cursor (IDE): https://www.cursor.com/

_has_cursor() {
  (( $+commands[cursor] ))
}

if _has_cursor; then
  cr() {
    local dir="${1:-$(pwd)}"
    cursor "$dir"
  }
fi

if ! _has_brew; then
  return
fi

if _has_cursor; then
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
