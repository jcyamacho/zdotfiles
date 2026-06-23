# Antigravity (AI Editor): https://antigravity.google/
(( $+_antigravity_bin )) || typeset -gr _antigravity_bin="/Applications/Antigravity.app/Contents/MacOS/Antigravity"

if [[ -f "$_antigravity_bin" ]]; then
  if exists brew; then
    uninstall-antigravity() {
      info "Uninstalling antigravity..."
      command brew uninstall --cask antigravity
      reload
    }
  fi
elif exists brew; then
  install-antigravity() {
    info "Installing antigravity..."
    command brew install --cask antigravity
    reload
  }
fi
