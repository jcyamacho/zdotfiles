# cmux (native macOS terminal for AI agents): https://www.cmux.dev/
if exists cmux; then
  cmux-inside() {
    [[ -n "${CMUX_WORKSPACE_ID:-}" && -n "${CMUX_SURFACE_ID:-}" ]]
  }

  cmux-ping() {
    command cmux ping
  }

  uninstall-cmux() {
    info "Uninstalling cmux..."
    command brew uninstall --cask cmux || return
    reload
  }
else
  install-cmux() {
    info "Installing cmux..."
    command brew install --no-ask --cask cmux || return
    reload
  }
fi
