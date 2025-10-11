# Codex CLI: https://developers.openai.com/codex/cli
export CODEX_HOME="$HOME/.codex"
export CODEX_PROMPTS_DIR="$CODEX_HOME/prompts"
export CODEX_SECURE_MODE=1

if exists codex; then
  cdx() {
    codex --search --sandbox workspace-write --ask-for-approval on-request "$@"
  }

  codex-config() {
    $EDITOR "$CODEX_HOME"
  }
fi

if ! exists npm; then
  return
fi

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
