# cmux (native macOS terminal for AI agents): https://www.cmux.dev/
_cmux_setup_cli() {
  local executable
  local executables=(
    "/Applications/cmux.app/Contents/Resources/bin/cmux"
    "$HOME/Applications/cmux.app/Contents/Resources/bin/cmux"
  )

  for executable in "${executables[@]}"; do
    [[ -x "$executable" ]] || continue
    command ln -sf -- "$executable" "$CUSTOM_TOOLS_DIR/cmux"
    return 0
  done
}

if exists cmux; then
  cmux-setup-cli() {
    _cmux_setup_cli || {
      error "cmux CLI setup failed: app bundle not found"
      return 1
    }
  }

  cmux-inside() {
    [[ -n "${CMUX_WORKSPACE_ID:-}" && -n "${CMUX_SURFACE_ID:-}" ]]
  }

  cmux-ping() {
    command cmux ping
  }

  if exists brew; then
    uninstall-cmux() {
      info "Uninstalling cmux..."
      command brew uninstall --cask cmux
      command rm -f -- "$CUSTOM_TOOLS_DIR/cmux"
      reload
    }
  fi
elif exists brew; then
  install-cmux() {
    info "Installing cmux..."
    command brew tap manaflow-ai/cmux
    command brew install --cask cmux
    _cmux_setup_cli || warn "cmux CLI setup skipped: app bundle not found"
    reload
  }
fi
