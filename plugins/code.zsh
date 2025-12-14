# VSCode (IDE): https://code.visualstudio.com/

if exists code; then
  c() {
    local dir="${1:-$PWD}"
    command code "$dir"
  }
fi

if ! exists brew; then
  return
fi

if exists code; then
  uninstall-code() {
    info "Uninstalling visual studio code..."
    command brew uninstall --cask visual-studio-code
    reload
  }
else
  install-code() {
    info "Installing visual studio code..."
    command brew install --cask visual-studio-code
    reload
  }
fi
