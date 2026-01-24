# codex (npm install/update): https://developers.openai.com/codex/cli

if exists codex; then
  _update_codex() {
    info "Updating codex..."
    command npm install -g @openai/codex@latest > /dev/null
  }

  update-codex() {
    _update_codex
    reload
  }

  uninstall-codex() {
    info "Uninstalling codex..."
    command npm uninstall -g @openai/codex > /dev/null
    command rm -rf -- "$CODEX_HOME"
    reload
  }

  updates+=(_update_codex)
else
  install-codex() {
    info "Installing codex..."
    command npm install -g @openai/codex@latest > /dev/null
    command mkdir -p -- "$CODEX_PROMPTS_DIR"
    reload
  }
fi
