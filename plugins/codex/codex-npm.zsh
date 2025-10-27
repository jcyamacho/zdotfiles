if exists codex; then
  update-codex() {
    info "Updating codex..."
    npm install -g @openai/codex@latest > /dev/null
  }

  uninstall-codex() {
    info "Uninstalling codex..."
    npm uninstall -g @openai/codex > /dev/null
    command rm -rf "$CODEX_HOME"
    reload
  }

  updates+=(update-codex)
else
  install-codex() {
    info "Installing codex..."
    npm install -g @openai/codex@latest > /dev/null
    command mkdir -p "$CODEX_PROMPTS_DIR"
    reload
  }
fi
