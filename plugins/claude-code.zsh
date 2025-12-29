# Claude Code CLI: https://www.anthropic.com/claude-code
export CLAUDE_HOME="$HOME/.claude"

if exists claude; then
  uninstall-claude-code() {
    info "Uninstalling claude..."
    command rm -f -- "${commands[claude]}"
    command rm -rf -- "$HOME/.local/share/claude"
    command rm -rf -- "$CLAUDE_HOME"
    reload
  }

  claude-config() {
    edit "$CLAUDE_HOME"
  }

  update-claude-code() {
    info "Updating claude code..."
    command claude update
  }

  updates+=(update-claude-code)
else
  install-claude-code() {
    info "Installing claude code..."
    _run_remote_installer "https://claude.ai/install.sh" "bash"
    info "Intelligent automation and multi-agent orchestration for Claude Code: https://github.com/wshobson/agents"
    reload
  }
fi
