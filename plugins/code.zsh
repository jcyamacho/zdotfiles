# VSCode (IDE): https://code.visualstudio.com/

if exists code; then
  c() {
    local dir="${1:-$(pwd)}"
    code "$dir"
  }
fi

if ! exists brew; then
  return
fi

if exists code; then
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
