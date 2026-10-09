# Antigravity (agent orchestration platform and terminal agent): https://antigravity.google/
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

if exists agy; then
  uninstall-antigravity-cli() {
    info "Uninstalling antigravity CLI..."
    command brew uninstall --cask antigravity-cli || return

    local config_dir="$HOME/.gemini/antigravity-cli"
    if confirm "Delete Antigravity CLI settings and data in $config_dir?" no; then
      command rm -rf -- "$config_dir"
    fi

    reload
  }
else
  install-antigravity-cli() {
    info "Installing antigravity CLI..."
    command brew install --no-ask --cask antigravity-cli || return
    reload
  }
fi
