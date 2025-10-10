# VSCode (IDE): https://code.visualstudio.com/

_has_code() {
  (( $+commands[code] ))
}

if _has_code; then
  c() {
    local dir="${1:-$(pwd)}"
    code "$dir"
  }
fi

if ! _has_brew; then
  return
fi

if _has_code; then
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
