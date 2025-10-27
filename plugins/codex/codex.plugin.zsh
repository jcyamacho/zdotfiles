# Codex CLI: https://developers.openai.com/codex/cli
export CODEX_HOME="$HOME/.codex"
export CODEX_PROMPTS_DIR="$CODEX_HOME/prompts"
export CODEX_SECURE_MODE=1

if exists codex; then
  cdx() {
    codex --search --sandbox workspace-write --ask-for-approval on-request "$@"
  }

  codex-config() {
    edit "$CODEX_HOME"
  }
fi

# prioritize brew install
if exists brew; then
  source "$ZDOTFILES_DIR/plugins/codex/codex-brew.zsh"
elif exists npm; then
  source "$ZDOTFILES_DIR/plugins/codex/codex-npm.zsh"
fi
