# Cursor (IDE): https://www.cursor.com/
if (( ! $+commands[brew] )); then
  return
fi

if (( $+commands[cursor] )); then
  cr() {
    local dir="${1:-$(pwd)}"
    cursor "$dir"
  }

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
