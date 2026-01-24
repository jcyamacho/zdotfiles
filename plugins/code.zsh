# VSCode (IDE): https://code.visualstudio.com/

if exists code; then
  c() {
    local dir="${1:-$PWD}"
    command code "$dir"
  }

  if exists brew; then
    uninstall-code() {
      info "Uninstalling visual studio code..."
      command brew uninstall --cask visual-studio-code
      reload
    }
  fi
elif exists brew; then
  install-code() {
    info "Installing visual studio code..."
    command brew install --cask visual-studio-code
    reload
  }
fi
