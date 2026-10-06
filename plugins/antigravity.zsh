# Antigravity (AI Editor): https://antigravity.google/
if [[ -f "/Applications/Antigravity.app/Contents/MacOS/Antigravity" ]]; then
  uninstall-antigravity() {
    info "Uninstalling antigravity..."
    command brew uninstall --cask antigravity || return
    reload
  }
else
  install-antigravity() {
    info "Installing antigravity..."
    command brew install --no-ask --cask antigravity || return
    reload
  }
fi
