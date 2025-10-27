if exists codex; then
  uninstall-codex() {
    info "Uninstalling codex..."
    brew uninstall codex
    command rm -rf "$CODEX_HOME"
    reload
  }
else
  install-codex() {
    info "Installing codex..."
    brew install codex
    command mkdir -p "$CODEX_PROMPTS_DIR"
    reload
  }
fi
