# Claude Code CLI: https://www.anthropic.com/claude-code

if exists claude; then
  uninstall-claude-code() {
    info "Uninstalling claude..."
    command rm -f -- "${commands[claude]}"
    command rm -rf -- "$HOME/.local/share/claude"
    command rm -rf -- "$HOME/.claude"
    reload
  }

  update-claude-code() {
    info "Updating claude code..."
    command claude update
  }

  updates+=(update-claude-code)
else
  install-claude-code() {
    info "Installing claude code..."
    command curl -fsSL https://claude.ai/install.sh | command bash
    info "Intelligent automation and multi-agent orchestration for Claude Code: https://github.com/wshobson/agents"
    reload
  }
fi
