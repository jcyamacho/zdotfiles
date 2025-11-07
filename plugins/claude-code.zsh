# Claude Code CLI: https://www.anthropic.com/claude-code

if exists claude; then
  uninstall-claude-code() {
    info "Uninstalling claude..."
    command rm "$(which claude)"
    command rm -rf "$HOME/.local/share/claude"
    reload
  }

  update-claude-code() {
    info "Updating claude code..."
    claude update
  }

  updates+=(update-claude-code)
else
  install-claude-code() {
    info "Installing claude code..."
    curl -fsSL https://claude.ai/install.sh | bash
    info "Intelligent automation and multi-agent orchestration for Claude Code: https://github.com/wshobson/agents"
    reload
  }
fi
