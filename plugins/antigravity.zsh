# Antigravity (AI Editor): https://antigravity.google/
if [[ -f "/Applications/Antigravity.app/Contents/MacOS/Antigravity" ]]; then
  if exists brew; then
    uninstall-antigravity() {
      info "Uninstalling antigravity..."
      command brew uninstall --cask antigravity || return
      reload
    }
  fi
elif exists brew; then
  install-antigravity() {
    info "Installing antigravity..."
    command brew install --no-ask --cask antigravity || return
    reload
  }
fi
