# codex (Homebrew install/uninstall): https://developers.openai.com/codex/cli

if exists codex; then
  uninstall-codex() {
    info "Uninstalling codex..."
    command brew uninstall codex
    command rm -rf -- "$CODEX_HOME"
    reload
  }
else
  install-codex() {
    info "Installing codex..."
    command brew install codex
    command mkdir -p -- "$CODEX_PROMPTS_DIR"
    reload
  }
fi
