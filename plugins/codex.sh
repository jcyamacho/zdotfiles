# Codex CLI: https://developers.openai.com/codex/cli
export CODEX_HOME="$HOME/.codex"
export CODEX_PROMPTS_DIR="$CODEX_HOME/prompts"
export CODEX_SECURE_MODE=1

_install_codex() {
  if (( ! $+commands[npm] )); then
    error "npm is not installed"
    return 1
  fi

  npm install -g @openai/codex@latest > /dev/null
}

if (( $+commands[codex] )); then
  cdx() {
    codex --search --sandbox workspace-write --ask-for-approval on-request "$@"
  }

  update-codex() {
    info "Updating codex..."
    _install_codex
  }

  uninstall-codex() {
    info "Uninstalling codex..."
    npm uninstall -g @openai/codex > /dev/null
    rm -rf "$CODEX_HOME"
    reload
  }

  codex-config() {
    $EDITOR "$CODEX_HOME"
  }

  updates+=(update-codex)
else
  install-codex() {
    info "Installing codex..."
    _install_codex
    mkdir -p "$CODEX_PROMPTS_DIR"
    reload
  }
fi
