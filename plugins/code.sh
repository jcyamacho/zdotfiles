# Cursor (IDE): https://www.cursor.com/
if (( ! $+commands[brew] )); then
  return
fi

if (( $+commands[code] )); then
  c() {
    local dir="${1:-$(pwd)}"
    code "$dir"
  }

  uninstall-code() {
    info "Uninstalling visual studio code..."
    brew uninstall visual-studio-code
    reload
  }
else
  install-code() {
    info "Installing visual studio code..."
    brew install --cask visual-studio-code
    reload
  }
fi
