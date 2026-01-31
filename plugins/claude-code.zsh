# Claude Code CLI: https://www.anthropic.com/claude-code
if exists claude; then
  (( $+_claude_home )) || typeset -gr _claude_home="$HOME/.claude"

  uninstall-claude-code() {
    info "Uninstalling claude..."
    command rm -f -- "${commands[claude]}"
    command rm -rf -- "$HOME/.local/share/claude"
    command rm -rf -- "$HOME/.claude-worktrees"
    command rm -rf -- "$_claude_home"
    reload
  }

  claude-config() {
    edit "$_claude_home"
  }

  _update_claude_code() {
    info "Updating claude code..."
    command claude update
  }

  update-claude-code() {
    _update_claude_code
    reload
  }

  cc() {
    # OSC 11: set background to dark gray
    printf '\033]11;#1e1e1e\033\\'
    clear
    command claude "$@"
    # OSC 111: reset background to terminal default
    printf '\033]111\033\\'
  }

  updates+=(_update_claude_code)
else
  install-claude-code() {
    info "Installing claude code..."
    _run_remote_installer "https://claude.ai/install.sh" "bash"
    info "Intelligent automation and multi-agent orchestration for Claude Code: https://github.com/wshobson/agents"
    reload
  }
fi
