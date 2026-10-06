# VSCode (IDE): https://code.visualstudio.com/

if exists code; then
  c() {
    local dir="${1:-$PWD}"
    command code "$dir"
  }

  uninstall-code() {
    info "Uninstalling visual studio code..."
    command brew uninstall --cask visual-studio-code || return
    reload
  }
else
  install-code() {
    info "Installing visual studio code..."
    command brew install --no-ask --cask visual-studio-code || return
    reload
  }
fi
